//
//  PickerViewController.h
//  JuranClient
//
//  Created by huchu on 14-10-15.
//  Copyright (c) 2014年 juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtil.h"
@interface PickerBackgroundView : UIView

@property (nonatomic) CGSize centerOffset;  // If this is CGSizeZero, the view's center is used.

@end

@protocol PickerViewControllerDelegate;

@interface PickerViewController : UIViewController

@property (nonatomic, weak) id<PickerViewControllerDelegate> delegate;
@property (weak, readonly, nonatomic) UIViewController *rootViewController;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (strong, nonatomic) PickerBackgroundView *backgroundView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIToolbar *toolBar;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic, assign) NSInteger defaultRow;
@property (nonatomic, strong) id defaultChoiceKey;

@property (nonatomic, assign) NSInteger dataTag;


@property (nonatomic, strong) NSString *barTitle;
@property (nonatomic, strong) NSString *leftTitle;
@property (nonatomic, strong) NSString *rightTitle;
- (void)presentFromRootViewController;
- (void)presentFromViewController:(UIViewController *)controller;

@end


@protocol PickerViewControllerDelegate <NSObject>

- (void)pickerViewController:(PickerViewController *)composeViewController didCancel:(NSDictionary*)result;
- (void)pickerViewController:(PickerViewController *)composeViewController didDone:(NSDictionary *)result;


@end


