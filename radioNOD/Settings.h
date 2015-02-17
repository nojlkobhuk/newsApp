//
//  Settings.h
//  radioNOD
//
//  Created by in5630 on 05.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSSet *mynews;
@property (nonatomic, retain) NSSet *mymeeting;
@end

@interface Settings (CoreDataGeneratedAccessors)

+ (void)addMynewsObject:(NSManagedObject *)value;
- (void)removeMynewsObject:(NSManagedObject *)value;
- (void)addMynews:(NSSet *)values;
- (void)removeMynews:(NSSet *)values;

- (void)addMymeetingObject:(NSManagedObject *)value;
- (void)removeMymeetingObject:(NSManagedObject *)value;
- (void)addMymeeting:(NSSet *)values;
- (void)removeMymeeting:(NSSet *)values;

@end
