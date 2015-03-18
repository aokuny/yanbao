//
//  BaseLabel.h
//  CheleNetClinet
//
//  Created by aokuny on 14-10-11.
//  Copyright (c) 2014年 aokuny. All rights reserved.//


#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface BaseLabel : UILabel
{
    @private VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;
@end