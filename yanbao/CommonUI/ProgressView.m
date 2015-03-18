//
//  ProgressView.m
//  yanbao
//
//  Created by aokuny on 14/12/22.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//


#import "ProgressView.h"
#import "AppUtil.h"
@interface ProgressView(){
    float LINE_WIDTH;
    float CIRCLE_RADIUS;
    float INITIAL_PROGRESS_CONTAINER_WIDTH;
    NSArray *arrPointDescriptions;
}
@end
@implementation ProgressView

- (id)initWithStatusCount:(int) toTalCount andDescriptionArray:(NSArray *)pointDescriptions andCurrentStatus:(int)status andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _progressViewContainer = [[UIView alloc]initWithFrame:frame];
        [self addSubview:_progressViewContainer];
        LINE_WIDTH = 1;
        CIRCLE_RADIUS = 8.0;
        arrPointDescriptions = pointDescriptions;
        [self genProgressViewWithTotalCount:toTalCount andCurrentStatus:status];
//        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void) genProgressViewWithTotalCount:(int) totalCount andCurrentStatus:(int) currentStatus{
    [_progressViewContainer setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    
    CGPoint lastpoint;
    CGFloat yCenter;
    UIColor *strokeColor;
    CGPoint toPoint;
    CGPoint fromPoint;
//    INITIAL_PROGRESS_CONTAINER_WIDTH = (_progressViewContainer.frame.size.width - ((totalCount) * CIRCLE_RADIUS*2 ))/(totalCount -1);
    INITIAL_PROGRESS_CONTAINER_WIDTH = (_progressViewContainer.frame.size.width - (totalCount * CIRCLE_RADIUS) - 80)/(totalCount-1);
    for (int i = 0; i< totalCount; i++) {
//        strokeColor = [UIColor lightGrayColor];
        strokeColor = RGBCOLOR(36,169,212);
        yCenter = _progressViewContainer.frame.size.height/2+CIRCLE_RADIUS;
        if (i>0) {
            lastpoint = CGPointMake(lastpoint.x+INITIAL_PROGRESS_CONTAINER_WIDTH, yCenter);
        }else{
            lastpoint = CGPointMake(_progressViewContainer.frame.origin.x+40, yCenter);
        }
        UILabel *labDesc = [UILabel new];
        float labWidth = 60.0;
        [labDesc setFrame:CGRectMake(lastpoint.x-labWidth/2+10,yCenter-34,labWidth,20)];
        [labDesc setFont:DEFAULT_BOLD_FONT(14)];
        [labDesc setBackgroundColor:[UIColor clearColor]];
        if (i == currentStatus -1) {
            [labDesc setTextColor:RGBCOLOR(227,171,24)];
        }else{
            [labDesc setTextColor:RGBCOLOR(24,139,203)];
        }
        [labDesc setText:arrPointDescriptions[i]];
        [_progressViewContainer addSubview:labDesc];
        
        UIColor *wapColor = i == currentStatus-1 ? RGBCOLOR(234,111,10):strokeColor;
        //外面圆圈
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterX:lastpoint.x+CIRCLE_RADIUS andRadius:CIRCLE_RADIUS];
        CAShapeLayer *circleLayer = [self getLayerWithCircle:circle andStrokeColor:wapColor];
        [_progressViewContainer.layer addSublayer:circleLayer];
        // 内部点
        UIColor *internalColor = BACKGROUNDCOLOR_GRAY;
        UIBezierPath *circleInternal = [UIBezierPath bezierPath];
        [self configureBezierCircle:circleInternal withCenterX:lastpoint.x+CIRCLE_RADIUS andRadius:CIRCLE_RADIUS/1.5];
        CAShapeLayer *circleInternalLayer = [self getLayerWithCircle:circleInternal andStrokeColor:internalColor];
        [_progressViewContainer.layer addSublayer:circleInternalLayer];

//        strokeColor = i < currentStatus ? [UIColor orangeColor] : [UIColor lightGrayColor];
        
        if (i < totalCount-1) {
            fromPoint = lastpoint;
            toPoint = CGPointMake(lastpoint.x+INITIAL_PROGRESS_CONTAINER_WIDTH, yCenter);
            UIBezierPath *line = [self getLineWithStartPoint:CGPointMake(fromPoint.x+CIRCLE_RADIUS*2,fromPoint.y) endPoint:toPoint];
//            strokeColor = i < currentStatus-1 ? [UIColor orangeColor] : [UIColor lightGrayColor];
            CAShapeLayer *lineLayer = [self getLayerWithLine:line andStrokeColor:strokeColor];
            [_progressViewContainer.layer addSublayer:lineLayer];
        }
    }
}
- (UIBezierPath *)getLineWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:start];
    [line addLineToPoint:end];
    return line;
}
- (CAShapeLayer *)getLayerWithLine:(UIBezierPath *)line andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = line.CGPath;
    lineLayer.strokeColor = strokeColor.CGColor;
    lineLayer.fillColor = nil;
    lineLayer.lineWidth = LINE_WIDTH;
    return lineLayer;
}
- (CAShapeLayer *)getLayerWithCircle:(UIBezierPath *)circle andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _progressViewContainer.bounds;
    circleLayer.path = circle.CGPath;
    
    circleLayer.strokeColor = strokeColor.CGColor;
    circleLayer.fillColor = strokeColor.CGColor;
    circleLayer.lineWidth = LINE_WIDTH;
    circleLayer.lineJoin = kCALineJoinBevel;
    
    return circleLayer;
}

- (void)configureBezierCircle:(UIBezierPath *)circle withCenterX:(CGFloat)centerX andRadius:(float) RADIUS {
    [circle addArcWithCenter:CGPointMake(centerX, _progressViewContainer.frame.size.height/2 + CIRCLE_RADIUS)
                      radius:RADIUS
                  startAngle:M_PI_2
                    endAngle:-M_PI_2
                   clockwise:YES];
    
    [circle addArcWithCenter:CGPointMake(centerX, _progressViewContainer.frame.size.height/2 + CIRCLE_RADIUS)
                      radius:RADIUS
                  startAngle:-M_PI_2
                    endAngle:M_PI_2
                   clockwise:YES];
}
@end
