//
//  HXCommentCell.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-26.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCommentModel.h"

@interface HXCommentCell : UITableViewCell

// 评论内容
@property (nonatomic, strong) UILabel *text;

// 评论者
@property (nonatomic, strong) UILabel *buyerName;

// 评论时间
@property (nonatomic, strong) UILabel *date;

- (void) setCommentCell: (HXCommentModel *)commentModel;

@end
