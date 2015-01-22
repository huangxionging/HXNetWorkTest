//
//  HXShopModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXShopModel.h"

@implementation HXShopModel

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _ID forKey: @"ID"];
    
    [aCoder encodeObject: _linkURL forKey: @"linkURL"];
    
    [aCoder encodeObject: _popularity forKey: @"popularity"];
    
    [aCoder encodeObject: _credit forKey: @"credit"];
    
    [aCoder encodeObject: _name forKey: @"name"];
    
    [aCoder encodeObject: _speed forKey: @"speed"];
    
    [aCoder encodeObject: _phone forKey: @"phone"];
    
    [aCoder encodeObject: _descSimilar forKey: @"descSimilar"];
    
    [aCoder encodeObject: _area forKey: @"area"];
    
    [aCoder encodeObject: _bossName forKey: @"bossName"];
    
    [aCoder encodeObject: _service forKey: @"service"];
    
    [aCoder encodeObject: _goodRate forKey: @"goodRate"];
    
    [aCoder encodeObject: _majorOperation forKey: @"major"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _ID = [aDecoder decodeObjectForKey: @"ID"];
        
        _linkURL = [aDecoder decodeObjectForKey: @"linkURL"];
        
        _popularity = [aDecoder decodeObjectForKey: @"popularity"];
        
        _credit = [aDecoder decodeObjectForKey: @"credit"];
        
        _speed = [aDecoder decodeObjectForKey: @"speed"];
        
        _name = [aDecoder decodeObjectForKey: @"name"];
        
        _phone = [aDecoder decodeObjectForKey: @"phone"];
        
        _descSimilar = [aDecoder decodeObjectForKey: @"descSimilar"];
        
        _service = [aDecoder decodeObjectForKey: @"service"];
        
        _bossName = [aDecoder decodeObjectForKey: @"bossName"];
        
        _area = [aDecoder decodeObjectForKey: @"area"];
        
        _goodRate = [aDecoder decodeObjectForKey: @"goodRate"];
        
        _majorOperation = [aDecoder decodeObjectForKey: @"major"];
    }
    
    return self;
}

@end
;