//
//  HXProductViewController.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXProductViewController.h"
#import "HXCommentModel.h"
#import "UIImageView+WebCache.h"
#import "HXCommentCell.h"
#import "HXNetWork.h"
#import "HXMainDataBase.h"

@interface HXProductViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation HXProductViewController


#pragma mark---类方法插入数据库
+ (void) insertIntoDatabaseWith: (HXConcreteProductModel *)concreteModel;
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
             NSString *sqlString = [NSString stringWithFormat: @"create table if not exists Concrete(ID integer unique, concrete blob)"];
             
             if (![db executeUpdate: sqlString])
             {
                 NSLog(@"创建表失败");
             }
         }];
    });
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject: concreteModel];
         
         NSString *sqlString = [NSString stringWithFormat: @"insert into Concrete(ID, concrete) values(?,?)"];
         if (![db executeUpdate: sqlString, concreteModel.detailModel.ID, data])
         {
             NSLog(@"插入失败");
         }
     }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
}

#pragma mark---使用类方法查询数据
+ (HXConcreteProductModel *) selectFromDatabaseWithID: (NSNumber *)ID
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 创建动态数组
    __block HXConcreteProductModel *temp = nil;
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"select *from Concrete where ID=?"];
         
         FMResultSet *result = [db executeQuery: sqlString, ID];
         
         if ([result next])
         {
             temp = [NSKeyedUnarchiver unarchiveObjectWithData: [result dataForColumn: @"concrete"]];
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
        _concreteModel = [[HXConcreteProductModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"宝贝详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setContentView];
    
    [self setMiddleScrollView];
    
    [self setTableView];
    
    [self setButton];
    
    [self setLeftHeadView];
    
    
    if ( [HXProductViewController selectFromDatabaseWithID: _concreteModel.detailModel.ID] != nil)
    {
        _concreteModel = [HXProductViewController selectFromDatabaseWithID: _concreteModel.detailModel.ID];
        
        [self refreshView];
    }
    else
    {
        [[HXNetWork shareNetWork] requestWithURLString: LINK_URL_PRODUCT(_concreteModel.detailModel.ID) WithFinished:^(NSData *responseData)
        {
            NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: nil];
            
            if (dicts == nil)
            {
                return;
            }
            
            // 解店铺
            NSDictionary *sub = dicts[@"Shop"];
            
            // 店铺名
            _concreteModel.shopModel.name = sub[@"Name"];
            
            // 店铺ID
            _concreteModel.shopModel.ID = sub[@"ID"];
            
            // 店铺发货速度
            _concreteModel.shopModel.speed = sub[@"Speed"];
            
            // 店铺主页
            _concreteModel.shopModel.linkURL = sub[@"URL"];
            
            // 店铺信用
            _concreteModel.shopModel.credit = sub[@"XinYong"];
            
            // 手机号
            _concreteModel.shopModel.phone = sub[@"Phone"];
            
            // 店铺描述
            _concreteModel.shopModel.descSimilar = sub[@"DescSimilar"];
            
            // 店铺区域
            _concreteModel.shopModel.area = sub[@"Area"];
            
            // 店铺服务
            _concreteModel.shopModel.service = sub[@"Service"];
            
            // 老板名字
            _concreteModel.shopModel.bossName = sub[@"BossName"];
            
            // 人气
            _concreteModel.shopModel.popularity = sub[@"RenQi"];
            
            // 好评率
            _concreteModel.shopModel.goodRate = sub[@"GoodRate"];
            
            
            // 解评论
            if (((NSArray *)dicts[@"CommentList"]).count != 0)
            {
                for (NSDictionary *sub in dicts[@"CommentList"][@"List"])
                {
                    HXCommentModel *commentModel = [[HXCommentModel alloc] init];
                    
                    // 评论者名字
                    commentModel.buyerName = [NSString stringWithFormat: @"购买者: %@", sub[@"buyer"]];
                    
                    // 评论时间
                    commentModel.date = [NSString stringWithFormat: @"评论时间: %@", sub[@"date"]];
                    
                    //评论内容
                    commentModel.text = [NSString stringWithFormat: @"评论内容: %@", sub[@"text"]];
                    
                    NSDictionary *dicts = @{NSFontAttributeName: [UIFont systemFontOfSize: 17.0]};
                    
                    CGSize size = [commentModel.text boundingRectWithSize: CGSizeMake(_rightTableView.frame.size.width, 500) options: NSStringDrawingUsesLineFragmentOrigin attributes: dicts context: nil].size;
                    
                    commentModel.textHeight = size.height;
                    
                    [_concreteModel.commentList addObject: commentModel];
                }
            }
            
            
            // 解图片
            if (((NSArray *)dicts[@"CommentList"]).count != 0)
            {
                for (NSDictionary *sub in dicts[@"PicList"][@"List"])
                {
                    [_concreteModel.pictureList addObject: sub[@"URL"]];
                }
            }
            
            if ([HXProductViewController selectFromDatabaseWithID: _concreteModel.detailModel.ID] == nil)
            {
                [HXProductViewController insertIntoDatabaseWith: _concreteModel];
            }
            
            // 释放内存
            dicts = nil;
            
            // 刷新
            [self refreshView];
        }
        orFailed:^(NSError *error)
        {
            [self refreshView];
            NSLog(@"%@", error);
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置滚动视图
- (void) setContentView
{
    // 初始化
    _contentView = [[UIScrollView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 40, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    // 内容大小
    _contentView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
    
    // 分页显示
    _contentView.pagingEnabled = YES;
    
    // 不要水平指示器
    _contentView.showsHorizontalScrollIndicator = NO;
    
    // 背景颜色
    _contentView.backgroundColor = [UIColor lightGrayColor];
    
    // 不要反弹效果
    _contentView.bounces = NO;
    
    // 代理
    _contentView.delegate = self;
    
    [self.view addSubview: _contentView];
}

#pragma mark---设置中间滚动视图
- (void) setMiddleScrollView
{
    // 初始化
    _middleScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(_contentView.frame.size.width, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    
    // 背景颜色
    _middleScrollView.backgroundColor = [UIColor whiteColor];
    
    
    [_contentView addSubview: _middleScrollView];
}

#pragma mark---设置按钮
- (void) setButton
{
    // 工具视图
    _toolView = [[UIView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 40)];
    
    [self.view addSubview: _toolView];
    
    // 左按钮 是基本信息
    _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    // 设置背景图片
    [_leftButton setBackgroundImage: [UIImage imageNamed: @"tool_nor"] forState: UIControlStateNormal];
    
    [_leftButton setBackgroundImage: [UIImage imageNamed: @"tool_hl"] forState: UIControlStateSelected];
    
    // 大小位置
    _leftButton.frame = CGRectMake(0, 0, _toolView.frame.size.width / 3, 40);
    
    _leftButton.selected = YES;
    
    // 发光效果
    _leftButton.showsTouchWhenHighlighted = YES;
    
    // 字体颜色
    [_leftButton setTitleColor: [UIColor blackColor]  forState: UIControlStateNormal];
    
    // 标题颜色
    [_leftButton setTitleColor: [UIColor magentaColor] forState: UIControlStateSelected];
    [_leftButton setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    
    // 标题
    [_leftButton setTitle: @"基本信息" forState: UIControlStateNormal];
    
    // 动作
    [_leftButton addTarget: self action: @selector(changeState:) forControlEvents: UIControlEventTouchUpInside];
    
    // 标记
    _leftButton.tag = 200;
    
    // 添加到工具视图上
    [_toolView addSubview: _leftButton];
    
/***********************/
    // 中间按钮
    // 右按钮放置评论
    _middleButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    // 背景图片
    [_middleButton setBackgroundImage: [UIImage imageNamed: @"tool_nor"] forState: UIControlStateNormal];
    
    [_middleButton setBackgroundImage: [UIImage imageNamed: @"tool_hl"] forState: UIControlStateSelected];
    
    _middleButton.frame = CGRectMake(_toolView.frame.size.width / 3 , 0, _toolView.frame.size.width / 3, 40);
    
    // 字体颜色
    [_middleButton setTitleColor: [UIColor blackColor]  forState: UIControlStateNormal];
    
    // 标题颜色
    [_middleButton setTitleColor: [UIColor magentaColor] forState: UIControlStateSelected];
    [_middleButton setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    
    // 标题
    [_middleButton setTitle: @"图文详情" forState: UIControlStateNormal];
    
    // 动作
    [_middleButton addTarget: self action: @selector(changeState:) forControlEvents: UIControlEventTouchUpInside];
    
    _middleButton.showsTouchWhenHighlighted = YES;
    
    // 标记
    _middleButton.tag = 201;
    
    [_toolView addSubview: _middleButton];
    
/***********************/
    // 右按钮放置评论
    _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    // 背景图片
    [_rightButton setBackgroundImage: [UIImage imageNamed: @"tool_nor"] forState: UIControlStateNormal];
    
    [_rightButton setBackgroundImage: [UIImage imageNamed: @"tool_hl"] forState: UIControlStateSelected];
    
    _rightButton.frame = CGRectMake(_toolView.frame.size.width / 3 * 2, 0, _toolView.frame.size.width / 3, 40);
    
    // 字体颜色
    [_rightButton setTitleColor: [UIColor blackColor]  forState: UIControlStateNormal];
    
    // 标题颜色
    [_rightButton setTitleColor: [UIColor magentaColor] forState: UIControlStateSelected];
    [_rightButton setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    
    // 标题
    [_rightButton setTitle: @"评价" forState: UIControlStateNormal];
    
    // 动作
    [_rightButton addTarget: self action: @selector(changeState:) forControlEvents: UIControlEventTouchUpInside];
    
    _rightButton.showsTouchWhenHighlighted = YES;
    
    // 标记
    _rightButton.tag = 202;
    
    [_toolView addSubview: _rightButton];
}

#pragma mark---点击按钮响应

- (void) changeState: (UIButton *)sender
{
    // 全不选
    for (UIButton *subButton in _toolView.subviews)
    {
        subButton.selected = NO;
    }
    
    // 按钮被选中
    sender.selected = YES;
    
    switch (sender.tag)
    {
            // 左按钮
        case 200:
        {
            _contentView.contentOffset = CGPointMake(0, 0);
            break;
        }
            
        case 201:
        {
            _contentView.contentOffset = CGPointMake(_contentView.frame.size.width, 0);
            break;
        }
            
        case 202:
        {
            _contentView.contentOffset = CGPointMake(_contentView.frame.size.width * 2, 0);
            break;
        }
        default:
            break;
    }
}


#pragma mark---设置左右表视图
- (void) setTableView
{
    // 左边放基本信息
    _leftTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height) style: UITableViewStylePlain];
    
    // 数据源和代理
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    
    // 标记
    _leftButton.tag = 100;
    
    [_contentView addSubview: _leftTableView];
    
    
    // 右边放评论内容
    _rightTableView = [[UITableView alloc] initWithFrame: CGRectMake(_contentView.frame.size.width * 2, -20, _contentView.frame.size.width, _contentView.frame.size.height) style: UITableViewStyleGrouped];
    
    // 数据源和代理
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    
    // 标记
    _rightTableView.tag = 101;
    
    [_contentView addSubview: _rightTableView];
}

#pragma mark---设置左表视图的头视图

- (void) setLeftHeadView
{
    _leftHeadView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _leftTableView.frame.size.width, 200)];
    
    _leftTableView.tableHeaderView = _leftHeadView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake((_leftHeadView.frame.size.width - 100) / 2, (_leftHeadView.frame.size.height - 100) / 2, 100, 100)];
    
    [_leftHeadView addSubview: imageView];
    
    [imageView setImageWithURL: [NSURL URLWithString: _concreteModel.detailModel.imageURL]];
}
- (void) reloadLeftHeadView
{
    
}

#pragma mark---重新加载
- (void) reloadMiddleScrollView;
{
    for (UIView *subView in _middleScrollView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    NSInteger count = _concreteModel.pictureList.count / 2;
    
    _middleScrollView.contentSize = CGSizeMake(_middleScrollView.frame.size.width, _middleScrollView.frame.size.height * count);
    
    for (NSInteger index = 0; index < count; ++index)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, index * _middleScrollView.frame.size.height / 2, _middleScrollView.frame.size.width, _middleScrollView.frame.size.height / 2)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_middleScrollView addSubview: imageView];
        [imageView setImageWithURL: [NSURL URLWithString: _concreteModel.pictureList[index]]];
    }
}

#pragma mark---UIScrollViewDelegate

// 按钮也随滚动视图的位置变化
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != _contentView)
    {
        return;
    }
    
    NSInteger xLength = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    switch (xLength)
    {
        case 0:
        {
            _leftButton.selected = YES;
            _middleButton.selected = NO;
            _rightButton.selected = NO;
            break;
        }
            
        case 1:
        {
            _middleButton.selected = YES;
            _leftButton.selected = NO;
            _rightButton.selected = NO;
            break;
        }
        
        case 2:
        {
            _rightButton.selected = YES;
            _middleButton.selected = NO;
            _leftButton.selected = NO;
            break;
        }
        default:
            break;
    }
}

#pragma mark---UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101)
    {
        return 1;
    }
    return 4;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 101)
    {
        return _concreteModel.commentList.count;
    }
    return  8;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101)
    {
        static NSString *cellID = @"Cell1";
        
        HXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
        
        if (cell == nil)
        {
            cell = [[HXCommentCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setCommentCell: ((HXCommentModel *)_concreteModel.commentList[indexPath.section])];
        
        return cell;

    }
    
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
    }
    
    return cell;
    
}

#pragma mark---UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101)
    {
        return ((HXCommentModel *)_concreteModel.commentList[indexPath.section]).textHeight + 60;
    }
    return 20;
}

#pragma mark---刷新视图

- (void) refreshView
{
    [_leftTableView reloadData];
    
    [_rightTableView reloadData];
    
    [self reloadMiddleScrollView];
    
    [self reloadLeftHeadView];
}

- (void)dealloc
{
    _concreteModel = nil;
    
    for (NSInteger index = 0; index < self.view.subviews.count; ++index)
    {
        UIView *sub = ((UIView *)self.view.subviews[index]);
        
        [sub removeFromSuperview];
        
        sub = nil;
        
    }
    
    [self.view removeFromSuperview];
}

@end
