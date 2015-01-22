//
//  HXSubCategoryModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSubCategoryModel : NSObject<NSCoding>

// 名字
@property (nonatomic, copy) NSString *name;

// ID号
@property (nonatomic, copy) NSString *ID;

// 产品列表, 数组里面存放HXProductModel对象
@property (nonatomic, strong) NSMutableArray *subList;

- (id) init;


@end
