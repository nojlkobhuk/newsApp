//
//  NODRSSDetailViewController.h
//  radioNOD
//
//  Created by in5630 on 14.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NODParseList.h"

@interface NODRSSDetailViewController : UIViewController {
    IBOutlet UILabel *gdescription;
    IBOutlet UILabel *gcategory;
    IBOutlet UILabel *glink;
    IBOutlet UILabel *gpubDate;
}
@property (nonatomic, strong) NODParseList *detailList;

@end
