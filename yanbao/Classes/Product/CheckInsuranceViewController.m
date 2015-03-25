//
//  CheckInsuranceViewController.m
//  yanbao
//
//  Created by aokuny on 15/3/19.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import "CheckInsuranceViewController.h"
#import "ChannelNumberViewController.h"
static SystemSoundID shake_sound_id = 0;
@interface CheckInsuranceViewController (){
    UITableView *bgTableView;
    UITextField *txtVNCode;
    UITextField *txtInsurance;
}
@end

@implementation CheckInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self setTitle:@"核保查询"];
    [self setRightBarButtonItemImage:@"setting-b" target:self action:@selector(pushToCheckListPage)];
    bgTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,self.view.frame.size.height)];
    [bgTableView setDelegate:self];
    [bgTableView setDataSource:self];
    [bgTableView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [bgTableView setScrollEnabled:NO];
    [self.view addSubview:bgTableView];
}
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:DEFAULT_FONT(15)];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        if(indexPath.row == 0){
            txtVNCode = [UITextField new];
            [txtVNCode setTextAlignment:NSTextAlignmentLeft];
            [txtVNCode setBackgroundColor:[UIColor whiteColor]];
            [txtVNCode setTextColor:[UIColor grayColor]];
            [txtVNCode setFont:DEFAULT_FONT(15)];
            cell.textLabel.text = @"VIN码：";
            [txtVNCode setPlaceholder:@"请入VIN码"];
            [txtVNCode setTag:10000+indexPath.row];
            [cell addSubview:txtVNCode];
            [txtVNCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top);
                make.width.equalTo(@180);
                make.height.equalTo(@44);
                make.right.equalTo(cell.mas_right).offset(-24);
            }];
            [txtVNCode setDelegate:self];
        }else{
            txtInsurance = [UITextField new];
            [txtInsurance setTextAlignment:NSTextAlignmentLeft];
            [txtInsurance setBackgroundColor:[UIColor whiteColor]];
            [txtInsurance setTextColor:[UIColor grayColor]];
            [txtInsurance setFont:DEFAULT_FONT(15)];
            
            cell.textLabel.text = @"车牌号码：";
            [txtInsurance setPlaceholder:@"如：京A00001"];
            [txtInsurance setTag:10000+indexPath.row];
            [cell addSubview:txtInsurance];
            [txtInsurance mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top);
                make.width.equalTo(@180);
                make.height.equalTo(@44);
                make.right.equalTo(cell.mas_right).offset(-24);
            }];
            [txtInsurance setDelegate:self];
        }

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}
-(BOOL) volidateInputData{
    if ([[txtVNCode text] length] > 0) {
        NSString * regex = @"^[A-Za-z0-9]{1,30}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:[txtVNCode text]];
        if (!isMatch) {
            [JGProgressHUD showErrorStr:@"vin码必须为字母和数字！"];
            return NO;
        }
    }
    return YES;
}
#pragma mark 验证本地是否已经验证
-(BOOL) judgeChanelNumberLocal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"CHANNEL_NUMBER"]){
        return YES;
    }else{
        ChannelNumberViewController *chanelView = [ChannelNumberViewController new];
        BaseNavigationController *b = [[BaseNavigationController alloc]init];
        [b addChildViewController:chanelView];
        [self presentViewController:b animated:YES completion:^{}];
        return NO;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    lineView.backgroundColor = [UIColor grayLineColor];
    
    UIView *bgFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,100)];
    [bgFooterView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    UIButton *btnQuotePrice = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnQuotePrice setFrame:CGRectMake(30,40,ScreenWidth-60,44)];
    [btnQuotePrice setBackgroundColor:DEFAULT_BTNCOLOR];
    [btnQuotePrice setTitle:@"查 询" forState:UIControlStateNormal];
    [btnQuotePrice.titleLabel setFont:DEFAULT_BOLD_FONT(17)];
    [btnQuotePrice handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if(![self judgeChanelNumberLocal]){
            return;
        }
        if(![self volidateInputData]){
            return;
        }
        NSMutableDictionary *paramters = [NSMutableDictionary new];
        for (int i=0 ; i<2 ; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [bgTableView cellForRowAtIndexPath:indexpath];
            UITextField *txt = (UITextField *)[cell viewWithTag:i+10000];
            if ([[txt text] length] == 0) {
                ViewShaker *shakerText = [[ViewShaker alloc]initWithView:txt];
                ViewShaker *shakerLab = [[ViewShaker alloc]initWithView:cell.textLabel];
                [shakerText shake];
                [shakerLab shake];
                [self playSound];
                return;
            }
            if(i==0){
                [paramters setObject:txt.text forKey:@"carVin"];
            }else if (i==1){
                [paramters setObject:txt.text forKey:@"carNo"];
            }
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [paramters setObject:[userDefaults objectForKey:@"CHANNEL_NUMBER_CODE"] forKey:@"saleschannelUserNumMd5"];
        [self showHudInView:self.view hint:@"正在增加查询..."];
        __weak typeof(self) weakSelf = self;
        [Api invokeGet:YB_CHECKADD parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
            [weakSelf hideHud];
            if (![resultObj isEqual:[NSNull null]]) {
                CheckInListViewController *chekList = [CheckInListViewController new];
                [self.navigationController pushViewController:chekList animated:YES];
            }else{
                [JGProgressHUD showErrorStr:@"增加查询失败！"];
            }
        }];
    }];
    [bgFooterView addSubview:lineView];
    [bgFooterView addSubview:btnQuotePrice];
    return bgFooterView;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == txtVNCode)
    {
        if ([aString length] > 30) {
            [JGProgressHUD showErrorStr:@"VIN码长度不能超过30！"];
            return NO;
        }
    }else{
        if ([aString length] > 10) {
            [JGProgressHUD showErrorStr:@"车牌号码长度超长！"];
            return NO;
        }
    }
    return YES;
}
-(void)pushToCheckListPage{
    CheckInListViewController *chekList = [CheckInListViewController new];
    [self.navigationController pushViewController:chekList animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
