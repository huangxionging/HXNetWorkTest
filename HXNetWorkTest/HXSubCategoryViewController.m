//
//  HXSubCategoryViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXSubCategoryViewController.h"
#import "HXProductModel.h"
#import "HXDetailViewController.h"

@interface HXSubCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HXSubCategoryViewController

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
    
    self.navigationItem.title = _subCategoryModel.name;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark---设置子分类表视图

- (void) setTableView
{
    _subCategoryTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, SCREEN_HEIGHT - 64) style: UITableViewStyleGrouped];
    
    _subCategoryTableView.dataSource = self;
    
    _subCategoryTableView.delegate = self;
    
    
    [self.view addSubview: _subCategoryTableView];
}


#pragma mark---UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _subCategoryModel.subList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = ((HXProductModel *)_subCategoryModel.subList[indexPath.section]).name;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXDetailViewController *detailViewController = [[HXDetailViewController alloc] init];
    
    detailViewController.productModel = _subCategoryModel.subList[indexPath.section];
    
    [self.navigationController pushViewController: detailViewController animated: NO];
}

#pragma mark--析构
- (void) dealloc
{
    _subCategoryModel = nil;
    
    _subCategoryTableView = nil;
}

@end
