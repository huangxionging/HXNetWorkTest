//
//  HXShopViewController.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-26.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HXShopModel.h"



#define LINK_SHOP(ID) [NSString stringWithFormat: @"http://1000phone.net:8088/app/taobao/api/get_shop_info.php?id=%@", ID]

@interface HXShopViewController : UIViewController

@property (nonatomic, strong) NSNumber *ID;

@property (nonatomic, strong) HXShopModel *shopModel;

// 描述
@property (weak, nonatomic) IBOutlet UILabel *descSimilar;
// 同行
@property (weak, nonatomic) IBOutlet UILabel *trade;

@property (weak, nonatomic) IBOutlet UILabel *service;

@property (weak, nonatomic) IBOutlet UILabel *tradeService;

@property (weak, nonatomic) IBOutlet UILabel *speed;

@property (weak, nonatomic) IBOutlet UILabel *tradeSpeed;

@property (weak, nonatomic) IBOutlet UILabel *credit;

@property (weak, nonatomic) IBOutlet UILabel *bossName;

@property (weak, nonatomic) IBOutlet UILabel *popularity;

@property (weak, nonatomic) IBOutlet UILabel *majorOperation;

@property (weak, nonatomic) IBOutlet UILabel *area;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@end
