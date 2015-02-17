//
//  NODScrollViewController.h
//  radioNOD
//
//  Created by in5630 on 22.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NODScrollViewController : UITableViewController
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) NSURL * imageURL;

- (void)animateActivityIndicator:(BOOL)animate;

@end
