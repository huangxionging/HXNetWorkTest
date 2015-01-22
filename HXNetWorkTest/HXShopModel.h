//
//  HXShopModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXShopModel : NSObject<NSCoding>

// 店铺ID
@property (nonatomic, copy) NSNumber *ID;

// 主页地址
@property (nonatomic, copy) NSString *linkURL;

// 人气
@property (nonatomic, copy) NSString *popularity;

// 信用
@property (nonatomic, copy) NSString *credit;

// 店铺名字
@property (nonatomic, copy) NSString *name;

// 发货速度
@property (nonatomic, copy) NSString *speed;

// 手机号
@property (nonatomic, copy) NSString *phone;

// 描述
@property (nonatomic, copy) NSString *descSimilar;

// 服务
@property (nonatomic, copy) NSString *service;

// 区域
@property (nonatomic, copy) NSString *area;

// 老板名字
@property (nonatomic, copy) NSString *bossName;

// 好评
@property (nonatomic, copy) NSString *goodRate;

// 主营
@property (nonatomic, copy) NSString *majorOperation;

@end
