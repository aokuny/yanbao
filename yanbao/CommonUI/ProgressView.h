//
//  ProgressView.h
//  yanbao
//
//  Created by aokuny on 14/12/22.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressView :UIView
@property(nonatomic, strong) UIView *progressViewContainer;
- (id)initWithStatusCount:(int) toTalCount andDescriptionArray:(NSArray *)timeDescriptions andCurrentStatus:(int)status andFrame:(CGRect)frame;
@end
