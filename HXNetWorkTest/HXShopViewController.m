//
//  HXShopViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-26.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXShopViewController.h"
#import "HXShopAllProductViewController.h"
#import "HXNetWork.h"
#import "HXMainDataBase.h"

@interface HXShopViewController ()

@end

@implementation HXShopViewController

#pragma mark---类方法插入数据库
+ (void) insertIntoDatabaseWith: (HXShopModel *)shopModel;
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
           NSString *sqlString = [NSString stringWithFormat: @"create table if not exists Shop(ID integer unique, shop blob)"];
           
           if (![db executeUpdate: sqlString])
           {
               NSLog(@"创建表失败");
           }
       }];
   });
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject: shopModel];
         
         NSString *sqlString = [NSString stringWithFormat: @"insert into Shop(ID, shop) values(?,?)"];
         if (![db executeUpdate: sqlString, shopModel.ID, data])
         {
             NSLog(@"插入失败");
         }
     }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
}

#pragma mark---使用类方法查询数据
+ (HXShopModel *) selectFromDatabaseWithID: (NSNumber *)ID
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 创建动态数组
    __block HXShopModel *temp = nil;
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"select *from Shop where ID=?"];
         
         FMResultSet *result = [db executeQuery: sqlString, ID];
         
         if ([result next])
         {
             temp = [NSKeyedUnarchiver unarchiveObjectWithData: [result dataForColumn: @"shop"]];
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
    if (self) {
        // Custom initialization
        _shopModel = [[HXShopModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"店铺基本信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"所有宝贝" style: UIBarButtonItemStyleDone target: self action: @selector(click)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"返回" style: UIBarButtonItemStyleDone target: nil action: nil];
    
    if ([HXShopViewController selectFromDatabaseWithID: _ID] == nil)
    {
        [[HXNetWork shareNetWork] requestWithURLString: LINK_SHOP(_ID) WithFinished:^(NSData *responseData)
        {
            NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: nil];
            
            // 解店铺
            NSDictionary *sub = dicts[@"List"][0];
            
            
            // 店铺名
            _shopModel.name = sub[@"Name"];
            
            // 店铺ID
            _shopModel.ID = sub[@"ID"];
            
            
            // 店铺发货速度
            _shopModel.speed = sub[@"Speed"];
            
            // 店铺主页
            _shopModel.linkURL = sub[@"URL"];
            
            // 店铺信用
            _shopModel.credit = sub[@"XinYong"];
            
            // 手机号
            _shopModel.phone = sub[@"Phone"];
            
            // 店铺描述
            _shopModel.descSimilar = sub[@"DescSimilar"];
            
            // 店铺区域
            _shopModel.area = sub[@"Area"];
            
            // 店铺服务
            _shopModel.service = sub[@"Service"];
            
            // 老板名字
            _shopModel.bossName = sub[@"BossName"];
            
            // 人气
            _shopModel.popularity = sub[@"RenQi"];
            
            // 好评率
            _shopModel.goodRate = sub[@"GoodRate"];
            
            // 主营
            _shopModel.majorOperation = sub[@"ZhuYing"];
            
            if ([HXShopViewController selectFromDatabaseWithID: _ID] == nil)
            {
                [HXShopViewController insertIntoDatabaseWith: _shopModel];
            }
            
            
            dicts = nil;
            
            // 刷新
            [self refreshView];
        }
        orFailed:^(NSError *error)
        {
            NSLog(@"%@", error);
        }];
    }
    else
    {
        _shopModel = [HXShopViewController selectFromDatabaseWithID: _ID];
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
    // 描述
    
    NSLog(@"%@\n%@\n%@", _shopModel.descSimilar, _shopModel.speed, _shopModel.service);
    NSArray *array = [_shopModel.descSimilar componentsSeparatedByString: @"|"];
    
    _descSimilar.text = [NSString stringWithFormat: @"描述相符: %@",array[1]];
    
    if ([array[2] floatValue] > 0)
    {
        _trade.text = [NSString stringWithFormat: @"高于同行: %@%%", array[2]];
    }
    else if([array[2] floatValue] < 0)
    {
        _trade.text = [NSString stringWithFormat: @"低于同行: %@%%", [array[2] substringFromIndex:1]];
    }
    else
    {
        _trade.text = @"与同行保持一致";
    }
    
    
    // 发货
    array = [_shopModel.speed componentsSeparatedByString: @"|"];
    
    _speed.text = [NSString stringWithFormat: @"发货速度: %@", array[1]];
    
    if ([array[2] floatValue] > 0)
    {
        _tradeSpeed.text = [NSString stringWithFormat: @"高于同行: %@%%", array[2]];
    }
    else if([array[2] floatValue] < 0)
    {
        _tradeSpeed.text = [NSString stringWithFormat: @"低于同行: %@%%", [array[2] substringFromIndex:1]];
    }
    else
    {
        _tradeSpeed.text = @"与同行保持一致";
    }
    
    // 服务
    array = [_shopModel.service componentsSeparatedByString: @"|"];
    
    _service.text = [NSString stringWithFormat: @"服务态度: %@", array[1]];
    
    if ([array[2] floatValue] > 0)
    {
        _tradeService.text = [NSString stringWithFormat: @"高于同行: %@%%", array[2]];
    }
    else if([array[2] floatValue] < 0)
    {
        _tradeService.text = [NSString stringWithFormat: @"低于同行: %@%%", [array[2] substringFromIndex:1]];
    }
    else
    {
        _tradeService.text = @"与同行保持一致";
    }
    
    _credit.text = _shopModel.credit;
    
    _bossName.text = _shopModel.bossName;
    
    _popularity.text = _shopModel.popularity;
    
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize: 15.0]};
    
    CGSize size = [_shopModel.majorOperation boundingRectWithSize: CGSizeMake(228, 200) options: NSStringDrawingUsesLineFragmentOrigin attributes: dict context: nil].size;
    
    _majorOperation.frame = CGRectMake(92, 248, 228, size.height);
    
    _majorOperation.text = _shopModel.majorOperation;
    
    NSLog(@"%@", NSStringFromCGRect(_majorOperation.frame));
    
    _area.text = _shopModel.area;
    
    _phone.text = _shopModel.phone;
}

- (void) click
{
    HXShopAllProductViewController *shopAllProductViewController = [[HXShopAllProductViewController alloc] init];
    
    shopAllProductViewController.ID = _shopModel.ID;
    
    [self.navigationController pushViewController: shopAllProductViewController animated: NO];
}

@end
