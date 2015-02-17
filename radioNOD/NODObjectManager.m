//
//  NODObjectManager.m
//  radioNOD
//
//  Created by in5630 on 05.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "NODObjectManager.h"


@implementation NODObjectManager {
	RKObjectManager *objectManager;
	RKManagedObjectStore *managedObjectStore;
}

//-(id) initWithURL:(NSURL *)baseURL {
- (id)init
{
    self = [super init];
	if (self) {
        // Инициализация AFNetworking HTTPClient
        //
        NSURL *baseURL = [NSURL URLWithString:NOD_API_BASEPOINT];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        //objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
        //Инициализация
        objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    }
    
    return self;
}

- (void)configureWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel
{
	NSAssert(managedObjectModel, @"managedObjectModel can't be nil");
    
	// Initialize CoreData store & contexts.
	managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
	NSError *error;
	if (!RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error))
		NSLog(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    
	NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"RKNOD.sqlite"];
	if (![managedObjectStore addSQLitePersistentStoreAtPath:path
	                                 fromSeedDatabaseAtPath:nil
	                                      withConfiguration:nil options:nil error:&error])
		NSLog(@"Failed adding persistent store at path '%@': %@", path, error);
    
	[managedObjectStore createManagedObjectContexts];
    
	// Link RestKit the generated object store with RestKit's object manager.
	objectManager.managedObjectStore = managedObjectStore;
}

- (void)        addMappingForEntityForName:(NSString *)entityName
        andAttributeMappingsFromDictionary:(NSDictionary *)attributeMappings
               andIdentificationAttributes:(NSArray *)ids
                            andPathPattern:(NSString *)pathPattern
{
	if (!managedObjectStore)
		return;
    
	// Create mapping for the particular entity.
	RKEntityMapping *objectMapping = [RKEntityMapping mappingForEntityForName:entityName
	                                                     inManagedObjectStore:managedObjectStore];
	[objectMapping addAttributeMappingsFromDictionary:attributeMappings];
	objectMapping.identificationAttributes = ids;
    
    
	// Register mappings with the provider using a response descriptor.
	RKResponseDescriptor *characterResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:[NSString stringWithFormat:@"%@%@", NOD_API_PATH_PATTERN, pathPattern]
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
	[objectManager addResponseDescriptor:characterResponseDescriptor];
}

- (NSManagedObjectContext *)managedObjectContext
{
	return managedObjectStore.mainQueueManagedObjectContext;
}

- (void)getNODObjectsAtPath:(NSString *)path
                    parameters:(NSDictionary *)params
                       success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                       failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    
    // Непосредственный вызов метода у объекта objectManager с вновь собранными параметрами
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"%@%@", NOD_API_PATH_PATTERN, path]
                         parameters:params
                            success:success
                            failure:failure];
}

+ (NODObjectManager *)manager
{
	static NODObjectManager *manager = nil;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
        manager = [[NODObjectManager alloc] init];
    });
	return manager;
}

+ (void)jsonParseNews:(News *)newsDictionary
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    News *news = nil;
    NSNumber *unique = newsDictionary.unique;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"News"];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error ||([matches count] > 1)) {
        NSLog(@"Error with matches %d", matches.count);
    } else if ([matches count]) {
        news = [matches firstObject];
        NSLog(@"News coincidence");
    } else {
        news = [NSEntityDescription insertNewObjectForEntityForName:@"News"
                                             inManagedObjectContext:context];
        NSLog(@"New news");
        news.unique = unique;
        news.ntitle = newsDictionary.ntitle;
        news.nlink = newsDictionary.nlink;
        news.npubDate = newsDictionary.npubDate;
        //news.nnewsURL = newsDictionary.nnewsURL;
        
        
    }
}

+ (NSURL *)URLForMeetings:(NSString *)query
{
    query = [NSString stringWithFormat:@"http://rusnod.ru/rss/mitn.php?%@", query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}

+ (NSURL *)URLForNews:(NSString *)query
{
    query = [NSString stringWithFormat:@"http://rusnod.ru/rss/news.php?%@", query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}

-(void) loadDocument:(NSURL *)queryURL {
    self.document = [[UIManagedDocument alloc] initWithFileURL:queryURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[queryURL path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            //if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn`t open document at %@", queryURL);
        }];
    } else {
        [self.document saveToURL:queryURL forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   //if (success) [self documentIsReady];
                   //if (!success) NSLog(@"couldn`t create document at %@", queryURL);
               }];
    }
}

-(void) documentIsReady:(NSManagedObjectContext *)context {
    if (self.document.documentState == UIDocumentStateNormal) {
        // start using document
        //NSManagedObjectContext *context = self.document.managedObjectContext;
        News *object = [NSEntityDescription insertNewObjectForEntityForName:@"News"
                                                                inManagedObjectContext:context];
        object.ntitle = @"Testoid";
        //object.ntype = @"Testville";
        object.nlink = @"Testland";
        Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings"
                                                           inManagedObjectContext:context];
        settings.region = object.nlink;
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        // Test listing all FailedBankInfos from the store
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"News"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (News *info in fetchedObjects) {
            NSLog(@"Name: %@", info.ntitle);
            Settings *details = info.myregion;
            NSLog(@"Zip: %@", details.country);
        }
        
        
    }
}

-(void) readDocument {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.document.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"News"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *myregion in fetchedObjects) {
        NSLog(@"category %@", [myregion valueForKey:@"category"]);
        NSManagedObject *mynews = [myregion valueForKey:@"mynews"];
        NSLog(@"city %@", [mynews valueForKey:@"city"]);
        
    }
}


@end
