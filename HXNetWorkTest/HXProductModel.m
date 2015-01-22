//
//  HXProductModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXProductModel.h"

@implementation HXProductModel


- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _name forKey: @"name"];
    [aCoder encodeObject: _ID forKey: @"ID"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aDecoder decodeObjectForKey: @"name"];
        
        _ID = [aDecoder decodeObjectForKey: @"ID"];
    }
    
    return self;
}

@end
