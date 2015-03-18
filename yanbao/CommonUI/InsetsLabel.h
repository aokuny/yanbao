//
//  InsetsLabel.h
//  yanbao
//
//  Created by aokuny on 15/1/15.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
