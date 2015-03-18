//
//  NoActivityViewController.m
//  yanbao
//  没有活动的提示页面
//  Created by aokuny on 14/12/29.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "NoActivityViewController.h"
#import "ProgressView.h"

@interface NoActivityViewController ()

@end

@implementation NoActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:DEFAULT_TITLE];
    [self setBackBarButton];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    ProgressView *progessView = [[ProgressView alloc]initWithStatusCount:3 andDescriptionArray:@[@"参数选择",@"快速报价",@"活动查询"] andCurrentStatus:3 andFrame:CGRectMake(0,0,ScreenWidth,80)];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"inmaking"];
    
    UILabel *labDesc = [UILabel new];
    [labDesc setText:@"新活动即将上线，敬请期待！"];
    [labDesc setFont:DEFAULT_BOLD_FONT(18)];
    [labDesc setTextColor:DEFAULT_BTNCOLOR];
    
    [self.view addSubview:progessView];
    [self.view addSubview:imageView];
    [self.view addSubview:labDesc];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progessView.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    
    [labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@30);
        make.width.equalTo(@240);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
