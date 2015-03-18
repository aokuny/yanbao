//
//  QuotePriceViewController.h
//  yanbao
//  选择车辆信息页面
//  Created by aokuny on 14/12/12.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BaseViewController.h"
#import "PickView.h"
#import "UIButton+Block.h"
#import "CarInfo.h"
#import "Api.h"


@interface QuotePriceViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,                                       UIGestureRecognizerDelegate,ZHPickViewDelegate>

@property(nonatomic,strong) NSString *vnCode;
// 汽车信息
@property(nonatomic,strong) CarInfo *carInfo;

@end
