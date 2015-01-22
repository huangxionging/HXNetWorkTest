//
//  HXDetailCell.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXDetailModel.h"

// CEll的高度
#define CELL_HEIGHT (155)

#define IMAGE_HEIGHT (100)

@protocol  HXDetailCellDelegate;

@interface HXDetailCell : UITableViewCell

// 图像
@property (nonatomic, strong) UIImageView *deatilImageView;

// 名字
@property (nonatomic, strong) UILabel *name;

// 价格
@property (nonatomic, strong) UILabel *price;

// 原价
@property (nonatomic, strong) UILabel *originalPrice;

// 运费
@property (nonatomic, strong) UILabel *freight;

// 月销量
@property (nonatomic, strong) UILabel *account;

// 店名
@property (nonatomic, strong) UIButton *shopName;

// 区域
@property (nonatomic, strong) UILabel *area;

// 索引路径
@property (nonatomic, strong) NSIndexPath *indexPath;

// 代理
@property (nonatomic, assign) id<HXDetailCellDelegate> delegate;

- (void) setDetailCell: (HXDetailModel *)detailModel;

@end


//代理协议
@protocol HXDetailCellDelegate <NSObject>

@optional

// 按钮被点击触发
- (void) detailCellButtonClickedWithIndexPath: (NSIndexPath *)indexPath;

@end
