//
//  NODRSSDetailViewController.h
//  radioNOD
//
//  Created by in5630 on 14.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NODParseList.h"
#import "News.h"
#import "Settings.h"

@interface NODRSSDetailViewController : UIViewController {
    IBOutlet UIWebView *webdescription;
    IBOutlet UILabel *gcategory;
    IBOutlet UILabel *glink;
    IBOutlet UILabel *gpubDate;
    IBOutlet UILabel *gdescription;
}
@property (nonatomic, strong) NODParseList *detailList;
@property (nonatomic, strong) News *newsList;

@end
