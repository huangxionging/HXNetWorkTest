//
//  HXShopAllProductViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-26.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXShopAllProductViewController.h"
#import "HXDetailModel.h"
#import "HXDetailCell.h"
#import "HXNetWork.h"
#import "HXMainDataBase.h"
#import "HXProductViewController.h"

static NSInteger once = 0;

@interface HXShopAllProductViewController ()

@end

@implementation HXShopAllProductViewController

#pragma mark---类方法插入数据库
+ (void) insertIntoDatabaseWith: (HXDetailModel *)detailModel;
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 第一次先创建表
    
    if (once++ == 0)
    {
        [dataBaseQueue inDatabase:^(FMDatabase *db)
         {
             NSString *sqlString = [NSString stringWithFormat: @"create table if not exists ShopAllProduct%@(ID integer unique, Detail blob)", detailModel.shopID];
             
             if (![db executeUpdate: sqlString])
             {
                 NSLog(@"创建表失败");
             }
         }];
    }
    
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject: detailModel];
         
         NSString *sqlString = [NSString stringWithFormat: @"insert into ShopAllProduct%@ values(?,?)", detailModel.shopID];
         if (![db executeUpdate: sqlString, detailModel.ID, data])
         {
             NSLog(@"插入失败");
         }
     }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
}

#pragma mark---使用类方法查询数据
+ (NSMutableArray *) selectFromDatabaseWithID: (NSNumber *)ID
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 创建动态数组
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"select *from ShopAllProduct%@", ID];
         
         FMResultSet *result = [db executeQuery: sqlString];
         
         while ([result next])
         {
             [temp addObject: [NSKeyedUnarchiver unarchiveObjectWithData: [result dataForColumn: @"Detail"]]];
         }
         
         [result close];
     }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
    
    return temp;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle: style];
    if (self) {
        // Custom initialization
        _shopAllProductArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 添加到数组
    _shopAllProductArray = [HXShopAllProductViewController selectFromDatabaseWithID: _ID];
    
    NSLog(@"%@", _ID);
    if (_shopAllProductArray.count == 0)
    {
        [[HXNetWork shareNetWork] requestWithURLString: LINK_SHOP_ALL(_ID) WithFinished:^(NSData *responseData)
         {
             NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: nil];
             
             for (NSDictionary *sub in dicts[@"List"])
             {
                 HXDetailModel *detailModel = [[HXDetailModel alloc] init];
                 
                 // 名字
                 detailModel.name = sub[@"name"];
                 
                 // 原价
                 detailModel.originalPrice = sub[@"originalPrice"];
                 
                 // 现价
                 detailModel.price = sub[@"price"];
                 
                 //图片地址
                 detailModel.imageURL = sub[@"img"];
                 
                 // 连接地址
                 detailModel.linkURL = sub[@"url"];
                 
                 // 月销量
                 detailModel.account = sub[@"act"];
                 
                 // ID
                 detailModel.ID = sub[@"ID"];
                 
                 // 店铺名字
                 detailModel.shopName = sub[@"nick"];
                 
                 // 店铺ID
                 detailModel.shopID = sub[@"ShopID"];
                 
                 // 区域
                 detailModel.area = sub[@"area"];
                 
                 // 运费
                 
                 detailModel.freight = sub[@"freight"];
                 
                 if ([sub[@"freight"] isEqualToString: @""])
                 {
                     detailModel.freight = @"0";
                 }
                 
                 NSLog(@"%@", detailModel.shopID);
                 
                 // 添加到数据库
                 [HXShopAllProductViewController insertIntoDatabaseWith:detailModel];
             }
             
             
             _shopAllProductArray = [HXShopAllProductViewController selectFromDatabaseWithID: _ID];
             
             [self refreshView];
         }
         orFailed:^(NSError *error)
         {
             NSLog(@"%@", error);
         }];
    }
    else
    {
        [self refreshView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) refreshView
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of sections.
    return _shopAllProductArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HXDetailCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HXDetailCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.shopName removeFromSuperview];
    }
    
    // Configure the cell...
    [cell setDetailCell: _shopAllProductArray[indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXProductViewController *productViewController = [[HXProductViewController alloc] init];
    
    productViewController.concreteModel.detailModel = _shopAllProductArray[indexPath.row];
    
    
    [self.navigationController pushViewController: productViewController animated: NO];
}

- (void) dealloc
{
    _shopAllProductArray = nil;
    once = 0;
}

@end
