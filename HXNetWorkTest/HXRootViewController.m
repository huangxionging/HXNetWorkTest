//
//  HXRootViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXRootViewController.h"
#import "HXCategoryViewController.h"

@interface HXRootViewController ()

@end

@implementation HXRootViewController

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
    
    [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(changeViewController) userInfo: nil repeats: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeViewController
{
    HXCategoryViewController *categoryViewController = [[HXCategoryViewController alloc] init];
    
    UINavigationController *category = [[UINavigationController alloc] initWithRootViewController: categoryViewController];
    
    [self presentViewController: category animated: NO completion:^
    {
        NSLog(@"切换视图控制器");
    }];
}

@end
