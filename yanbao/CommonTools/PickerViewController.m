//
//  PickerViewController.m
//  CheleNetClient
//
//  Created by aokuny on 14-10-15.
//  Copyright (c) 2014年 aokuny. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController () <UIPickerViewDataSource,UIPickerViewDelegate>
@end

@implementation PickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (int)currentWidth
{
    UIScreen *screen = [UIScreen mainScreen];
    return screen.bounds.size.width;
}

- (void)loadView
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.view = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backgroundView = [[PickerBackgroundView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.centerOffset = CGSizeMake(0, - self.view.frame.size.height / 2);
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];

    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _containerView.backgroundColor = [UIColor whiteColor];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _toolBar.barStyle = UIBarStyleDefault;
    
    NSString *title = _barTitle.length ? _barTitle : @"请选择";
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *rightTitle = _rightTitle.length ? _rightTitle : @"完成";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
    NSString *leftTitle = _leftTitle.length ? _leftTitle : @"取消";
    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStyleBordered target:self action:@selector(docancel)];
    
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,titleButton,fixedButton,rightButton,nil];
    [_toolBar setItems: array];
    [_containerView addSubview:_toolBar];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.containerView.frame.size.height - 44)];
//    _pickerView.backgroundColor = [UIColor greenColor];
    CGRect frame = _pickerView.frame;
    frame.origin.y = 44;
    _pickerView.frame = frame;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    [_containerView addSubview:_pickerView];
    
    if (self.dataDic) {
        if (self.dataArray) {
            self.dataArray = nil;
        }
        self.dataArray = [NSMutableArray array];
        /*NSArray *sortKey = [[self.dataDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 isKindOfClass:[NSNumber class]]) {
                return  [obj1 compare:obj2];
            }  else {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }
        } ];*/
        for (id key in [self.dataDic allKeys]) {
            [self.dataArray addObject:CELLDICTIONARYBUILT(key, self.dataDic[key])];
        }
    }
    
   __block NSInteger defalutRow = -1;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            id k = [[obj allKeys] objectAtIndex:0];
            if ([obj[k] isEqual:_defaultChoiceKey]) {
                defalutRow = idx;
                *stop = true;
            }
        }
    }];
    defalutRow = (defalutRow==-1) ? _defaultRow : defalutRow;
    
    [_pickerView selectRow:defalutRow inComponent:0 animated:NO];
    
    [self.view addSubview:_containerView];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    __typeof(&*self) __weak weakSelf = self;
    
    _backgroundView.frame = _rootViewController.view.bounds;
    
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf layoutWithOrientation:weakSelf.interfaceOrientation width:weakSelf.view.frame.size.width height:weakSelf.view.frame.size.height];
    }];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.backgroundView.alpha = .8;
                     } completion:nil];
    
}

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}


- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
}


- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    __typeof(&*self) __weak weakSelf = self;
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = weakSelf.containerView.frame;
        frame.origin.y =  weakSelf.rootViewController.view.frame.size.height;
        weakSelf.containerView.frame = frame;
    }];
    
    [UIView animateWithDuration:0.4
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.backgroundView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [weakSelf.view removeFromSuperview];
                         [weakSelf removeFromParentViewController];
                         if (completion)
                             completion();
                     }];
}


- (void)layoutWithOrientation:(UIInterfaceOrientation)interfaceOrientation width:(NSInteger)width height:(NSInteger)height {
    CGRect frame = _containerView.frame;
    frame.origin.y = height - _containerView.frame.size.height;
    if (frame.origin.y < 20) frame.origin.y = 20;
    _containerView.frame = frame;
}

#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArray.count;
}

#pragma mark Picker Delegate Methods

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *value = [[_dataArray objectAtIndex:row] stringForKey:@"v"];
    return value;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.view.frame.size.width;
}


-(void)docancel {
    if ([self.delegate respondsToSelector:@selector(pickerViewController:didCancel:)]) {
        [self.delegate pickerViewController:self didCancel:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)done {
    if ([self.delegate respondsToSelector:@selector(pickerViewController:didDone:)]) {
        [self.delegate pickerViewController:self didDone:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


@implementation PickerBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    if (CGSizeEqualToSize(self.centerOffset, CGSizeZero) == NO) {
        center.x += self.centerOffset.width;
        center.y += self.centerOffset.height;
    }
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0, 0.7,   // Start color
        0.0, 0.0, 0.0, 0.85 }; // End color
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    CGFloat endRadius = [UIApplication sharedApplication].keyWindow.bounds.size.height / 2;
    CGContextDrawRadialGradient(currentContext, gradient, center, 20.0f, center, endRadius, options);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)setCenterOffset:(CGSize)offset
{
    if (CGSizeEqualToSize(_centerOffset, offset) == NO) {
        _centerOffset = offset;
        [self setNeedsDisplay];
    }
}



@end
