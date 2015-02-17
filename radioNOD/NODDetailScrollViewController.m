//
//  NODDetailScrollViewController.m
//  radioNOD
//
//  Created by Sergey Zhurbenko on 16.02.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "NODDetailScrollViewController.h"
#import "NODObjectManager.h"

@interface NODDetailScrollViewController ()

@end

@implementation NODDetailScrollViewController

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
    // Do any additional setup after loading the view.
    NSInteger row = self.detailIndexPath.row;
    News *curCharacter = [News charWithManagedObjectContext:
                          [[NODObjectManager manager] managedObjectContext]
                                                 andInnerID:row];
    if (curCharacter)
    {
        self.title = curCharacter.ntitle;
        NSURL* url = [NSURL URLWithString:curCharacter.nlink];
        NSURLRequest *reply = [[NSURLRequest alloc]initWithURL:url];
        NSLog(@"body %@", reply);
        [webscrolldescription loadHTMLString:curCharacter.ndesc baseURL:url];
        
    }

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
