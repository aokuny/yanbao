//
//  QuotePriceViewController.m
//  yanbao
//  选择车辆信息页面
//  Created by aokuny on 14/12/12.
//
//

#import "QuotePriceViewController.h"
#import "VNCodeViewController.h"
#import "QuotePriceDetailViewController.h"
#import "QuotePriceProductListViewController.h"
#import "ProgressView.h"
#import "ViewShaker.h"
#import "ProductList.h"
#import "ChannelNumberViewController.h"

static SystemSoundID shake_sound_id = 0;
@interface QuotePriceViewController (){
    NSArray *_arrayCelldData;
    UITableView *_tableView;
    NSIndexPath *_indexPath;
    ZHPickView *_pickview;
    // 页面是否为VN码认证
    BOOL _isVNCode;
    // 车辆品牌
    NSArray *_CarBrand;
    // 发动机类型
//    NSArray *_EngineType;
    // 车辆排量
    NSArray *_Displacement;
    // 变速箱类型
//    NSArray *_GearBox;
}
@end

@implementation QuotePriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:DEFAULT_TITLE];
    [self setBackBarButton];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
//    _isVNCode = _vnCode == nil ? NO : YES;
    [self initData];
    [self initTableView];
    [self vinDefaultData];
}
-(void)initTableView{
    _arrayCelldData = @[@{@"labText":@"车辆品牌：",@"placeHolder":@"请选择"},
//                        @{@"labText":@"发动机类型：",@"placeHolder":@"请选择"},
                        @{@"labText":@"发动机排量：",@"placeHolder":@"请选择"},
//                        @{@"labText":@"变速箱类型：",@"placeHolder":@"请选择"}
                        ];
    _tableView = [UITableView new];
    [_tableView setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
//    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    
    [self.view addSubview:_tableView];
//    UIView *bgHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,82)];
//    [bgHeaderView setBackgroundColor:[UIColor whiteColor]];
//    ProgressView *progessView = [[ProgressView alloc]initWithStatusCount:2 andDescriptionArray:@[@"参数选择",@"快速报价"] andCurrentStatus:1 andFrame:CGRectMake(0,0,ScreenWidth,80)];
    UIView *bgHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
//    [bgHeaderView setBackgroundColor:DEFAULT_BTNCOLOR];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayLineColor];
    lineView.frame = CGRectMake(0,CGRectGetMaxY(bgHeaderView.frame), self.view.frame.size.width,1);

//    //Tap Touch
    UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    _tapGesture.delegate = self;
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:_tapGesture];
    
//    [bgHeaderView addSubview:progessView];
    [bgHeaderView addSubview:lineView];

    _tableView.tableHeaderView = bgHeaderView;
    
}

-(void) pushToVNCode{
    VNCodeViewController *vncodeVC = [[VNCodeViewController alloc]init];
    [self.navigationController pushViewController:vncodeVC animated:YES];
}
-(void)initData{
    // 取服务端数据 --可能改为每天一次获取
    NSString *pathCartype = [self getFilePathByName:@"cartype"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:pathCartype];
    _CarBrand = array;
    
//    NSString *pathGearBox = [self getFilePathByName:@"gearbox"];
//    NSArray * arrayGearBox=[[NSArray alloc] initWithContentsOfFile:pathGearBox];
//    _GearBox = arrayGearBox;

//    _EngineType = @[@"涡轮增压",@"自然吸气"];
    
    NSString *pathDisplacement = [self getFilePathByName:@"displacement"];
    NSArray * arrayDisplacement=[[NSArray alloc] initWithContentsOfFile:pathDisplacement];
    _Displacement = arrayDisplacement;
}
-(void) vinDefaultData{
    if (self.carInfo != nil) {
        for (int i=0 ; i<4 ; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexpath];
            UITextField *txt = (UITextField *)[cell viewWithTag:i+10000];
//            if(i == 0){
//                if([_CarBrand containsObject:self.carInfo.brandName]){
//                    txt.text = self.carInfo.brandName;
//                }
//            }else if(i == 1){
//                if ([_EngineType containsObject:self.carInfo.vc2engineType]) {
//                    txt.text = self.carInfo.vc2engineType;
//                }
//            }else if(i == 2){
//                if ([_Displacement containsObject:self.carInfo.vc2engineOutput]) {
//                    txt.text = self.carInfo.vc2engineOutput;
//                }
//            }else if(i == 3){
//                if ([_GearBox containsObject:self.carInfo.vc2gearboxType]) {
//                    txt.text = self.carInfo.vc2gearboxType;
//                }
//            }
            if(i == 0){
                if([_CarBrand containsObject:self.carInfo.brandName]){
                    txt.text = self.carInfo.brandName;
                }
            }else if(i == 1){
                if ([_Displacement containsObject:self.carInfo.vc2engineOutput]) {
                    txt.text = self.carInfo.vc2engineOutput;
                }
            }
        }
    }
}
-(NSString *) getFilePathByName:(NSString *)filename{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",filename]];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    float tableRowHeight = 44;
    [_tableView setContentOffset:CGPointMake(0,(textField.tag-10000) * tableRowHeight) animated:YES];
    
    ZHPickView *pickView = (ZHPickView *)textField.inputView;
    NSString *selectedText = textField.text;
    if([selectedText length]>0){
        NSInteger row = 0;
        NSInteger txtTag = textField.tag - 10000;
//        if (txtTag == 0) {
//            row = [_CarBrand indexOfObject:selectedText];
//        }else if(txtTag == 1){
//            row = [_EngineType indexOfObject:selectedText];
//        }else if(txtTag == 2){
//            row = [_Displacement indexOfObject:selectedText];
//        }else if(txtTag == 3){
//            row = [_GearBox indexOfObject:selectedText];
//        }
        if (txtTag == 0) {
            row = [_CarBrand indexOfObject:selectedText];
        }else if(txtTag == 1){
            row = [_Displacement indexOfObject:selectedText];
        }
        [pickView setDefaultSelectedWithRowIndex:row];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    lineView.backgroundColor = [UIColor grayLineColor];
    
    UIView *bgFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,100)];
    [bgFooterView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    UIButton *btnQuotePrice = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnQuotePrice.layer.cornerRadius = 10;
    [btnQuotePrice setFrame:CGRectMake(30,40,ScreenWidth-60,44)];
    [btnQuotePrice setBackgroundColor:DEFAULT_BTNCOLOR];
    [btnQuotePrice setTitle:@"下一步" forState:UIControlStateNormal];
    [btnQuotePrice.titleLabel setFont:DEFAULT_BOLD_FONT(17)];
    [btnQuotePrice handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if(![self judgeChanelNumberLocal]){
            return;
        }
        NSMutableDictionary *paramters = [NSMutableDictionary new];
        for (int i=0 ; i<2 ; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexpath];
            UITextField *txt = (UITextField *)[cell viewWithTag:i+10000];
            if ([[txt text] length] == 0) {
                ViewShaker *shakerText = [[ViewShaker alloc]initWithView:txt];
                ViewShaker *shakerLab = [[ViewShaker alloc]initWithView:cell.textLabel];
                [shakerText shake];
                [shakerLab shake];
                [self playSound];
                return;
            }
//            switch (i) {
//                case 0:
//                    [paramters setObject:txt.text forKey:@"brandName"];
//                    break;
//                case 1:
//                    [paramters setObject:txt.text forKey:@"vc2engineType"];
//                    break;
//                case 2:
//                    [paramters setObject:txt.text forKey:@"vc2engineOutput"];
//                    break;
//                case 3:
//                    [paramters setObject:txt.text forKey:@"vc2gearboxType"];
//                    break;
//                default:
//                    break;
//            }
            if(i==0){
                [paramters setObject:txt.text forKey:@"brandName"];
            }else if (i==1){
                [paramters setObject:txt.text forKey:@"vc2engineOutput"];
            }
        }
        [paramters setObject:@"" forKey:@"vc2engineType"];
        [paramters setObject:@"" forKey:@"vc2gearboxType"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [paramters setObject:[userDefaults objectForKey:@"CHANNEL_NUMBER_CODE"] forKey:@"channelcode"];
        [self showHudInView:self.view hint:@"正在获取产品列表..."];
        __weak typeof(self) weakSelf = self;
        [Api invokeGet:YB_PRODUCTLIST_NEW parameters:paramters completion:^(id resultObj, RespHeadModel *head) {
            [weakSelf hideHud];
            if (resultObj) {
                NSError *err = nil;
                ProductList *productList = [[ProductList alloc]initWithDictionary:resultObj error:&err];
                if (err) {
                    [JGProgressHUD showErrorStr:@"暂无匹配的产品！"];
                    return ;
                }
                if ([productList.respBody count]>0) {
                    QuotePriceProductListViewController *qpProductListVC = [[QuotePriceProductListViewController alloc]init];
                    qpProductListVC.productList  = productList;
                    [self.navigationController pushViewController:qpProductListVC animated:YES];
                }else{
                    [JGProgressHUD showHintStr:@"暂无匹配的产品！"];
                }
            }
        }];
    }];
    [bgFooterView addSubview:lineView];
    [bgFooterView addSubview:btnQuotePrice];
//    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(btnQuotePrice.frame)+20,ScreenWidth,60)];
//    [bgFooterView addSubview:bottomView];
//    [self defaultBottomViewWithSuper:bottomView];
    return bgFooterView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 4;
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _arrayCelldData[indexPath.row][@"labText"];
        [cell.textLabel setFont:DEFAULT_FONT(15)];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        UITextField *textField = [[UITextField alloc]init];
        [textField setDelegate:self];
        [textField setTag:indexPath.row+10000];
        textField.placeholder = _arrayCelldData[indexPath.row][@"placeHolder"];
        [textField setTextAlignment:NSTextAlignmentLeft];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setTextColor:[UIColor grayColor]];
        [textField setFont:DEFAULT_FONT(15)];
        [cell addSubview:textField];
        NSArray *rowArray = [NSArray new];
//        if (indexPath.row == 0) {
//            rowArray = _CarBrand;
//        }else if(indexPath.row == 1){
//            rowArray = _EngineType;
//        }else if(indexPath.row == 2){
//            rowArray = _Displacement;
//        }else if(indexPath.row == 3){
//            rowArray = _GearBox;
//        }
        if (indexPath.row == 0) {
            rowArray = _CarBrand;
        }else if(indexPath.row == 1){
            rowArray = _Displacement;
        }
        _pickview=[[ZHPickView alloc] initPickviewWithArray:rowArray isHaveNavControler:NO];
        _pickview.delegate = self;
        [_pickview setTag:indexPath.row+10000];
        textField.inputView = _pickview;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.baseline.equalTo(cell.mas_baseline);
            make.top.equalTo(cell.mas_top);
            make.width.equalTo(@180);
            make.height.equalTo(@44);
            make.right.equalTo(cell.mas_right).offset(-24);
        }];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    _indexPath = [NSIndexPath indexPathForRow:pickView.tag-10000 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    UITextField *txt = (UITextField *)[cell viewWithTag:pickView.tag];
    [txt setText:resultString];
    [self.view endEditing:NO];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)cancelClick{
    [self.view endEditing:NO];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    // Dispose of any resources that can be recreated.
}
@end
