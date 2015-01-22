//
//  HXDetailModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXDetailModel.h"

@implementation HXDetailModel


- (void) encodeWithCoder:(NSCoder *)aCoder
{
    // 名字
    [aCoder encodeObject: _name forKey: @"name"];

    // 连接地址
    [aCoder encodeObject: _linkURL forKey: @"linkURL"];

    // 图片地址
    [aCoder encodeObject: _imageURL forKey: @"imageURL"];

    // 原价
    [aCoder encodeObject: _originalPrice forKey: @"originalPrice"];

    // 现价
    [aCoder encodeObject: _price forKey: @"price"];

    // 月销量
    [aCoder encodeObject: _account forKey: @"account"];

    // ID
    [aCoder encodeObject: _ID forKey: @"ID"];

    // 店铺
    [aCoder encodeObject: _shopName forKey: @"shopName"];

    // 店铺ID
    [aCoder encodeObject: _shopID forKey: @"shopID"];

    // 区域
    [aCoder encodeObject: _area forKey: @"area"];

    // 运费
    [aCoder encodeObject: _freight forKey: @"freight"];
    
    // 分类ID
    [aCoder encodeObject: _categoryID forKey: @"categoryID"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    // 名字
    _name = [aDecoder decodeObjectForKey: @"name"];
    
    // 连接地址
    _linkURL = [aDecoder decodeObjectForKey: @"linkURL"];
    
    // 图片地址
    _imageURL = [aDecoder decodeObjectForKey: @"imageURL"];
    
    // 原价
    _originalPrice = [aDecoder decodeObjectForKey: @"originalPrice"];
    
    // 现价
    _price = [aDecoder decodeObjectForKey: @"price"];
    
    // 月销量
    _account = [aDecoder decodeObjectForKey: @"account"];
    
    // ID
    _ID = [aDecoder decodeObjectForKey: @"ID"];
    
    // 店铺
    _shopName = [aDecoder decodeObjectForKey: @"shopName"];
    
    // 店铺ID
    _shopID = [aDecoder decodeObjectForKey: @"shopID"];
    
    // 区域
    _area = [aDecoder decodeObjectForKey: @"area"];
    
    // 运费
    _freight = [aDecoder decodeObjectForKey: @"freight"];
    
    // 分类ID
    _categoryID = [aDecoder decodeObjectForKey: @"categoryID"];
    
    return self;
}
@end
