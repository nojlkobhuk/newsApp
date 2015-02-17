//
//  News.h
//  radioNOD
//
//  Created by Sergey Zhurbenko on 16.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Settings;

@interface News : NSManagedObject

@property (nonatomic, retain) NSNumber * innerID;
@property (nonatomic, retain) NSString * ndesc;
@property (nonatomic, retain) NSString * nlink;
@property (nonatomic, retain) NSString * ncity;
@property (nonatomic, retain) NSString * ncountry;
@property (nonatomic, retain) NSString * npream;
@property (nonatomic, retain) NSString * npubDate;
@property (nonatomic, retain) NSString * nreadFlag;
@property (nonatomic, retain) NSString * ntitle;
@property (nonatomic, retain) NSString * nvideopicture;
@property (nonatomic, retain) NSString * nvideo;
@property (nonatomic, retain) NSData * thumbnailImageData;
@property (nonatomic, retain) NSString * thumbnailURLString;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) NSString * nregion;
@property (nonatomic, retain) NSString * ncategory;
@property (nonatomic, retain) Settings *myregion;

@property NSDictionary *thumbnailDictionary;

+ (NSInteger)allCharsCountWithContext:(NSManagedObjectContext *)managedObjectContext;
+ (News *)charWithManagedObjectContext:(NSManagedObjectContext *)context andInnerID:(NSInteger)charInnerID;


@end
