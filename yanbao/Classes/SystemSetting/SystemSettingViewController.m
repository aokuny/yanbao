//
//  SystemSettingViewController.m
//  yanbao
//
//  Created by aokuny on 14/11/10.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "VersionViewController.h"
#import "AboutUsViewController.h"
#import "CommonQuestionViewController.h"
#import "ChannelNumberViewController.h"

@interface SystemSettingViewController (){
    UITableView *gTableView;
    UIActivityIndicatorView *indicatorView;
}
@end

@implementation SystemSettingViewController

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
    [self setTitle:@"设置"];
    
    gTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    [gTableView setDelegate:self];
    [gTableView setDataSource:self];
    [gTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    gTableView.tableFooterView = [UIView new];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    [headerView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    gTableView.tableHeaderView = headerView;
    [gTableView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [self.view addSubview:gTableView];
    
    if ([gTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [gTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    UITableViewCell *cell = [gTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"CHANNEL_NUMBER"]){
        cell.detailTextLabel.text = @"已验证";
    }else{
        cell.detailTextLabel.text = @"未验证";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 3;
//    暂时去掉清除缓存
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellValue1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    [cell.textLabel setTextColor:DEFAULT_NAVBLUECOLOR];
    cell.contentMode = UIViewContentModeScaleToFill;
    if(indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"abouticon"];
        cell.textLabel.text = @"关于车乐无忧";
        cell.detailTextLabel.text = @"";
    }else if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"commonicon"];
        cell.textLabel.text = @"常见问题";
    }else if(indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"versionicon"];
        cell.textLabel.text = @"版本信息";
//        cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        cell.detailTextLabel.text = CHANNEL_DISPLAYVERSION;
    }else if(indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"clearcache"];
        cell.textLabel.text = @"清除缓存";
        cell.detailTextLabel.text = @"";
    }else if(indexPath.row == 4){
        cell.imageView.image = [UIImage imageNamed:@"channelverify"];
        cell.textLabel.text = @"渠道验证";
    }
    
    CGSize itemSize = CGSizeMake(30,30);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {       //关于
        AboutUsViewController *aboutUsVC = [AboutUsViewController new];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }else if(indexPath.row == 1){   // 常见问题
        CommonQuestionViewController *cqVC = [CommonQuestionViewController new];
        [self.navigationController pushViewController:cqVC animated:YES];
    }if (indexPath.row == 2) {      // 版本
        VersionViewController *versionVC = [[VersionViewController alloc]init];
        [self.navigationController pushViewController:versionVC animated:YES];
    }else if(indexPath.row == 3){   // 清除缓存
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"清除缓存将重新加载数据，是否确定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setTag:100003333];
        [alert show];
    }else if(indexPath.row == 4){
        ChannelNumberViewController *channelNumberVC = [ChannelNumberViewController new];
        channelNumberVC.isSettingPageType = YES;
        [self.navigationController pushViewController:channelNumberVC animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100003333) {
        if (buttonIndex == 0) {
            return;
        }else if(buttonIndex == 1){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [gTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"正在清除中...";
            [self performSelector:@selector(clearTmpData) withObject:nil afterDelay:1];
        }
    }
}
-(void)clearTmpData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"UPDATETIME"];
    [userDefaults setBool:NO forKey:@"HASDATA"];
    [userDefaults synchronize];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [gTableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = @"";
    [JGProgressHUD showSuccessStr:@"清理完毕！"];
}

@end
