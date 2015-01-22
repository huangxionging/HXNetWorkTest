//
//  HXConcreteProductModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXConcreteProductModel.h"

@implementation HXConcreteProductModel

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _commentList = [[NSMutableArray alloc] init];
        
        _pictureList = [[NSMutableArray alloc] init];
        
        _shopModel = [[HXShopModel alloc] init];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _shopModel forKey: @"shopModel"];
    
    [aCoder encodeObject: _detailModel forKey: @"detailModel"];
    
    [aCoder encodeObject: _commentList forKey: @"commentList"];
    
    [aCoder encodeObject: _pictureList forKey: @"pictureList"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _shopModel = [aDecoder decodeObjectForKey: @"shopModel"];
        
        _detailModel = [aDecoder decodeObjectForKey: @"detailModel"];
        
        _commentList = [aDecoder decodeObjectForKey: @"commentList"];
        
        _pictureList = [aDecoder decodeObjectForKey: @"pictureList"];
    }
    
    
    return self;
}
@end
