//
//  HXCommentModel.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXCommentModel.h"

@implementation HXCommentModel

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _buyerName forKey: @"buyerName"];
    
    [aCoder encodeObject: _date forKey: @"date"];
    
    [aCoder encodeObject: _text  forKey: @"text"];
    
    [aCoder encodeInteger: _textHeight forKey: @"textHeight"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _text = [aDecoder decodeObjectForKey: @"text"];

        _date = [aDecoder decodeObjectForKey: @"date"];
        
        _buyerName = [aDecoder decodeObjectForKey: @"buyerName"];
        
        _textHeight = [aDecoder decodeIntegerForKey: @"textHeight"];
    }
    
    return self;
}

@end
