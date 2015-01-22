//
//  HXDetailViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXDetailViewController.h"
#import "HXDetailModel.h"
#import "HXDetailCell.h"
#import "HXShopViewController.h"
#import "HXProductViewController.h"
#import "HXNetWork.h"
#import "HXMainDataBase.h"


static NSInteger once = 0;

@interface HXDetailViewController ()<NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, HXDetailCellDelegate, HXNetWorkDelegate, MJRefreshBaseViewDelegate>

@end

@implementation HXDetailViewController

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
             NSString *sqlString = [NSString stringWithFormat: @"create table if not exists Detail%@(ID integer unique, Detail blob)", detailModel.categoryID];
             
             if (![db executeUpdate: sqlString])
             {
                 NSLog(@"创建表失败");
             }
         }];
    }
    
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject: detailModel];
         
         NSString *sqlString = [NSString stringWithFormat: @"insert into Detail%@ values(?,?)", detailModel.categoryID];
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
        NSString *sqlString = [NSString stringWithFormat: @"select *from Detail%@", ID];
        
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _detailDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = _productModel.name;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"返回" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
     _detailDataArray = [HXDetailViewController selectFromDatabaseWithID: [NSNumber numberWithInteger: _productModel.ID.integerValue]];
    
    if (_detailDataArray.count == 0)
    {
        [[HXNetWork shareNetWork] requestWithURLString: LINK_URL_DETAIL(_productModel.ID, _page) andDelegate: self];
    }
    
    [self setTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark---设置TableView
- (void) setTableView
{
    _detailTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, SCREEN_HEIGHT - 64) style: UITableViewStylePlain];
    
    _detailTableView.dataSource = self;
    
    _detailTableView.delegate = self;
    
    [self.view addSubview: _detailTableView];
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _detailTableView andDelegate: self];
    
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _detailTableView andDelegate: self];

    [_headRefreshView endRefreshing];
    [_footRefreshView endRefreshing];
    
}

#pragma mark---MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseView = refreshView;
    
    if (refreshView == _headRefreshView)
    {
        _page = 0;
    }
    else
    {
        ++_page;
    }
    [[HXNetWork shareNetWork] requestWithURLString: LINK_URL_DETAIL(_productModel.ID, _page) WithFinished:^(NSData *responseData)
    {
        NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: nil];
            
        if (_page == 0)
        {
            [[HXMainDataBase shareDatabase] clearTableWithName: [NSString stringWithFormat: @"Detail%@", _productModel.ID]];
        }
        
        if (dicts == nil)
        {
            [self endRefreshing];
            return;
        }
        
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
            
            // 分类ID
            detailModel.categoryID = _productModel.ID;
            
            // 添加到数组
            
            [HXDetailViewController insertIntoDatabaseWith: detailModel];
        }
        
        [self endRefreshing];
    }
    orFailed:^(NSError *error)
    {
        [self endRefreshing];
        NSLog(@"%@", error);
    }];
}

- (void) endRefreshing
{
    if (_baseView == _headRefreshView)
    {
        [_headRefreshView endRefreshing];
    }
    else
    {
        [_footRefreshView endRefreshing];
    }
    _detailDataArray = [HXDetailViewController selectFromDatabaseWithID: [NSNumber numberWithInteger: _productModel.ID.integerValue]];
    [_detailTableView reloadData];
}


#pragma mark---UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailDataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    
    HXDetailCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil)
    {
        cell = [[HXDetailCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    }
    
    [cell setDetailCell: _detailDataArray[indexPath.row]];
    
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark---UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXProductViewController *productViewController = [[HXProductViewController alloc] init];
    
    productViewController.concreteModel.detailModel = _detailDataArray[indexPath.row];
    
    
    [self.navigationController pushViewController: productViewController animated: NO];
}


#pragma mark---HXDetailCellDelegate

- (void) detailCellButtonClickedWithIndexPath:(NSIndexPath *)indexPath
{
    HXShopViewController *shopViewController = [[HXShopViewController alloc] init];
    
    // 得到商店的ID
    shopViewController.ID = [NSNumber numberWithInteger: ((HXDetailModel *)_detailDataArray[indexPath.row]).shopID.integerValue];
    
    [self.navigationController pushViewController: shopViewController animated: NO];
}


- (void)dealloc
{
    NSLog(@"销毁");
    _productModel = nil;
    
    _detailDataArray = nil;
    
    // 移除监听
    [_headRefreshView free];
    
    // 移除监听
    [_footRefreshView free];
    
    [self.view removeFromSuperview];
    
    once = 0;
}

@end
