//
//  HXCommentModel.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCommentModel : NSObject<NSCoding>

// 购买者名字
@property (nonatomic, copy) NSString *buyerName;

// 评论时间
@property (nonatomic, copy) NSString *date;

// 评论内容
@property (nonatomic, copy) NSString *text;

// 评论文字高度
@property (nonatomic, assign) NSInteger textHeight;

@end
