//
//  HXCategoryModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCategoryModel : NSObject<NSCoding>

// 名字
@property (nonatomic, copy) NSString *name;

// ID号
@property (nonatomic, copy) NSString *ID;

// 产品列表, 数组里面存放HXSubCategory对象
@property (nonatomic, strong) NSMutableArray *list;

// 表示是否可折叠
@property (nonatomic, assign) BOOL isFold;

- (id) init;

@end
