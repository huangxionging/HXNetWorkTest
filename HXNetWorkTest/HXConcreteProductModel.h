//
//  HXConcreteProductModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXDetailModel.h"
#import "HXShopModel.h"

@interface HXConcreteProductModel : NSObject<NSCoding>

// 详细信息
@property (nonatomic, strong) HXDetailModel *detailModel;

// 评论列表, 存放HXCommentModel 对象
@property (nonatomic, copy) NSMutableArray *commentList;

// 存放图片的地址
@property (nonatomic, copy) NSMutableArray *pictureList;

// 店铺模型
@property (nonatomic, strong) HXShopModel *shopModel;

- (id) init;


@end
