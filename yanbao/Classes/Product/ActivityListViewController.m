//
//  ActivityListViewController.m
//  yanbao
//  优惠活动列表
//  Created by aokuny on 14/12/23.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ProgressView.h"
#import "UIButton+Block.h"
#import "QuotePriceDetailViewController.h"
#import "PriceList.h"

@interface ActivityListViewController (){
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation ActivityListViewController

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
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    UIView *bgHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,82)];
    [bgHeaderView setBackgroundColor:[UIColor whiteColor]];
    ProgressView *progessView = [[ProgressView alloc]initWithStatusCount:3 andDescriptionArray:@[@"参数选择",@"快速报价",@"活动查询"] andCurrentStatus:3 andFrame:CGRectMake(0,0,ScreenWidth,81)];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayLineColor];
    lineView.frame = CGRectMake(0,CGRectGetMaxY(progessView.frame), self.view.frame.size.width,1);
    [bgHeaderView addSubview:progessView];
    [bgHeaderView addSubview:lineView];
    _tableView.tableHeaderView = bgHeaderView;
    
}
-(void)loadServerData {
//    _dataArray = [NSMutableArray arrayWithArray:@[@{@"activityname":@"内部员工优惠",@"activityvalue":@"1"},
//                                                  @{@"activityname":@"大客户优惠",@"activityvalue":@"2"},
//                                                  @{@"activityname":@"渠道价格优惠",@"activityvalue":@"3"},
//                                                  ]];
    _dataArray = [NSMutableArray arrayWithArray:self.activityList.respBody];
    [_tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,100)];
    [bgFooterView setBackgroundColor:[UIColor whiteColor]];
    [self defaultBottomViewWithSuper:bgFooterView];
    return bgFooterView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityModel *activityModel = _dataArray[indexPath.row];
    NSMutableDictionary *paramters = [NSMutableDictionary new];
    [paramters setValue:activityModel.numactivityId forKey:@"numactivityId"];
    NSMutableArray *arrProduct = [NSMutableArray new];
//    查询出的产品拼接的字符串：产品ID-产品名称-原价-一次报价
    for (ProductModel *productModel in self.productList.respBody) {
        NSMutableString *strItems = [NSMutableString new];
        [strItems appendString:productModel.vc2proId];
        [strItems appendString:@"-"];
        [strItems appendString:productModel.vc2proName];
        [strItems appendString:@"-"];
        [strItems appendString:productModel.price];
        [strItems appendString:@"-"];
        [strItems appendString:productModel.fristPrice];
        [arrProduct addObject:strItems];
    }
    NSString *items = [arrProduct componentsJoinedByString:@","];
    [paramters setValue:items forKey:@"items"];
    [self showHudInView:self.view hint:@"正在获取优惠价格列表..."];
    __weak typeof(self) weakSelf = self;
    [Api invokeGet:YB_PRICE parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
        [weakSelf hideHud];
        if (resultObj) {
            NSError *err = nil;
            PriceList *priceList = [[PriceList alloc]initWithDictionary:resultObj error:&err];
            if (err) {
//                showAlertMessage(err.localizedDescription);
                [JGProgressHUD showHintStr:@"暂无优惠价格！"];
                return ;
            }
            QuotePriceDetailViewController *priceDetailVC = [[QuotePriceDetailViewController alloc]init];
            priceDetailVC.priceList = priceList;
            [self.navigationController pushViewController:priceDetailVC animated:YES];
        }else{
            [JGProgressHUD showHintStr:@"暂无优惠价格！"];
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifer =[NSString stringWithFormat:@"cellactivity%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    }
    UIButton *btnActivity = [UIButton buttonWithType:UIButtonTypeCustom];
    ActivityModel *activityModel = _dataArray[indexPath.row];
    [btnActivity setTitle:activityModel.vc2activityName forState:UIControlStateNormal];
    //        btnActivity.layer.cornerRadius = 10;
    [btnActivity setBackgroundColor:DEFAULT_NAVBLUECOLOR];
    [btnActivity.titleLabel setFont:DEFAULT_BOLD_FONT(17)];
    btnActivity.userInteractionEnabled = NO;
    //        [btnActivity handleControlEvent:UIControlEventTouchUpInside withBlock:^{}];
    [cell addSubview:btnActivity];
    [btnActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.equalTo(@(cell.frame.size.width-60));
        make.height.equalTo(@50);
    }];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
