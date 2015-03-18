//
//  InMakingViewController.m
//  yanbao
//
//  Created by aokuny on 14/12/23.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "InMakingViewController.h"

@interface InMakingViewController ()

@end

@implementation InMakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self setTitle:DEFAULT_TITLE];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"inmaking"];
    
    UILabel *labDesc = [UILabel new];
    [labDesc setText:@"即将上线，敬请期待..."];
    [labDesc setFont:DEFAULT_FONT(18)];
    [labDesc setTextColor:DEFAULT_BTNCOLOR];
    
//    UIView *bottomView = [UIView new];
    [self.view addSubview:imageView];
    [self.view addSubview:labDesc];
//    [self.view addSubview:bottomView];
    // 678 × 530
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(10);
//        make.width.equalTo(@(self.view.frame.size.width-80));
        //make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
    }];
    
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.height.equalTo(@60);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//    }];
//    [self defaultBottomViewWithSuper:bottomView];
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
