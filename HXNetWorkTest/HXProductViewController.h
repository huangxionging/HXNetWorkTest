//
//  HXProductViewController.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConcreteProductModel.h"

// 接口地址
#define LINK_URL_PRODUCT(ID) ([NSString stringWithFormat: @"http://1000phone.net:8088/app/taobao/api/get_item.php?id=%@", ID])

@interface HXProductViewController : UIViewController

// 信息模型
@property (nonatomic, strong) HXConcreteProductModel *concreteModel;

// 滚动视图
@property (nonatomic, strong) UIScrollView *contentView;

// 左表视图
@property (nonatomic, strong) UITableView *leftTableView;

// 左表视图的头视图放置滚动视图使得图片可以滚动
@property (nonatomic, strong) UIView *leftHeadView;

// 图文详情的滚动视图
@property (nonatomic, strong) UIScrollView *middleScrollView;


// 右表视图
@property (nonatomic, strong) UITableView *rightTableView;

// 底层表视图的头视图
@property (nonatomic, strong) UIView *toolView;

// 头视图上面放置3个按钮
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *middleButton;

// 右按钮
@property (nonatomic, strong) UIButton *rightButton;

// 设置内容视图
- (void) setContentView;

// 设置左表视图的头视图
- (void) setLeftHeadView;

@end
