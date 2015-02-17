//
//  News.m
//  radioNOD
//
//  Created by Sergey Zhurbenko on 16.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "News.h"
#import "Settings.h"


@implementation News

@dynamic innerID;
@dynamic ndesc;
@dynamic nlink;
@dynamic ncity;
@dynamic ncountry;
@dynamic npream;
@dynamic npubDate;
@dynamic nreadFlag;
@dynamic ntitle;
@dynamic nvideopicture;
@dynamic nvideo;
@dynamic thumbnailImageData;
@dynamic thumbnailURLString;
@dynamic unique;
@dynamic nregion;
@dynamic ncategory;
@dynamic myregion;

@synthesize thumbnailDictionary;

#pragma mark - Class Methods

// Gets count for all saved CoreData "Character" objects.
+ (NSInteger)allCharsCountWithContext:(NSManagedObjectContext *)managedObjectContext
{
	NSUInteger retVal;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	NSError *err;
	retVal = [managedObjectContext countForFetchRequest:request error:&err];
    
	if (err)
		NSLog(@"Error: %@", [err localizedDescription]);
    
	return retVal;
}

// Returns a "Character" CoreData object for specified innerID attribute.
+ (News *)charWithManagedObjectContext:(NSManagedObjectContext *)context andInnerID:(NSInteger)charInnerID
{
	News *retVal = nil;
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:context];
	[request setEntity:entity];
	NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"innerID = %d", charInnerID];
	[request setPredicate:searchFilter];
    
	NSError *err;
	NSArray *results = [context executeFetchRequest:request error:&err];
	if (results.count > 0)
		retVal = [results objectAtIndex:0];
    
	if (err)
		NSLog(@"Error: %@", [err localizedDescription]);
    
	return retVal;
}

- (News *)lastLoadedChar:(NSManagedObjectContext *)managedObjectContext
{
    News *retVal = nil;
    
    
    return retVal;
}

#pragma mark - Getters & Setters

- (void)setThumbnailDictionary:(NSDictionary *)dict
{
	if (!dict)
		return;
    
	thumbnailDictionary = dict;
	self.thumbnailURLString = [NSString stringWithFormat:@"%@.%@", thumbnailDictionary[@"path"], thumbnailDictionary[@"extension"]];
}

- (NSDictionary *)thumbnailDictionary
{
	return thumbnailDictionary;
}

@end
