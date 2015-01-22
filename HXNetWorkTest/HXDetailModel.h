//
//  HXDetailModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDetailModel : NSObject<NSCoding>

// 名字
@property (nonatomic, copy) NSString *name;

// 连接地址
@property (nonatomic, copy) NSString *linkURL;

// 图片地址
@property (nonatomic, copy) NSString *imageURL;

// 原价
@property (nonatomic, copy) NSString *originalPrice;

// 现价
@property (nonatomic, copy) NSString *price;

// 月销量
@property (nonatomic, copy) NSString *account;

// ID
@property (nonatomic, copy) NSNumber *ID;

// 店铺
@property (nonatomic ,copy) NSString *shopName;

// 店铺ID
@property (nonatomic, copy) NSNumber *shopID;

// 区域
@property (nonatomic, copy) NSString *area;

// 运费
@property (nonatomic, copy) NSString *freight;

// 分类ID
@property (nonatomic, copy) NSString *categoryID;

@end
