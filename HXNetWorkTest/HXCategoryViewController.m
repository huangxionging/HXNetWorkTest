//
//  HXCategoryViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXCategoryViewController.h"
#import "HXCategoryModel.h"
#import "HXSubCategoryModel.h"
#import "HXProductModel.h"
#import "HXSubCategoryViewController.h"
#import "HXNetWork.h"
#import "HXMainDataBase.h"
#import "HXDetailViewController.h"

#define TAG_BUTTON (100)

@interface HXCategoryViewController ()<HXNetWorkDelegate>

@end

@implementation HXCategoryViewController

#pragma mark---使用类方法插入数据库
+ (void) insertIntoDatabaseWith: (HXCategoryModel *)categoryModel
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 第一次先创建表
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [dataBaseQueue inDatabase:^(FMDatabase *db)
        {
            if (![db executeUpdate: @"create table if not exists Category(ID integer unique, category blob)"])
            {
                NSLog(@"创建表失败");
            }
        }];
    });
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: categoryModel];
        
        if (![db executeUpdate: @"insert into Category values(?,?)", categoryModel.ID, data])
        {
           NSLog(@"插入失败");
        }
    }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
}

#pragma mark---使用类方法查询数据
+ (NSMutableArray *) selectFromDatabaseWithPage: (NSInteger) page
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 创建动态数组
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
    {
        FMResultSet *result = [db executeQuery: @"select *from Category"];
        
        while ([result next])
        {
            [temp addObject: [NSKeyedUnarchiver unarchiveObjectWithData: [result dataForColumn: @"category"]]];
        }
        
        [result close];
    }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
    
    return temp;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
      //  _categoryDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"宝贝分类";
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"刷新" style: UIBarButtonItemStyleBordered target: self action: @selector(connectionNet)];
    
    [self setTableView];
    
    _categoryDataArray = [HXCategoryViewController selectFromDatabaseWithPage: 0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---刷新按钮事件响应
- (void) connectionNet
{
    [[HXNetWork shareNetWork] requestWithURLString: LINK_URL andDelegate: self];
}

#pragma mark---设置表视图

- (void) setTableView
{
    _categoryTableVie = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, SCREEN_HEIGHT - 64) style: UITableViewStyleGrouped];
    
    _categoryTableVie.dataSource = self;
    
    _categoryTableVie.delegate = self;
    
    [self.view addSubview: _categoryTableVie];
}

#pragma mark---刷新表视图

- (void) refreshView
{
    _categoryDataArray = [HXCategoryViewController selectFromDatabaseWithPage: 0];
    [_categoryTableVie reloadData];
}

#pragma mark---HXNetWorkDelegate
- (void) netWorkConnectFinishedWithData:(NSData *)responseData
{
    NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: nil];
    
    [[HXMainDataBase shareDatabase] clearTableWithName: @"Category"];
    
    for (NSDictionary *sub in dicts[@"List"])
    {
        HXCategoryModel *categoryModel = [[HXCategoryModel alloc] init];

        // 名字
        categoryModel.name = sub[@"Name"];
        
        // ID
        categoryModel.ID = sub[@"ID"];
        
        for (NSDictionary *tempDict in sub[@"List"])
        {
            HXSubCategoryModel *subCategoryModel = [[HXSubCategoryModel alloc] init];
            
            // 名字
            subCategoryModel.name = tempDict[@"Name"];
            
            // ID
            subCategoryModel.ID = tempDict[@"ID"];
            
            for (NSDictionary *subTempDict in tempDict[@"List"])
            {
                HXProductModel *productModel = [[HXProductModel alloc] init];
                
                // 名字
                productModel.name = subTempDict[@"Name"];
                
                // ID
                productModel.ID = subTempDict[@"ID"];
                
                [subCategoryModel.subList addObject: productModel];
            }
            
            [categoryModel.list addObject: subCategoryModel];
        }
        
       [HXCategoryViewController insertIntoDatabaseWith: categoryModel];
    }
    
    // 释放内存
    dicts = nil;
    
    // 刷新表
    [self refreshView];
}

#pragma mark---UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HXCategoryModel *categoryModel = (HXCategoryModel *)_categoryDataArray[section];
    
    if (categoryModel.isFold == YES)
    {
        return 0;
    }
    else
    {
        return categoryModel.list.count;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _categoryDataArray.count;
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
    
    HXCategoryModel *categoryModel = _categoryDataArray[indexPath.section];
    
    HXSubCategoryModel *subCategoryModel = categoryModel.list[indexPath.row];
    
    cell.textLabel.text = subCategoryModel.name;
    
    return cell;
}

#pragma mark---UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 透视图为按钮
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [button setBackgroundImage: [UIImage imageNamed: @"topbg"] forState: UIControlStateNormal];
    
    button.showsTouchWhenHighlighted = YES;
    
    [button setTitle: ((HXCategoryModel *)_categoryDataArray[section]).name forState: UIControlStateNormal];
    
    [button addTarget: self action: @selector(fold:) forControlEvents: UIControlEventTouchUpInside];
    
    button.tag = section + TAG_BUTTON;
    
    return button;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSubCategoryViewController *subCategoryViewController = [[HXSubCategoryViewController alloc] init];
    
    subCategoryViewController.subCategoryModel = ((HXCategoryModel *)_categoryDataArray[indexPath.section]).list[indexPath.row];
    
    [self.navigationController pushViewController: subCategoryViewController animated: NO];
    
//    HXDetailViewController *ctrl = [[HXDetailViewController alloc] init];
//    
//    ctrl.productModel.ID = ((HXSubCategoryModel *)((HXCategoryModel *)_categoryDataArray[indexPath.section]).list[indexPath.row]).ID;
//    
//    [self.navigationController pushViewController: ctrl animated: NO];
}

#pragma mark---按钮折叠事件

- (void) fold: (UIButton *)sender
{
    NSInteger number = sender.tag - TAG_BUTTON;
    
    HXCategoryModel *categoryModel = _categoryDataArray[number];
    
    categoryModel.isFold = !categoryModel.isFold;
    
    [_categoryTableVie reloadSections: [NSIndexSet indexSetWithIndex: number] withRowAnimation: UITableViewRowAnimationFade];
}

#pragma mark---析构
- (void) dealloc
{
    _categoryDataArray = nil;
    
    _categoryTableVie = nil;
}


@end
