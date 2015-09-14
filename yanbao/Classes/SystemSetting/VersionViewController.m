//
//  VersionViewController.m
//  yanbao
//
//  Created by aokuny on 14/11/13.
//  Copyright (c) 2014年 juran. All rights reserved.
//

#import "VersionViewController.h"
#import "VersionModel.h"
#import "InsetsLabel.h"

@interface VersionViewController (){
    UITableView *gTableView;
    VersionModel *versionInfo;
}
@end

@implementation VersionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackBarButton];
    [self setTitle:@"版本信息"];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    gTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [gTableView setDelegate:self];
    [gTableView setDataSource:self];
    [gTableView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    gTableView.tableHeaderView = [self tableHeaderView];
    gTableView.tableFooterView = [self tableFooterView];
    if ([gTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [gTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:gTableView];
}

#pragma mark - tableview delegete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *) tableHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,250)];
    UIButton *btnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogo.layer.cornerRadius = 20;
    btnLogo.layer.masksToBounds = YES;
    [btnLogo setFrame:CGRectMake(0,0,87,87)];
    [btnLogo setBackgroundImage:[UIImage imageNamed:@"version"] forState:UIControlStateNormal];
    [btnLogo.imageView setContentMode:UIViewContentModeScaleToFill];
    CGPoint center = headerView.center;
    center.y -= 20;
    btnLogo.center = center;
    
    UILabel *labVersionNum = [[UILabel alloc]initWithFrame:CGRectMake(btnLogo.frame.origin.x,CGRectGetMaxY(btnLogo.frame)+2,
                                                                      btnLogo.frame.size.width,20)];
    [labVersionNum setTextColor:[UIColor grayColor]];
    [labVersionNum setFont:DEFAULT_FONT(16)];
//    [labVersionNum setText:[NSString stringWithFormat:@"版本：V %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]]];
    [labVersionNum setText:CHANNEL_DISPLAYVERSION];
    [labVersionNum setTextAlignment:NSTextAlignmentCenter];
    
    [headerView addSubview:labVersionNum];
    [headerView addSubview:btnLogo];
    return headerView;
}

-(UIView *)tableFooterView{
    float footerHeight = self.view.frame.size.height - 250 - 88 - 44 - 20;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,
                                                      footerHeight)];
    UILabel *labLoginDesc = [[UILabel alloc]initWithFrame:CGRectMake(0,footerHeight-40 -2,self.view.frame.size.width,20)];
    [labLoginDesc setText:@"chelenet.com"];
    [labLoginDesc setFont:DEFAULT_FONT(15)];
    [labLoginDesc setTextAlignment:NSTextAlignmentCenter];
    [labLoginDesc setTextColor:RGBCOLOR(210,210,210)];
    [footerView addSubview:labLoginDesc];
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"cell";
    UITableViewCell *Cell = [tableView  dequeueReusableCellWithIdentifier:cellIndentifer];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifer];
        [Cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.row == 0) {
        Cell.textLabel.text = @"检查更新";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults boolForKey:@"vsersionNeedUpdate"]){
            UIButton *updateView = [[UIButton alloc]initWithFrame:CGRectMake(2,0,40,15)];
            [updateView setBackgroundColor:[UIColor redColor]];
            [updateView setTitle:@"new" forState:UIControlStateNormal];
            [updateView.titleLabel setTextColor:[UIColor whiteColor]];
            [updateView.titleLabel setFont:DEFAULT_FONT(10)];
            updateView.layer.cornerRadius = 7;
            [Cell setAccessoryView:updateView];
            
            CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            //设置抖动幅度
            shake.fromValue = [NSNumber numberWithFloat:-0.1];
            shake.toValue = [NSNumber numberWithFloat:+0.1];
            shake.duration = 0.1;
            shake.autoreverses = YES; //是否重复
            shake.repeatCount = MAXFLOAT;
            [updateView.layer addAnimation:shake forKey:@"newbtnview"];
            [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
            Cell.detailTextLabel.text = @"有新版本！";
        }
    }else{
        Cell.textLabel.text = @"欢迎页";
    }
    return Cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        [JGProgressHUD showHintStr:@"暂无更新！"];
//        return ;
        [self checkVersion];
    }else{
        [JGProgressHUD showHintStr:@"欢迎使用车乐无忧客户端！"];
    }
}
#pragma mark 版本更新
-(void) checkVersion{
    [self showHudInView:self.view hint:@"正在检查版本..."];
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
                [JGProgressHUD showHintStr:@"暂无更新版本!"];
                return;
            }
            versionInfo = [[VersionModel alloc]initWithDictionary:resultObj[@"respBody"][0] error:&err];
            if (err) {
                [JGProgressHUD showErrorStr:@"获取版本信息失败！"];
                return ;
            }
            // 渠道号码、客户端类型、bundleId 必须匹配
            if([CHANNEL_GENRE isEqual: versionInfo.numclientGenre]&&
//               [CHANNEL_NUMBER isEqual:versionInfo.numchannelNumber]&&
               [localBundleIdKey isEqual:versionInfo.vc2packageValue]){
                // 对比版本
                if (localVersionKey.intValue < versionInfo.numversionCode.intValue){
                    NSString *msgcontent = [NSString stringWithFormat:@"已经发现新版本,是否确定更新？\n当前版本:%@ --> 新版本:%@",CHANNEL_DISPLAYVERSION,versionInfo.vc2versionName];
                    if (versionInfo.vc2versionDescription) {
                        msgcontent = [NSString stringWithFormat:@"%@\n%@",msgcontent,versionInfo.vc2versionDescription];
                    }
                    // 退出/注销
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:msgcontent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                }else{
                    [JGProgressHUD showHintStr:@"暂无更新版本!"];
                }
            }else{
                [JGProgressHUD showErrorStr:@"未发现对应的版本！"];
            }
        }
        [self hideHud];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100001111) {
        if (buttonIndex == 0) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
