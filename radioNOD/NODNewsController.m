//
//  NODNewsController.m
//  radioNOD
//
//  Created by in5630 on 19.12.14.
//  Copyright (c) 2014 zhurbenko inc. All rights reserved.
//

#import "NODNewsController.h"

@interface NODNewsController ()
@property (weak, nonatomic) IBOutlet UIWebView *webContent;

@end

@implementation NODNewsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL* url = [NSURL URLWithString:@"http://rusnod.ru/news.html"];
    NSURLRequest *reply = [[NSURLRequest alloc]initWithURL:url];
    NSLog(@"body %@", reply);
    [self.webContent loadRequest:reply];
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
