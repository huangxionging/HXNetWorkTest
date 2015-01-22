//
//  HXDetailViewController.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXProductModel.h"
#import "MJRefresh.h"

#define LINK_URL_DETAIL(numberID, pageID) [NSString stringWithFormat: @"http://1000phone.net:8088/app/taobao/api/get_list.php?cate_id=%@&page=%d", numberID, pageID]



@interface HXDetailViewController : UIViewController

// 数据模型
@property (nonatomic, strong) HXProductModel *productModel;

// 存储模型的动态数组
@property (nonatomic, strong) NSMutableArray *detailDataArray;

// 表视图
@property (nonatomic, strong) UITableView *detailTableView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

// 刷新时请求的页码
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger number;

- (void) setTableView;

@end
