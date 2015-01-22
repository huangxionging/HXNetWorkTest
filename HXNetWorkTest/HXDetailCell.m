//
//  HXDetailCell.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-25.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation HXDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
/**************************/
        // 图片
        _deatilImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (CELL_HEIGHT - IMAGE_HEIGHT) / 2, IMAGE_HEIGHT, IMAGE_HEIGHT)];
        
        [self.contentView addSubview: _deatilImageView];
        
/**************************/
        // 名字
        _name = [[UILabel alloc] initWithFrame: CGRectMake(_deatilImageView.frame.origin.x + _deatilImageView.frame.size.width + 5, 10, self.frame.size.width - _deatilImageView.frame.origin.x - _deatilImageView.frame.size.width - 15 , 40)];
        
        // 限制行数
        _name.numberOfLines = 0;
        
        // 字体
        _name.font = [UIFont systemFontOfSize: 14.0];
        
        [self.contentView addSubview: _name];

        
/**************************/
        // 价格
        _price = [[UILabel alloc] initWithFrame: CGRectMake(_name.frame.origin.x, _name.frame.origin.y + _name.frame.size.height + 5, 100, 20)];
        
        // 价格颜色
        _price.textColor = [UIColor redColor];
        
        // 价格排版
        _price.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview: _price];
        
/**************************/
        // 原价
        _originalPrice = [[UILabel alloc] initWithFrame: CGRectMake(_price.frame.origin.x + _price.frame.size.width + 5, _price.frame.origin.y , 100, 20)];
        
        // 价格颜色
        _originalPrice.textColor = [UIColor grayColor];
        
        // 字体
        _originalPrice.font = [UIFont systemFontOfSize: 14.0];
        
        // 价格排版
        _originalPrice.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview: _originalPrice];
        
        
        // 给原价加一个删除线
        UILabel *deleteLine = [[UILabel alloc] initWithFrame: CGRectMake(0, _originalPrice.frame.size.height / 2, _originalPrice.frame.size.width, 2)];
        
        deleteLine.backgroundColor = [UIColor grayColor];
        
        [_originalPrice addSubview: deleteLine];
        
/**************************/
        // 运费
        _freight = [[UILabel alloc] initWithFrame: CGRectMake(_price.frame.origin.x, _price.frame.origin.y + _price.frame.size.height + 10, 100, 20)];
        
        // 字体
        _freight.font = [UIFont systemFontOfSize: 14.0];
        
        // 字体颜色
        _freight.textColor = [UIColor orangeColor];
        
        [self.contentView addSubview: _freight];
        
/**************************/
        // 月销量
        _account = [[UILabel alloc] initWithFrame: CGRectMake(_freight.frame.origin.x + _freight.frame.size.width + 5, _freight.frame.origin.y, 100, 20)];
        
        // 字体颜色
        _account.textColor = [UIColor grayColor];
        
        // 字体大小
        _account.font = [UIFont systemFontOfSize: 14.0];
        
        [self.contentView addSubview: _account];
        
/**************************/
        // 店铺名字
        _shopName = [UIButton buttonWithType: UIButtonTypeSystem];
        
        _shopName.frame = CGRectMake(_freight.frame.origin.x, _freight.frame.origin.y + _freight.frame.size.height + 5, self.frame.size.width - _freight.frame.origin.x, 20);
        _shopName.layer.borderWidth = 1;
        _shopName.layer.cornerRadius = 4;
        _shopName.backgroundColor = [UIColor brownColor];
        
        // 标题颜色
        [_shopName setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        
        // 添加事件
        [_shopName addTarget: self action: @selector(shopClick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview: _shopName];
        
/**************************/
        // 区域
        _area = [[UILabel alloc] initWithFrame: CGRectMake(self.frame.size.width - 70, _shopName.frame.origin.y + _shopName.frame.size.height, 70, 20)];
        
        // 字体
        _area.font = [UIFont systemFontOfSize: 14.0];
        
        // 字体颜色
        _area.textColor = [UIColor grayColor];
        
        // 排版
        _area.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview: _area];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark---设置单元格
- (void) setDetailCell:(HXDetailModel *)detailModel
{
    // 图片
    [_deatilImageView setImageWithURL: [NSURL URLWithString: detailModel.imageURL]];
    
    // 名字
    _name.text = detailModel.name;
    
    // 价格
    _price.text = [NSString stringWithFormat: @"¥%@", detailModel.price];
    
    // 原价
    _originalPrice.text = [NSString stringWithFormat: @"¥%@", detailModel.originalPrice];
    
    // 运费
    if ([detailModel.freight isEqualToString: @"0"])
    {
        _freight.text = @"包邮";
    }
    else
    {
        _freight.text = [NSString stringWithFormat: @"运费:¥%@", detailModel.freight];
    }
    
    // 月销量
    _account.text = detailModel.account;
    
    // 店铺
    [_shopName setTitle: [NSString stringWithFormat: @"店铺:%@", detailModel.shopName] forState: UIControlStateNormal];
    
    // 区域
    _area.text = detailModel.area;
}

#pragma mark---按钮事件响应
- (void) shopClick: (UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector: @selector(detailCellButtonClickedWithIndexPath:)])
    {
        [_delegate detailCellButtonClickedWithIndexPath: _indexPath];
    }
}

@end
