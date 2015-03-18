//
//  MainViewController.m
//  yanbao
//
//  Created by aokuny on 14-12-16.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "SystemSettingViewController.h"
#import "VNCodeViewController.h"
#import "QuotePriceViewController.h"
#import "InMakingViewController.h"
#import "VersionModel.h"
#import "InsetsLabel.h"

@interface MainViewController (){
    VersionModel *versionInfo;
}
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self performSelectorInBackground:@selector(checkVersion) withObject:nil];
    
    BOOL isNeedLoadData = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastTime = [userDefaults objectForKey:@"UPDATETIME"];
    if (lastTime) {
        float dateInterval = [lastTime timeIntervalSinceNow];
        if (-dateInterval > 24*60*60) { // 与最后一次更新时间超过24小时，需要重新更新数据。
            isNeedLoadData = YES;
            [userDefaults setObject:[NSDate date] forKey:@"UPDATETIME"];
            [userDefaults synchronize];
        }
    }else{
        [userDefaults setObject:[NSDate date] forKey:@"UPDATETIME"];
        [userDefaults synchronize];
        isNeedLoadData = YES;
    }
    if (NO == [userDefaults boolForKey:@"HASDATA"]) {
        isNeedLoadData = YES;
    }
    if (isNeedLoadData) {
        if ([Api reachable]) {
            [self showHudInView:self.view hint:@"正在加载基础数据..."];
            [self performSelectorInBackground:@selector(loadServerData) withObject:nil];
        }else{
            [JGProgressHUD showErrorStr:@"网络异常，请检查是否联网！！"];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:DEFAULT_TITLE];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [self setRightBarButtonItemImage:@"setting-b" target:self action:@selector(pushToSettingPage)];
    [self initPage];
}
-(void) loadServerData{
    __block BOOL hasData = YES;
    NSDictionary *parameters =@{};
    [Api invokeGetSync:YB_BRANDLIST parameters:parameters completion:^(id resultObj,NSString *errMsg) {
        if (errMsg != nil) {
            hasData = NO;
            return ;
        }
        NSString *path = [self createFileByName:@"cartype"];
        NSMutableArray *carArr;
        if (resultObj) {
            NSDictionary *carBrandData = [resultObj valueForKey:@"respBody"];
            carArr = [NSMutableArray new];
            for (NSDictionary *dic in carBrandData) {
                [carArr addObject:dic[@"vc2brandname"]];
            }
        }
        else{
//            carArr = [[NSMutableArray alloc]initWithArray:@[]];
            hasData = NO;
        }
        if ([carArr count]>0) {
            [carArr writeToFile:path atomically:YES];
        }
    }];
    if (hasData == NO) {
        [self hideHud];
        [JGProgressHUD showErrorStr:@"您的网络异常，部分功能不能使用！"];
        return ;
    }
//    [Api invokeGetSync:YB_GEARBOX parameters:parameters completion:^(id resultObj,NSString *errMsg) {
//        if (errMsg != nil) {
//            hasData = NO;
//            return ;
//        }
//        NSString *path = [self createFileByName:@"gearbox"];
//        NSArray *carGearBoxData;
//        if (resultObj) {
//            carGearBoxData = [resultObj valueForKey:@"respBody"];
//        }
//        else{
////            carGearBoxData = @[];
//            hasData = NO;
//        }
//        if ([carGearBoxData count]>0) {
//            [carGearBoxData writeToFile:path atomically:YES];
//        }
//    }];
//    if (hasData == NO) {
//        [self hideHud];
//        [JGProgressHUD showErrorStr:@"您的网络异常，部分功能不能使用！"];
//        return ;
//    }
    [Api invokeGetSync:YB_DISPLACEMENT parameters:parameters completion:^(id resultObj,NSString *errMsg) {
        if (errMsg != nil) {
            hasData = NO;
            return ;
        }
        NSString *path = [self createFileByName:@"displacement"];
        NSArray *carDisplacementData;
        if (resultObj) {
            carDisplacementData = [resultObj valueForKey:@"respBody"];
        }
        else{
//            carDisplacementData = @[];
            hasData = NO;
        }
        if ([carDisplacementData count]>0) {
            [carDisplacementData writeToFile:path atomically:YES];
        }
    }];
    [self hideHud];
    if (hasData == NO) {
        [JGProgressHUD showErrorStr:@"您的网络异常，部分功能不能使用！"];
        return;
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"HASDATA"];
        [userDefaults synchronize];
    }
    
}

-(NSString *) createFileByName:(NSString *)filename{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filePath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",filename]];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filePath contents:nil attributes:nil];
    //NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return filePath;
}

-(void) initPage{
    
    UIView *bgView = [[UIView alloc]init];
    UIButton *btnBaike = [self createButtonWithColor:RGBCOLOR(26,150,213)];
    UIButton *btnVNCode = [self createButtonWithColor:DEFAULT_BTNCOLOR];
    UIButton *btnBizCall = [self createButtonWithColor:RGBCOLOR(26,150,213)];
    UIButton *btnPrice = [self createButtonWithColor:RGBCOLOR(26,150,213)];
    // Baike
    UILabel *labBaikeTitle = [self createTitleLableWithTitle:@"汽车延保百科"];
    labBaikeTitle.textColor = DEFAULT_BTNCOLOR;
    UILabel *labBaikeSubTitle = [self createSubTitleWithString:@"产品服务介绍"];
    labBaikeSubTitle.textColor = [UIColor whiteColor];
    UIImageView *imgvBaike = [UIImageView new];
    [imgvBaike setBackgroundColor:[UIColor clearColor]];
    [imgvBaike setImage:[UIImage imageNamed:@"baike"]];
    [btnBaike addSubview:labBaikeTitle];
    [btnBaike addSubview:labBaikeSubTitle];
    [btnBaike addSubview:imgvBaike];
//    [self.view addSubview:btnBaike];
    [bgView addSubview:btnBaike];
    // VNCode
    UILabel *labVNCodeTitle = [self createTitleLableWithTitle:@"VIN码报价"];
    [labVNCodeTitle setTextColor:[UIColor whiteColor]];
    UILabel *labVNCodeSubTitle = [self createSubTitleWithString:@"携带行驶证请选择"];
    [labVNCodeSubTitle setTextColor:[UIColor whiteColor]];
    UIImageView *imgVINCode = [UIImageView new];
    [imgVINCode setImage:[UIImage imageNamed:@"vincode"]];
    [imgVINCode setBackgroundColor:[UIColor clearColor]];
    [btnVNCode addSubview:labVNCodeTitle];
    [btnVNCode addSubview:labVNCodeSubTitle];
    [btnVNCode addSubview:imgVINCode];
//    [self.view addSubview:btnVNCode];
    [bgView addSubview:btnVNCode];
    // BizCall
    UILabel *labBizCallTitle = [self createTitleLableWithTitle:@"业务咨询"];
    [labBizCallTitle setTextColor:DEFAULT_BTNCOLOR];
    [labBizCallTitle setFont:DEFAULT_BOLD_FONT(17)];
    UILabel *labBizCallSubTitle = [self createSubTitleWithString:@"一键拨号咨询"];
    [labBizCallSubTitle setTextColor:[UIColor whiteColor]];
    UIImageView *imgvBizCall = [UIImageView new];
    [imgvBizCall setBackgroundColor:[UIColor clearColor]];
    [imgvBizCall setImage:[UIImage imageNamed:@"call"]];
    [btnBizCall addSubview:labBizCallTitle];
    [btnBizCall addSubview:labBizCallSubTitle];
    [btnBizCall addSubview:imgvBizCall];
//    [self.view addSubview:btnBizCall];
    [bgView addSubview:btnBizCall];
    // price
    UILabel *labPriceTitle = [self createTitleLableWithTitle:@"品牌报价"];
    [labPriceTitle setTextColor:DEFAULT_BTNCOLOR];
    UILabel *labPriceSubTitle = [self createSubTitleWithString:@"通过品牌排量报价"];
    [labPriceSubTitle setTextColor:[UIColor whiteColor]];
    UIImageView *imgPrice = [UIImageView new];
    [imgPrice setBackgroundColor:[UIColor clearColor]];
    [imgPrice setImage:[UIImage imageNamed:@"price"]];
    [btnPrice addSubview:labPriceTitle];
    [btnPrice addSubview:labPriceSubTitle];
    [btnPrice addSubview:imgPrice];
//    [self.view addSubview:btnPrice];
    [bgView addSubview:btnPrice];
    // bottom
    UIView *bottomView = [UIView new];
    UIImageView *imageBottom = [UIImageView new];
    [imageBottom setImage:[UIImage imageNamed:@"logo_bottom"]];
    [imageBottom setBackgroundColor:[UIColor clearColor]];
    UILabel *labDesc = [UILabel new];
    [labDesc setText:@"本汽车延保服务提供方为\n北京无线天利移动信息技术股份有限公司"];
    [labDesc setNumberOfLines:0];
    [labDesc setFont:DEFAULT_FONT(10)];
    [labDesc setTextColor:[UIColor grayColor]];
    [labDesc setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:imageBottom];
    [bottomView addSubview:labDesc];
    [self.view addSubview:bottomView];
//    [bgView addSubview:bottomView];
    
    [self.view addSubview:bgView];
    
//    [bgView setBackgroundColor:[UIColor redColor]];
    // Frame
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view.mas_left);
        make.centerY.equalTo(self.view.mas_centerY).offset(-60/2);
        make.height.equalTo(@320);
//        UIEdgeInsets padding = UIEdgeInsetsMake(10,0,10,0);
//        make.edges.equalTo(self.view).with.insets(padding);
    }];
    
    float margin = 15;
    
    // top
    [btnBaike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(margin);
        make.width.equalTo(bgView.mas_width).offset(-30);
        make.height.equalTo(@100);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    // left top
    [btnVNCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBaike.mas_bottom).offset(margin);
        make.left.equalTo(btnBaike.mas_left);
        make.height.equalTo(btnPrice.mas_height);
        make.width.equalTo(@[btnBizCall,btnPrice]);
    }];
    // right
    [btnBizCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnVNCode.mas_top);
        make.left.equalTo(btnVNCode.mas_right).offset(margin);
        make.right.equalTo(btnBaike.mas_right);
        make.height.equalTo(@200);
    }];
    // left bottom
    [btnPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnVNCode.mas_bottom).offset(margin);
        make.left.equalTo(btnBaike.mas_left);
        make.right.equalTo(btnVNCode.mas_right);
        make.bottom.equalTo(btnBizCall.mas_bottom);
    }];
    // content
    float titleMarginLeft = 10;
    float titleAndSubTitleSpace = 2;
    
    // baike
    [labBaikeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnBaike.mas_centerY).offset(-20);
        make.left.equalTo(btnBaike.mas_left).offset(titleMarginLeft);
    }];
    [labBaikeSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labBaikeTitle.mas_bottom).offset(titleAndSubTitleSpace);
        make.left.equalTo(labBaikeTitle.mas_left);
    }];
    [imgvBaike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnBaike.mas_centerY);
        make.right.equalTo(btnBaike.mas_right).offset(-10);
        make.height.equalTo(@70);
        make.width.equalTo(@65);
    }];
    // VNCode
    [imgVINCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnVNCode.mas_top).offset(titleMarginLeft);
        make.left.equalTo(btnVNCode.mas_left).offset(titleMarginLeft);
        make.height.equalTo(@(84/2));
        make.width.equalTo(@(68/2));
    }];
    [labVNCodeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgVINCode.mas_bottom).offset(titleAndSubTitleSpace);
        make.left.equalTo(imgVINCode.mas_left);
    }];
    [labVNCodeSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labVNCodeTitle.mas_bottom).offset(titleAndSubTitleSpace);
        make.left.equalTo(labVNCodeTitle.mas_left);
    }];
    // BizCall
    [imgvBizCall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btnBizCall.mas_centerX);
        make.height.equalTo(@(90/2));
        make.width.equalTo(@(130/2));
        make.centerY.equalTo(btnBizCall.mas_centerY).offset(-30);
    }];
    [labBizCallTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(btnBizCall.mas_top).offset(25);
        make.top.equalTo(imgvBizCall.mas_bottom).offset(titleAndSubTitleSpace*3);
        make.centerX.equalTo(btnBizCall.mas_centerX);
    }];
    [labBizCallSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labBizCallTitle.mas_bottom).offset(titleAndSubTitleSpace);
        make.centerX.equalTo(btnBizCall.mas_centerX);
    }];

    // price
    [imgPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnPrice.mas_top).offset(titleMarginLeft);
        make.left.equalTo(btnPrice.mas_left).offset(titleMarginLeft);
        make.height.equalTo(@(77/2));
        make.width.equalTo(@(94/2));
    }];
    [labPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPrice.mas_left);
        make.top.equalTo(imgPrice.mas_bottom).offset(titleAndSubTitleSpace);
    }];
    [labPriceSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labPriceTitle.mas_bottom).offset(titleAndSubTitleSpace);
        make.left.equalTo(labPriceTitle.mas_left);
    }];
    // bottom
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnBaike.mas_left);
        make.right.equalTo(btnBaike.mas_right);
        make.height.equalTo(@60);
//        make.width.equalTo(self.view.mas_width).offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    [imageBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.width.equalTo(@100);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left);
    }];
    [labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBottom.mas_right).offset(4);
        make.right.equalTo(bottomView.mas_right);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    // Event
    [btnBaike handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//        [JGProgressHUD showHintStr:@"Building"];
        InMakingViewController *inMakingVC = [[InMakingViewController alloc]init];
        [self.navigationController pushViewController:inMakingVC animated:YES];
    }];
    [btnVNCode handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        VNCodeViewController *vncodeVC = [[VNCodeViewController alloc]init];
        [self.navigationController pushViewController:vncodeVC animated:YES];
    }];
    [btnBizCall handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",DEFAULT_PHONENUMBER];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [btnPrice handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults boolForKey:@"HASDATA"]) {
            QuotePriceViewController *qpVC = [[QuotePriceViewController alloc]init];
            [self.navigationController pushViewController:qpVC animated:YES];
        }else{
             [JGProgressHUD showErrorStr:@"您未连接网络，部分功能不能使用！"];
        }
    }];
}
-(UIButton *) createButtonWithColor:(UIColor *) color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    btn.layer.cornerRadius = 10;
//    btn.layer.shadowOffset =  CGSizeMake(3.0,5.0);
//    btn.layer.shadowOpacity = 0.5;
//    btn.layer.shadowRadius = 5;
//    btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    return btn;
}
-(UILabel *) createTitleLableWithTitle:(NSString *)title{
    UILabel *labTitle = [UILabel new];
    [labTitle setTextAlignment:NSTextAlignmentLeft];
    [labTitle setTextColor:[UIColor blackColor]];
    [labTitle setFont:DEFAULT_BOLD_FONT(15)];
    [labTitle setText:title];
    [labTitle setBackgroundColor:[UIColor clearColor]];
    return labTitle;
}
-(UILabel *) createSubTitleWithString:(NSString *)titleString{
    UILabel *labSubTitle = [self createTitleLableWithTitle:titleString];
    [labSubTitle setTextColor:[UIColor grayColor]];
    [labSubTitle setFont:DEFAULT_FONT(11)];
    return labSubTitle;
}
- (void)pushToSettingPage{
    SystemSettingViewController *sysSettingVC = [SystemSettingViewController new];
    [self.navigationController pushViewController:sysSettingVC animated:YES];
}


#pragma mark 版本更新
-(void) checkVersion{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *packageKey = @"vc2packageValue"; //package
    NSString *channelNumberKey = @"numchannelNumber";  //渠道号
    NSString *clinetGenreKey = @"numclientGenre";   //app 类型
    NSString *versionCodeKey = @"numversionCode";    //版本号
    NSString *localVersionKey =[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *localBundleIdKey =[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
    NSDictionary *paramters = @{packageKey:localBundleIdKey,
                                channelNumberKey:CHANNEL_NUMBER,
                                clinetGenreKey:CHANNEL_GENRE,
                                versionCodeKey:[NSString stringWithFormat:@"%d",localVersionKey.intValue]};
    __weak typeof(self) weakSelf = self;
    [Api invokeGet:YB_VERSION_INFO parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
        if (resultObj) {
            [weakSelf hideHud];
            NSError *err = nil;
            if ([resultObj[@"respBody"] isEqual:[NSNull null]]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setBool:NO forKey:@"vsersionNeedUpdate"];
                [userDefaults synchronize];
                return;
            }
            versionInfo = [[VersionModel alloc]initWithDictionary:resultObj[@"respBody"][0] error:&err];
            if (err){
                return;
            }
            // 渠道号码、客户端类型、bundleId 必须匹配
            if([CHANNEL_GENRE isEqual: versionInfo.numclientGenre]&&
               [CHANNEL_NUMBER isEqual:versionInfo.numchannelNumber]&&
               [localBundleIdKey isEqual:versionInfo.vc2packageValue]){
                // 对比版本
                if (localVersionKey.intValue < versionInfo.numversionCode.intValue){
                    if([versionInfo.nummanualCode isEqualToString:@"1"]){
                        NSString *msgcontent = [NSString stringWithFormat:@"客户端需要更新后才能使用，是否现在更新？\n当前版本:%@ --> 新版本:%@",CHANNEL_DISPLAYVERSION,versionInfo.vc2versionName];
                        if(versionInfo.vc2versionDescription) {
                            msgcontent = [NSString stringWithFormat:@"%@\n%@",msgcontent,versionInfo.vc2versionDescription];
                        }
                        // 退出/注销
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:msgcontent delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"升级", nil];
                        [alert setTag:100001111];
                        CGSize size = [msgcontent sizeWithFont:DEFAULT_FONT(14) constrainedToSize:CGSizeMake(236,400) lineBreakMode:NSLineBreakByWordWrapping];
                        InsetsLabel *textLabel = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,0,236,size.height)];
                        textLabel.font = DEFAULT_FONT(14);
                        textLabel.textColor = [UIColor blackColor];
                        textLabel.backgroundColor = [UIColor clearColor];
                        textLabel.insets = UIEdgeInsetsMake(-2,5,0,5);
                        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        textLabel.numberOfLines = 0;
                        textLabel.textAlignment = NSTextAlignmentLeft;
                        textLabel.text = msgcontent;
                        [alert setValue:textLabel forKey:@"accessoryView"];
                        alert.message = @"";
                        [alert show];
                    }
                    else{
                        // 有更新，但不是强制
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setBool:YES forKey:@"vsersionNeedUpdate"];
                        [userDefaults synchronize];
                    }
                }
            }
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:@"vsersionNeedUpdate"];
            [userDefaults synchronize];
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"vsersionNeedUpdate"];
    [userDefaults synchronize];
    if (alertView.tag == 100001111) {
        if (buttonIndex == 0) {
            [UIView animateWithDuration:1.0f animations:^{
                [UIApplication sharedApplication].delegate.window.alpha = 0;
//                [UIApplication sharedApplication].delegate.window.frame =
//                CGRectMake(0, 0,[UIApplication sharedApplication].delegate.window.bounds.size.width, 0);
            } completion:^(BOOL finished) {
                exit(EXIT_SUCCESS);
            }];
            return;
        }else if(buttonIndex == 1){
            if (versionInfo != nil) {
                // 服务端返回的下载路径
                NSString *serverUrlPath = versionInfo.vc2iosplistUrl;
                NSString *downloadUrl =[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",serverUrlPath];
                NSURL *url = [NSURL URLWithString:downloadUrl];
                if ([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url];
                    exit(EXIT_SUCCESS);
                } else {
                    [JGProgressHUD showErrorStr:@"无法打开下载地址！"];
                }
            }
            else{
                [JGProgressHUD showHintStr:@"更新出现问题，请重试！"];
            }
        }
    }
}
#pragma mark 修改弹出窗口的文字左对齐
// ios 6
//-(void)willPresentAlertView:(UIAlertView *)alertView{
//    for(UIView *view in alertView.subviews){
//        if( [view isKindOfClass:[UILabel class]]){
//            UILabel* label = (UILabel*)view;
//            label.textAlignment = NSTextAlignmentLeft;
//        }
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
