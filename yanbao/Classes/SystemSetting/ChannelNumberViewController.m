//
//  ChannelNumberViewController.m
//  yanbao
//
//  Created by aokuny on 15/1/16.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import "ChannelNumberViewController.h"
#import "UIButton+Block.h"
#import "ViewShaker.h"

static SystemSoundID shake_sound_id = 0;
@interface ChannelNumberViewController (){
    UITextField *txtChannelNumber;
    // 录入账号
    UIView *containView;
    // 展示已经存在渠道账号的面板
    UIView *containViewPanel;
}
@end

@implementation ChannelNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    if(_isSettingPageType){
        [self setTitle:@"渠道码验证"];
        [self setBackBarButton];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-150/2, 0,150, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIFont * font=DEFAULT_FONT(16);
        [titleLabel setFont:font];
        [titleLabel setText:@"渠道码验证"];
        self.navigationItem.titleView = titleLabel;
    }
    [self showChannelNumberPage];
    [self initPage];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"CHANNEL_NUMBER"]){
        // 如果已经存在渠道号码
        [containViewPanel setHidden:NO];
        [containView setHidden:YES];
    }else{
        [containViewPanel setHidden:YES];
        [containView setHidden:NO];
    }
}
#pragma mark 加载页面
-(void) initPage{
    if (containView!=nil) {
        return;
    }
    containView = [[UIView alloc]init];
    [containView setTag:1000];
    [containView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *labDesc = [UILabel new];
    [labDesc setText:@"查看报价需要渠道码！"];
    [labDesc setFont:DEFAULT_FONT(13)];
    [labDesc setTextColor:[UIColor grayColor]];
    [labDesc setTextAlignment:NSTextAlignmentLeft];
    [containView addSubview:labDesc];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayLineColor];
    [containView addSubview:lineView];
    
    UILabel *labChannelNumber = [UILabel new];
    [labChannelNumber setTag:1000001];
    [labChannelNumber setText:@"渠道码："];
    [labChannelNumber setFont:DEFAULT_FONT(15)];
    [labChannelNumber setTextColor:DEFAULT_NAVBLUECOLOR];
    [containView addSubview:labChannelNumber];
    
    txtChannelNumber = [UITextField new];
    [txtChannelNumber setDelegate:self];
    [txtChannelNumber setPlaceholder:@"请输入渠道验证码"];
    [txtChannelNumber setFont:DEFAULT_FONT(15)];
    txtChannelNumber.keyboardType = UIKeyboardTypeNamePhonePad;
    txtChannelNumber.returnKeyType = UIReturnKeyDone;
    txtChannelNumber.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    txtChannelNumber.autocorrectionType = UITextAutocorrectionTypeNo;
    txtChannelNumber.clearButtonMode = UITextFieldViewModeAlways;
    [containView addSubview:txtChannelNumber];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor grayLineColor];
    [containView addSubview:lineView1];

    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setTitle:@"马上验证" forState:UIControlStateNormal];
    [btnSearch.titleLabel setFont:DEFAULT_BOLD_FONT(16)];
    [btnSearch setBackgroundColor:DEFAULT_BTNCOLOR];
    [btnSearch addTarget:self action:@selector(searchChannelNumber) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:btnSearch];
    
    [self.view addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@200);
    }];
    [labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView.mas_top).offset(15);
        make.left.equalTo(containView.mas_left).offset(20);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labDesc.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.equalTo(labDesc.mas_left);
        make.right.equalTo(containView.mas_right).offset(-2);
    }];

    [labChannelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labDesc.mas_bottom).offset(30);
        make.left.equalTo(labDesc.mas_left);
    }];
    [txtChannelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labChannelNumber.mas_right).offset(15);
        make.width.equalTo(@180);
        make.baseline.equalTo(labChannelNumber.mas_baseline);
//        make.right.equalTo(containView.mas_right).offset(-20);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labChannelNumber.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.equalTo(labChannelNumber.mas_left);
        make.right.equalTo(containView.mas_right).offset(-2);
    }];

    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labChannelNumber.mas_bottom).offset(40);
        make.centerX.equalTo(containView);
        make.width.equalTo(containView.mas_width).offset(-60);
        make.height.equalTo(@44);
    }];
    
}
-(void)dismissViewController{
    [self hideKeybord];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL) volidateInputData{
    if ([[txtChannelNumber text] length] > 0) {
        NSString * regex = @"^[A-Za-z0-9]{1,12}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:[txtChannelNumber text]];
        if (!isMatch) {
            [JGProgressHUD showErrorStr:@"渠道验证码必须为字母和数字！"];
            return NO;
        }
    }else{
        ViewShaker *shakerText = [[ViewShaker alloc]initWithView:txtChannelNumber];
        UILabel *labChannelNumber = (UILabel *)[containView viewWithTag:1000001];
        ViewShaker *shakerLab = [[ViewShaker alloc]initWithView:labChannelNumber];
        [shakerText shake];
        [shakerLab shake];
        [self playSound];
        return NO;
    }
    return YES;
}
-(void) playSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound" ofType:@"caf"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_id);
        AudioServicesPlaySystemSound(shake_sound_id);
    }
    AudioServicesPlaySystemSound(shake_sound_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
-(void) searchChannelNumber{
    // 输入验证
    if ([self volidateInputData]){
            [self showHudInView:self.view hint:@"正在验证渠道信息..."];
            NSMutableDictionary *paramters = [NSMutableDictionary new];
            [paramters setObject:[txtChannelNumber text] forKey:@"saleschannelNumMd5"];
            __weak typeof(self) weakSelf = self;
            [Api invokeGet:YB_CHANNEL_NUMBER parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
                [weakSelf hideHud];
                if(resultObj){
                    if ([resultObj[@"respBody"] isEqual:[NSNull null]]) {
                        [JGProgressHUD showErrorStr:@"此渠道验证码无效，请检查输入!"];
                        return;
                    }
                    NSDictionary *dicChannelInfo = resultObj[@"respBody"];
                    NSUserDefaults *userDeautls = [NSUserDefaults standardUserDefaults];
                    [userDeautls setObject:dicChannelInfo[@"channelNum"] forKey:@"CHANNEL_NUMBER"];
                    [userDeautls setObject:dicChannelInfo[@"channelName"] forKey:@"CHANNEL_NAME"];
                    [userDeautls setObject:[txtChannelNumber text] forKey:@"CHANNEL_NUMBER_CODE"];
                    [userDeautls synchronize];
                    if (_isSettingPageType) {
                        [containView setHidden:YES];
                        [containViewPanel removeFromSuperview];
                        containViewPanel = nil;
                        [self showChannelNumberPage];
                        [self flipView];
                    }else{
                        [JGProgressHUD showSuccessStr:@"验证通过!"];
                        [self dismissViewController];
                    }
                }
            }];
    }
}
#pragma mark- 页面翻转
-(void) flipView {
    [self hideKeybord];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//    NSInteger fist= [[self.view subviews] indexOfObject:[self.view viewWithTag:1000]];
//    NSInteger seconde= [[self.view subviews] indexOfObject:[self.view viewWithTag:1001]];
//    [self.view exchangeSubviewAtIndex:fist withSubviewAtIndex:seconde];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(BOOL)hideKeybord{
    return txtChannelNumber.resignFirstResponder;
}
#pragma mark -TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return textField.resignFirstResponder;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (txtChannelNumber == textField){
        if ([aString length] > 12) {
            [JGProgressHUD showErrorStr:@"验证码长度不能超过12！"];
            return NO;
        }
    }
    return YES;
}
#pragma mark- showPanel
-(void) showChannelNumberPage{
    if (containViewPanel!=nil) {
        return ;
    }
    NSString *channelName = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"CHANNEL_NAME"]){
        channelName = [userDefaults objectForKey:@"CHANNEL_NAME"];
    }
    containViewPanel = [[UIView alloc]init];
    [containViewPanel setBackgroundColor:[UIColor whiteColor]];
    [containViewPanel setTag:1001];
    
    UILabel *labChannelName = [UILabel new];
    [labChannelName setText:[NSString stringWithFormat:@"渠道名称：%@",channelName]];
    [labChannelName setFont:DEFAULT_FONT(15)];
    [labChannelName setTextColor:DEFAULT_NAVBLUECOLOR];
    [labChannelName setTextAlignment:NSTextAlignmentLeft];
    [containViewPanel addSubview:labChannelName];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayLineColor];
    [containViewPanel addSubview:lineView];
    
    NSString *channelNumber = @"";
    if([userDefaults objectForKey:@"CHANNEL_NUMBER_CODE"]){
        channelNumber = [userDefaults objectForKey:@"CHANNEL_NUMBER_CODE"];
    }
    UILabel *labChannelNumber = [UILabel new];
    [labChannelNumber setText:[NSString stringWithFormat:@"渠道码：%@",channelNumber]];
    [labChannelNumber setFont:DEFAULT_FONT(15)];
    [labChannelNumber setTextColor:DEFAULT_NAVBLUECOLOR];
    [containViewPanel addSubview:labChannelNumber];
    
    UIView * lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor grayLineColor];
    [containViewPanel addSubview:lineView1];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setTitle:@"注销渠道码" forState:UIControlStateNormal];
    [btnSearch.titleLabel setFont:DEFAULT_BOLD_FONT(15)];
    [btnSearch setBackgroundColor:DEFAULT_BTNCOLOR];
    [btnSearch addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [containViewPanel addSubview:btnSearch];
    
    [self.view addSubview:containViewPanel];
    [containViewPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@200);
    }];
    
    [labChannelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containViewPanel).offset(15);
        make.left.equalTo(containViewPanel).offset(20);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labChannelName.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.equalTo(labChannelName.mas_left);
        make.right.equalTo(containViewPanel.mas_right).offset(-2);
    }];
    
    [labChannelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labChannelName.mas_bottom).offset(30);
        make.left.equalTo(labChannelName.mas_left);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labChannelNumber.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.equalTo(labChannelNumber.mas_left);
        make.right.equalTo(containViewPanel.mas_right).offset(-2);
    }];
    
    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labChannelNumber.mas_bottom).offset(40);
        make.centerX.equalTo(containViewPanel);
        make.width.equalTo(containViewPanel.mas_width).offset(-60);
        make.height.equalTo(@44);
    }];
}

-(void)logout{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确定注销渠道码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:10000];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
            return;
        }else if(buttonIndex == 1){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:nil forKey:@"CHANNEL_NUMBER"];
            [userDefaults setObject:nil forKey:@"CHANNEL_NAME"];
            [userDefaults setObject:nil forKey:@"CHANNEL_NUMBER_CODE"];
            [userDefaults synchronize];
            
            [containViewPanel setHidden:YES];
            [containView setHidden:NO];
            [self flipView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
