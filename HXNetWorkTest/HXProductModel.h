//
//  HXProductModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXProductModel : NSObject<NSCoding>

// 名字
@property (nonatomic, copy) NSString *name;

// ID
@property (nonatomic, copy) NSString *ID;

@end
