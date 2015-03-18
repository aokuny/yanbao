//
//  VNCodeViewController.m
//  yanbao
//
//  Created by aokuny on 14/12/16.
//
//

#import "VNCodeViewController.h"
#import "QuotePriceViewController.h"
#import "CarInfo.h"
#import "ProgressView.h"

@interface VNCodeViewController (){
    UITextField *txtVNCode;
    UIScrollView *bgScrollView;
}

@end

@implementation VNCodeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [bgScrollView setContentSize:CGSizeMake(self.view.frame.size.width,480)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self setTitle:DEFAULT_TITLE];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    ProgressView *progessView = [[ProgressView alloc]initWithStatusCount:3 andDescriptionArray:@[@"参数选择",@"快速报价",@"活动查询"] andCurrentStatus:1 andFrame:CGRectMake(0,0,ScreenWidth,80)];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
//    [headerView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    bgScrollView = [UIScrollView new];
    [bgScrollView setBounces:NO];
//    [bgScrollView setBackgroundColor:[UIColor whiteColor]];

    UILabel *labVNCode = [[UILabel alloc]init];
    [labVNCode setText:@"车架号"];
    [labVNCode setFont:DEFAULT_BOLD_FONT(14)];
    [labVNCode setBackgroundColor:[UIColor clearColor]];
    
    txtVNCode = [[UITextField alloc]init];
    [txtVNCode setDelegate:self];
    [txtVNCode setPlaceholder:@"请输入17位VIN码"];
    [txtVNCode setTextAlignment:NSTextAlignmentLeft];
    [txtVNCode setFont:DEFAULT_FONT(15)];
    txtVNCode.keyboardType = UIKeyboardTypeNamePhonePad;
    txtVNCode.returnKeyType = UIReturnKeyDone;
    txtVNCode.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    txtVNCode.autocorrectionType = UITextAutocorrectionTypeNo;
    txtVNCode.clearButtonMode = UITextFieldViewModeAlways;
    
    UIView * vinCodelineView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(headerView.frame),ScreenWidth,1)];
    vinCodelineView.backgroundColor = [UIColor grayLineColor];
    [self.view addSubview:vinCodelineView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(txtVNCode.frame),ScreenWidth,1)];
    lineView.backgroundColor = [UIColor grayLineColor];
    [self.view addSubview:lineView];
    
    UIButton *btnOneKeySearch = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnOneKeySearch.layer.cornerRadius = 10;
    [btnOneKeySearch setTitle:@"下一步" forState:UIControlStateNormal];
    [btnOneKeySearch.titleLabel setFont:DEFAULT_BOLD_FONT(17)];
    [btnOneKeySearch setBackgroundColor:DEFAULT_BTNCOLOR];
    [btnOneKeySearch addTarget:self action:@selector(searchVNCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"alert"]];
    
    UIView *bottomView = [UIView new];
    [bottomView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    UILabel *labDesc = [UILabel new];
    [labDesc setBackgroundColor:[UIColor clearColor]];
    [labDesc setFont:DEFAULT_FONT(12)];
    [labDesc setText:@"如无该数据，请直接点击\"下一步\""];
    [labDesc setTextColor:[UIColor blackColor]];
    [bottomView addSubview:labDesc];
    [bottomView addSubview:btnOneKeySearch];
    
//    [bgScrollView addSubview:progessView];
    [bgScrollView addSubview:headerView];
    [bgScrollView addSubview:labVNCode];
    [bgScrollView addSubview:txtVNCode];
    [bgScrollView addSubview:imageView];
    [bgScrollView addSubview:bottomView];
    [self.view addSubview:bgScrollView];
    
    //Tap Touch
    UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeybord)];
    _tapGesture.delegate = self;
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:_tapGesture];
    
    [bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [labVNCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(txtVNCode.mas_left);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    [txtVNCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labVNCode.mas_top);
        make.left.equalTo(labVNCode.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    [vinCodelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txtVNCode.mas_top).offset(-10);
        make.width.equalTo([NSNumber numberWithFloat:ScreenWidth]);
        make.height.equalTo(@1);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txtVNCode.mas_bottom).offset(10);
        make.width.equalTo(@(self.view.frame.size.width));
        make.height.equalTo(@1);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.left.equalTo(labVNCode.mas_left);
        make.right.equalTo(txtVNCode.mas_right);
        make.height.equalTo(@180);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@30);
    }];
    
    [btnOneKeySearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labDesc.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(self.view.frame.size.width-60));
        make.height.equalTo(@44);
    }];
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
-(void) searchVNCode{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"HASDATA"]) {
    }else{
        [JGProgressHUD showErrorStr:@"您未连接网络，部分功能不能使用！"];
        return;
    }
    
    // 输入验证
    if ([self volidateInputData]) {
         if ([[txtVNCode text] length] > 0) {
             [self showHudInView:self.view hint:@"正在获取车辆信息..."];
             NSMutableDictionary *paramters = [NSMutableDictionary new];
             [paramters setObject:[txtVNCode text] forKey:@"vin"];
             __weak typeof(self) weakSelf = self;
             [Api invokeGet:YB_INFOBYVIN parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
                 [weakSelf hideHud];
                 if (resultObj) {
                     NSError *err = nil;
                     CarInfo *carInfo = [[CarInfo alloc]initWithDictionary:resultObj[@"respBody"] error:&err];
                     if (err) {
                         [JGProgressHUD showErrorStr:@"此vin码为无效vin码！"];
                         return ;
                     }
                     QuotePriceViewController *qpVC = [QuotePriceViewController new];
                     qpVC.vnCode = txtVNCode.text;
                     qpVC.carInfo = carInfo;
                     [self.navigationController pushViewController:qpVC animated:YES];
                 }
             }];
         }else{
             QuotePriceViewController *qpVC = [QuotePriceViewController new];
             [self.navigationController pushViewController:qpVC animated:YES];
         }
    }
}
-(BOOL)hideKeybord{
    return txtVNCode.resignFirstResponder;
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
    if (txtVNCode == textField)
    {
        if ([aString length] > 30) {
            [JGProgressHUD showErrorStr:@"VIN码长度不能超过30！"];
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
