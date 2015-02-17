//
//  NODDetailScrollViewController.h
//  radioNOD
//
//  Created by Sergey Zhurbenko on 16.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NODDetailScrollViewController : UIViewController {
        IBOutlet UIWebView *webscrolldescription;
}
@property NSIndexPath *detailIndexPath;

@end
