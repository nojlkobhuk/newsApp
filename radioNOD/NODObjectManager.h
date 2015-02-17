//
//  NODObjectManager.h
//  radioNOD
//
//  Created by in5630 on 05.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "News.h"
#import "Settings.h"

@interface NODObjectManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) UIManagedDocument *document;

- (NSManagedObjectContext *)managedObjectContext;
+ (void)jsonParseNews:(News *)newsDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)configureWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel;
+ (NSURL *)URLForMeetings:(NSString *)query;
+ (NSURL *)URLForNews:(NSString *)query;
+ (NODObjectManager *)manager;

- (void)getNODObjectsAtPath:(NSString *)path
                    parameters:(NSDictionary *)params
                       success:(void (^) (RKObjectRequestOperation * operation, RKMappingResult * mappingResult)) success
                       failure:(void (^) (RKObjectRequestOperation * operation, NSError * error))failure;

- (void)        addMappingForEntityForName:(NSString *)entityName
        andAttributeMappingsFromDictionary:(NSDictionary *)attributeMappings
               andIdentificationAttributes:(NSArray *)ids
                            andPathPattern:(NSString *)pathPattern;

@end
