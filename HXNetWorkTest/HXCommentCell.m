//
//  HXCommentCell.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-26.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXCommentCell.h"

@implementation HXCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        // 购买者
        _buyerName = [[UILabel alloc] init];
        
        _buyerName.font = [UIFont systemFontOfSize: 13.0];
        
        _buyerName.textColor = [UIColor grayColor];
        
        [self.contentView addSubview: _buyerName];
        
        // 评论文本
        _text = [[UILabel alloc] init];
        
        _text.font = [UIFont systemFontOfSize: 15.0];
        
        _text.numberOfLines = 0;
        
       // _text.backgroundColor = [ UIColor redColor];
        
        _text.textColor = [UIColor blackColor];
        
        [self.contentView addSubview: _text];
        
        // 评论时间
        _date = [[UILabel alloc] init];
        
        _date.font = [UIFont systemFontOfSize: 13.0];
        
        _date.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview: _date];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCommentCell:(HXCommentModel *)commentModel
{
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, commentModel.textHeight + 60);
    
    self.frame = self.contentView.frame;
    
    _text.frame = CGRectMake(0, 2, self.frame.size.width, commentModel.textHeight);
    
    _text.text = commentModel.text;
    
    _buyerName.frame = CGRectMake(0, _text.frame.origin.y + _text.frame.size.height + 10, self.frame.size.width, 20);
    
    _buyerName.text = commentModel.buyerName;
    
    _date.frame = CGRectMake(0, _buyerName.frame.origin.y + _buyerName.frame.size.height + 5, self.frame.size.width, 20);
    
    _date.text = commentModel.date;
}

@end
