//
//  HXCategoryViewController.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LINK_URL (@"http://1000phone.net:8088/app/taobao/api/get_cateall.php?app_name=igo")
@interface HXCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// 分类表视图
@property (nonatomic, strong) UITableView *categoryTableVie;

// 存放数据
@property (nonatomic, strong) NSMutableArray *categoryDataArray;


- (void) setTableView;

@end
