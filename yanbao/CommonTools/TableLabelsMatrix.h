//
//  CLTableLabelsMatrix.h
//

#import <UIKit/UIKit.h>

@interface TableLabelsMatrix : UIView {
    NSArray *columnsWidths;
    uint numRows;
    uint dy;
}
@property(nonatomic,strong) UIColor *titleBackgroundColor;
@property(nonatomic,strong) UIColor *firstColumnColor;
@property(nonatomic,assign) NSUInteger rowHeight;
@property(nonatomic,assign) CGFloat fontSize;

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;
- (void)addRecord:(NSArray*)record;
@end