//
//  NODRSSViewController.h
//  radioNOD
//
//  Created by in5630 on 13.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NODAppDelegate.h"
#import "NODParseList.h"
#import "NODJSONParser.h"

@interface NODRSSViewController : UITableViewController
@property (nonatomic, retain) NODAppDelegate *app;
@property (nonatomic, retain) NODParseList *list;
@end
