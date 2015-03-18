//
//  ActivityListViewController.h
//  yanbao
//  优惠活动列表
//  Created by aokuny on 14/12/23.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ActivityList.h"
#import "ProductList.h"

@interface ActivityListViewController :BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ActivityList *activityList;
@property (nonatomic,strong) ProductList *productList;
@end
