//
//  BaseNavigationController.m
//  yanbao
//
//  Created by Marin on 14-9-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "BaseNavigationController.h"
#import "AppUtil.h"
#import "UIColor+AppColor.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    UIImage *image = nil;
    if (CLSystemVersionGreaterOrEqualThan(7.0)) {
//        [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(28,161,230)];
        [[UINavigationBar appearance] setBarTintColor:DEFAULT_NAVBLUECOLOR];
        
        //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        //self.navigationBar.translucent = NO;
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:DEFAULT_BOLD_FONT(18) forKey:UITextAttributeFont];
        [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];

    } else {
        image = [UIImage imageNamed:@"titleBar"];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    if (image &&[self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.viewControllers.count>=2) {
        return YES;
    }else{
        return NO;
    }
}

/*隐藏tab栏*/
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
