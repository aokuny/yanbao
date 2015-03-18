//
//  CLBezierCurve.h
//

#import <Foundation/Foundation.h>

typedef struct
{
    float x;
    float y;
} Point2D;

@interface BezierCurve : NSObject

Point2D PointOnCubicBezier(Point2D* cp, float t);

@end
