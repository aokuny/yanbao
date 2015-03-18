//
//  CATextLayer+NumberJump.h


#import <QuartzCore/QuartzCore.h>
#import "BezierCurve.h"

@interface CATextLayer (NumberJump)

- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(float)startNumber
                      toNumber:(float)endNumber;

- (void)jumpNumber;

@end
