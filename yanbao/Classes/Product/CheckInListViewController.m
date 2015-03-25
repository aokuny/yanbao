//
//  CheckInListViewController.m
//  yanbao
//
//  Created by aokuny on 15/3/19.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import "CheckInListViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "CheckListTableViewCell.h"
#import "CheckInsuranceViewController.h"
#import "CheckInList.h"

@interface CheckInListViewController (){
    UITableView *_tableView;
    NSMutableArray *gDataArrays;
    int gTotalPage;
    int gCurrentPage;
}
@end

@implementation CheckInListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self rightButtion];
    [self setTitle:@"核保状态"];
    [self initData];
}
-(void)goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)rightButtion{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"新增查询" forState:UIControlStateNormal];
    button.titleLabel.font = DEFAULT_FONT(12);
    button.layer.cornerRadius = 10;
    [button setFrame:CGRectMake(0,0,60,23)];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitleColor:[UIColor colorWithWhite:1.000 alpha:1.000] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:0.953 green:0.948 blue:0.959 alpha:1.000] forState:UIControlStateHighlighted];
    button.imageView.contentMode = UIViewContentModeScaleToFill;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)rightBtnAction{
    CheckInsuranceViewController *checkVC = [CheckInsuranceViewController new];
    [self.navigationController pushViewController:checkVC animated:YES];
}
-(void)initData{
    gDataArrays = [NSMutableArray new];
    [self loadNewData];
    
//    for (int i=0;i<10;i++) {
//        CheckInModel *model1 = [CheckInModel new];
//        [model1 setVc2carnumber:@"京A90001"];
//        [model1 setVc2date:@"2015-03-20"];
//        [model1 setNumcheckid:@"11111"];
//        if (i%2) {
//            [model1 setVc2status:@"1"];
//        }else{
//            [model1 setVc2status:@"2"];
//        }
//        [model1 setVc2vin:@"aaaaaaabbbbbbbbbbbb"];
//        [model1 setVc2Resion:@"失败原因"];
//        [gDataArrays addObject:model1];
//    }
    
    gCurrentPage = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,
                                                              self.view.frame.size.height - kTopNavBarMargin)
                                             style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableFooterView:[UIView new]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setBackgroundView:nil];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf loadNewData];
    }];
    [_tableView addFooterWithCallback:^{
        [weakSelf loadMoreData];
    }];
    [self.view addSubview:_tableView];
}
-(void)loadNewData{
    gCurrentPage = 1;
    [gDataArrays removeAllObjects];
    [self loadServerData];
}
-(void)loadMoreData{
    ++gCurrentPage;
    if (gCurrentPage<=gTotalPage) {
        [self loadServerData];
    }else{
        --gCurrentPage;
        [JGProgressHUD showHintStr:@"暂无更多数据!"];
        [_tableView footerEndRefreshing];
    }
}
-(void)loadServerData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%d",gCurrentPage],  @"pageCurrent",
                                [userDefaults objectForKey:@"CHANNEL_NUMBER_CODE"],@"saleschannelUserNumMd5",
                                nil];
    __weak typeof(self) weakSelf = self;
    [Api invokeGetPage:YB_CHECKLIST parameters:requestDic completion:^(id resultObj,id pageObj) {
        [weakSelf hideHud];
        if (resultObj) {
            NSError *err = nil;
            if (err) {
                showAlertMessage(err.localizedDescription);
                return ;
            }
        }
        if (resultObj) {
            NSError *err = nil;
            CheckInList *checkInList;
            if([resultObj isKindOfClass:[NSArray class]]){
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:resultObj,@"rows",nil];
                checkInList = [[CheckInList alloc]initWithDictionary:dic error:&err];
            }else{
                checkInList = [[CheckInList alloc]initWithDictionary:resultObj error:&err];
            }
            if (err) {
                showAlertMessage(err.localizedDescription);
                return ;
            }
            gTotalPage = checkInList.total;
            if ([checkInList.rows count]>0) {
                [gDataArrays addObjectsFromArray:checkInList.rows];
                [_tableView reloadData];
            }
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

#pragma mark tableview datasource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [gDataArrays count];
}


#pragma mark - tableview delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Indentifier = @"cellInd";
    CheckListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Indentifier];
    CheckInModel *chkModel = (CheckInModel *)[gDataArrays objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[CheckListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Indentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellDataForModel:chkModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *paramters = [NSMutableDictionary new];
        CheckInModel *chkInModel = gDataArrays[indexPath.row];
        [paramters setObject:chkInModel.relationId forKey:@"relationId"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [paramters setObject:[userDefaults objectForKey:@"CHANNEL_NUMBER_CODE"] forKey:@"saleschannelUserNumMd5"];
        [self showHudInView:self.view hint:@"正在删除核保查询..."];
        __weak typeof(self) weakSelf = self;
        [Api invokeGet:YB_CHECKDELETE parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
            [weakSelf hideHud];
            if (![resultObj isEqual:[NSNull null]]) {
                [gDataArrays removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [JGProgressHUD showErrorStr:@"删除失败，请稍后再试！"];
            }
        }];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
