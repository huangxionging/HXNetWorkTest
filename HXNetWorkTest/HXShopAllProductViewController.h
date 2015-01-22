//
//  HXShopAllProductViewController.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-26.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LINK_SHOP_ALL(ID) [NSString stringWithFormat: @"http://1000phone.net:8088/app/taobao/api/get_list.php?shop_id=%@", ID]



@interface HXShopAllProductViewController : UITableViewController

@property (nonatomic, copy) NSNumber *ID;

@property (nonatomic, strong) NSMutableArray *shopAllProductArray;

@end
