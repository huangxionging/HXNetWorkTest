//
//  HXSubCategoryViewController.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSubCategoryModel.h"

@interface HXSubCategoryViewController : UIViewController

// 数据模型对接
@property (nonatomic, strong) HXSubCategoryModel *subCategoryModel;

// 表视图
@property (nonatomic, strong) UITableView *subCategoryTableView;

- (void) setTableView;

@end
