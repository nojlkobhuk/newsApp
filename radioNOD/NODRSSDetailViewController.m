//
//  NODRSSDetailViewController.m
//  radioNOD
//
//  Created by in5630 on 14.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "NODRSSDetailViewController.h"

@interface NODRSSDetailViewController ()

@end

@implementation NODRSSDetailViewController
@synthesize detailList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = detailList.category;
    
    NSURL* url = [NSURL URLWithString:detailList.link];
    NSURLRequest *reply = [[NSURLRequest alloc]initWithURL:url];
    NSLog(@"body %@", reply);
    [webdescription loadHTMLString:detailList.description baseURL:url];
    
    gdescription.text = detailList.description;
    
    gcategory.text = detailList.category;
    
    glink.text = detailList.link;
    
    gpubDate.text = detailList.pubDate;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*

 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
