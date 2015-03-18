//
//  QuotePriceDetailViewController.h
//  yanbao
//
//  Created by aokuny on 14/12/16.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PriceList.h"

@interface QuotePriceDetailViewController :BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) PriceList *priceList;
@end
