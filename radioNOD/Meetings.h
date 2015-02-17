//
//  Meetings.h
//  radioNOD
//
//  Created by in5630 on 05.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Settings;

@interface Meetings : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * organizator;
@property (nonatomic, retain) NSString * pubDate;
@property (nonatomic, retain) NSString * readFlag;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Settings *myregion;



@end
