//
//  AFViewShaker
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewShaker : NSObject

- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithViewsArray:(NSArray *)viewsArray;

- (void)shake;
- (void)shakeWithDuration:(NSTimeInterval)duration completion:(void (^)())completion;

@end