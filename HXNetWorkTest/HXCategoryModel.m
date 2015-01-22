//
//  HXCategoryModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXCategoryModel.h"

@implementation HXCategoryModel

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _list = [[NSMutableArray alloc] init];

        _isFold = NO;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _name  forKey: @"name"];
    [aCoder encodeObject: _ID forKey: @"ID"];
    [aCoder encodeObject: _list forKey: @"list"];
    [aCoder encodeBool: _isFold forKey: @"isFold"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aDecoder decodeObjectForKey: @"name"];
        
        _ID = [aDecoder decodeObjectForKey: @"ID"];
        
        _list = [aDecoder decodeObjectForKey: @"list"];
        
        _isFold = [aDecoder decodeBoolForKey: @"isFold"];
    }
    
    return self;
}
@end
