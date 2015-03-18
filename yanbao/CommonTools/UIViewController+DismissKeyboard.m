//
//  UIViewController+DismissKeyboard.m
//  CheleNetClinet
//
//  Created by Marin on 14-9-23.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "UIViewController+DismissKeyboard.h"

@implementation UIViewController (DismissKeyboard)
-(void)setupForDismissKeyboard {
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAnywhereToDissmissKeyboard:)];
    __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view addGestureRecognizer:singleTapGR];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view removeGestureRecognizer:singleTapGR];
    }];
}

-(void)tapAnywhereToDissmissKeyboard : (UITapGestureRecognizer *)tapGR {
    [self.view endEditing:YES];
}

@end
