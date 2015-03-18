//
//  QuotePriceProductListViewController.h
//  yanbao
//  所有产品列表（根据汽车参数）
//  Created by aokuny on 14/12/17.
//

#import "BaseViewController.h"
#import "UIButton+Block.h"
#import "ProductList.h"
#import "ActivityList.h"
@interface QuotePriceProductListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ProductList *productList;
@end
