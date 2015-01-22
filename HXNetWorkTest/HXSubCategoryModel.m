//
//  HXSubCategoryModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXSubCategoryModel.h"

@implementation HXSubCategoryModel

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _subList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _name  forKey: @"name"];
    [aCoder encodeObject: _ID forKey: @"ID"];
    [aCoder encodeObject: _subList forKey: @"subList"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aDecoder decodeObjectForKey: @"name"];
        
        _ID = [aDecoder decodeObjectForKey: @"ID"];
        
        _subList = [aDecoder decodeObjectForKey: @"subList"];
    }
    
    return self;
}

@end
