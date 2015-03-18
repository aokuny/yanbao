//
//  QuotePriceProductListViewController.m
//  yanbao
//  用于显示报价查询后，未选中产品的情况下，显示的产品列表
//  Created by aokuny on 14/12/17.
//
//

#import "QuotePriceProductListViewController.h"
#import "ProgressView.h"
#import "ActivityListViewController.h"
#import "NoActivityViewController.h"
#import "ChannelNumberViewController.h"

@interface QuotePriceProductListViewController (){
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation QuotePriceProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self setTitle:DEFAULT_TITLE];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initTableView];
    [self loadServerData];
}
-(void)initTableView{
    _tableView = [UITableView new];
    [_tableView setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-62)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
    [_tableView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [_tableView setBounces:NO];
    [self.view addSubview:_tableView];

    UIView *bgHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,42)];
    [bgHeaderView setBackgroundColor:DEFAULT_BTNCOLOR];
    UILabel *labProductName = [UILabel new];
    [labProductName setText:@"产品名称"];
    [labProductName setTextColor:[UIColor whiteColor]];
    [labProductName setFont:DEFAULT_BOLD_FONT(16)];
    [bgHeaderView addSubview:labProductName];
    
    UILabel *labPrice = [UILabel new];
    [labPrice setText:@"价格"];
    [labPrice setFont:DEFAULT_BOLD_FONT(16)];
    [labPrice setTextColor:[UIColor whiteColor]];
    [bgHeaderView addSubview:labPrice];
    
    [labProductName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@180);
        make.left.equalTo(bgHeaderView.mas_left).offset(15);
        make.centerY.equalTo(bgHeaderView.mas_centerY);
    }];
    
    [labPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@80);
        make.left.equalTo(labProductName.mas_right);
        make.centerY.equalTo(bgHeaderView.mas_centerY);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayLineColor];
    lineView.frame = CGRectMake(0,CGRectGetMaxY(bgHeaderView.frame), self.view.frame.size.width,1);
    [bgHeaderView addSubview:lineView];
    _tableView.tableHeaderView = bgHeaderView;
    _tableView.tableFooterView = [UIView new];
    
}
-(void)loadServerData {
    _dataArray = [NSMutableArray arrayWithArray:_productList.respBody];
    [_tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    lineView.backgroundColor = [UIColor grayLineColor];
    
    UIView *bgFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    [bgFooterView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    UIButton *btnQuotePrice = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnQuotePrice.layer.cornerRadius = 10;
    [btnQuotePrice setFrame:CGRectMake(30,10,ScreenWidth-60,44)];
    [btnQuotePrice setBackgroundColor:DEFAULT_BTNCOLOR];
    [btnQuotePrice setTitle:@"活动查询" forState:UIControlStateNormal];
    [btnQuotePrice.titleLabel setFont:DEFAULT_BOLD_FONT(17)];
    [btnQuotePrice handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if(![self judgeChanelNumberLocal]){
            return;
        }
        NSMutableDictionary *paramters = [NSMutableDictionary new];
        NSMutableArray *arrProductID = [NSMutableArray new];
        for (ProductModel *proModel in _dataArray) {
            [arrProductID addObject:proModel.vc2proId];
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *vc2proId = [arrProductID componentsJoinedByString:@","];
        [paramters setValue:vc2proId forKey:@"vc2proId"];
        [paramters setValue:[userDefaults objectForKey:@"CHANNEL_NUMBER"] forKey:@"channelNum"];
        [self showHudInView:self.view hint:@"正在获取活动列表..."];
        __weak typeof(self) weakSelf = self;
        [Api invokeGet:YB_ACTIVITYLIST_NEW parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
            [weakSelf hideHud];
            if (resultObj) {
                NSError *err = nil;
                ActivityList *activityList = [[ActivityList alloc]initWithDictionary:resultObj error:&err];
                if (err) {
                    [JGProgressHUD showHintStr:@"暂无优惠活动！"];
                    return ;
                }
                if ([[[NSArray alloc]initWithArray:activityList.respBody] count]>0) {
                    ActivityListViewController *activityVC = [[ActivityListViewController alloc]init];
                    activityVC.activityList = activityList;
                    activityVC.productList = self.productList;
                    [self.navigationController pushViewController:activityVC animated:YES];
                }else{
                    NoActivityViewController *noActivityVC = [[NoActivityViewController alloc]init];
                    [self.navigationController pushViewController:noActivityVC animated:YES];
                }
            }
        }];
    }];
    [bgFooterView addSubview:lineView];
    [bgFooterView addSubview:btnQuotePrice];
    return bgFooterView;
}
*/
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIndentifer = @"cell";
    NSString *cellIndentifer = [NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *labProductName = [UILabel new];
        [labProductName setFont:DEFAULT_FONT(13)];
        [labProductName setTextColor:[UIColor blackColor]];
        [labProductName setTextAlignment:NSTextAlignmentLeft];
        
        ProductModel * productModel = _dataArray[indexPath.row];
        [labProductName setText:[NSString stringWithFormat:@"%@",productModel.vc2proName]];
        
        UILabel *labProductValue = [UILabel new];
        [labProductValue setFont:DEFAULT_BOLD_FONT(15)];
        [labProductValue setTextColor:RGBCOLOR(0,175,233)];
        [labProductValue setTextAlignment:NSTextAlignmentLeft];
        [labProductValue setText:[NSString stringWithFormat:@"%@ 元",productModel.price]];
        [cell addSubview:labProductName];
        [cell addSubview:labProductValue];
        
        [labProductName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.width.equalTo(@180);
            make.left.equalTo(cell.mas_left).offset(15);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        
        [labProductValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@100);
            make.left.equalTo(labProductName.mas_right);
            make.centerY.equalTo(cell.mas_centerY);
        }];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
