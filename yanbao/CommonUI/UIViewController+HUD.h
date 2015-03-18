//
//  UIViewController+HUD.h
//  CheleNetClinet
//
//  Created by Marin on 14-9-23.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import <UIKit/UIKit.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUD/JGProgressHUDSuccessIndicatorView.h>
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "AppUtil.h"

@interface UIViewController (HUD)
/*显示*/
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

/*隐藏*/
- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
