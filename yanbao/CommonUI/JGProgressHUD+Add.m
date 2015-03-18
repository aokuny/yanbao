//
//  JGProgressHUD+Add.m
//  CheleNetClinet
//
//  Created by Marin on 14-9-23.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "JGProgressHUD+Add.h"
#import <JGProgressHUD/JGProgressHUDErrorIndicatorView.h>
#import <JGProgressHUD/JGProgressHUDSuccessIndicatorView.h>
@implementation JGProgressHUD (Add)
/*带标题*/
+(void)showHintStr:(NSString *)hintStr {
    [self showHintTitle:nil hintStr:hintStr];
    
}

+(void)showHintTitle:(NSString *)title hintStr:(NSString *)hintStr {
    JGProgressHUD *HUD = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    if (title) {
        HUD.textLabel.text = title;
        HUD.detailTextLabel.text = hintStr;
    } else {
        HUD.textLabel.text = hintStr;
    }
    HUD.indicatorView = nil;
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [HUD showInView:view];
    [HUD dismissAfterDelay:1.5];
}

/*不带标题*/
+(void)showErrorStr:(NSString *)errStr {
    JGProgressHUD *HUD = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    
    HUD.textLabel.text = errStr;
    
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [HUD showInView:view];
    [HUD dismissAfterDelay:1.5];
    
}

+(void)showSuccessStr:(NSString *)successStr {
    JGProgressHUD *HUD = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    
    HUD.textLabel.text = successStr;
    
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [HUD showInView:view];
    [HUD dismissAfterDelay:1.5];
}
@end
