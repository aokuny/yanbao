//
//  ChannelNumberViewController.h
//  yanbao
//
//  Created by aokuny on 15/1/16.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ChannelNumberViewController : BaseViewController <UITextFieldDelegate,UIAlertViewDelegate>
/*页面类型，是否为设置页面*/
@property(nonatomic,assign) BOOL isSettingPageType;
@end
