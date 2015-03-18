//
//  LoginBaseViewController.m
//  CheleNetClinet
//
//  Created by aokuny on 14-10-10.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "LoginBaseViewController.h"
#import "UIImage-Helpers.h"
@interface LoginBaseViewController ()

@end

@implementation LoginBaseViewController

-(void)loadView {
    [super loadView];
    UIImage *img = [UIImage imageNamed:@"login_bg"];

    /*img = [img applyBlurWithRadius:20 tintColor:[UIColor colorWithRed:0.836 green:0.807 blue:0.390 alpha:0.130] saturationDeltaFactor:1.8 maskImage:nil];*/

    UIImageView *bgView = [[UIImageView alloc]initWithImage:img];
    [bgView setFrame:self.view.bounds];
    bgView.clipsToBounds = YES;
    [bgView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
}

- (void)setBackBarButton {

    [self setBackBarButtonItemImage:@"nav_backbtn_login" target:self action:@selector(goBack)];
    
}

- (void)setRightBarButtonItemTitle:(NSString *)aTitle target:(id)target action:(SEL)action
{

    UIButton *button = [self  buttonWithTitle:aTitle image:nil highligted:nil target:target action:action];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)setNavTitle:(NSString *)title {
    [self setNavTitle:title titleColor:[UIColor whiteColor]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeTop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
