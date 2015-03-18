//
//  QuotePriceDetailViewController.m
//  yanbao
//
//  Created by aokuny on 14/12/16.
//
//

#import "QuotePriceDetailViewController.h"
#import "CATextLayer+NumberJump.h"
#import "ProgressView.h"

@interface QuotePriceDetailViewController (){
    // 最高优惠价格
    CATextLayer *textLayer;
    float _orginalPrice;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation QuotePriceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:DEFAULT_TITLE];
    [self initTableView];
    [self loadServerData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     _orginalPrice = 0;
    for (PriceModel *priceModel in _dataArray) {
        if(priceModel.proPrice != nil && priceModel.price != nil){
            float reduceValue = [priceModel.proPrice floatValue]-[priceModel.price floatValue];
            if (_orginalPrice < reduceValue) {
                _orginalPrice = reduceValue;
            }
        }
    }
    [textLayer jumpNumberWithDuration:1 fromNumber:0  toNumber: _orginalPrice];
}
-(void)initTableView{
    _tableView = [UITableView new];
    [_tableView setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
    [_tableView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [self.view addSubview:_tableView];
    UIView *bgHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,121)];
    [bgHeaderView setBackgroundColor:RGBCOLOR(238,238,238)];
    ProgressView *progessView = [[ProgressView alloc]initWithStatusCount:3 andDescriptionArray:@[@"参数选择",@"快速报价",@"活动查询"] andCurrentStatus:3 andFrame:CGRectMake(0,0,ScreenWidth,80)];
    
    UIView * lineTopView = [[UIView alloc] init];
    lineTopView.backgroundColor = [UIColor grayLineColor];
    lineTopView.frame = CGRectMake(0,CGRectGetMaxY(progessView.frame)+1, self.view.frame.size.width,1);
    
    UILabel *labProductName = [UILabel new];
    [labProductName setFont:DEFAULT_BOLD_FONT(17)];
    [labProductName setTextColor:DEFAULT_NAVBLUECOLOR];
    [labProductName setTextAlignment:NSTextAlignmentLeft];
    [labProductName setText:@"产品名称"];
    
    UILabel *labOriginalPrice = [UILabel new];
    [labOriginalPrice setFont:DEFAULT_BOLD_FONT(17)];
    [labOriginalPrice setTextColor:DEFAULT_NAVBLUECOLOR];
    [labOriginalPrice setTextAlignment:NSTextAlignmentCenter];
    [labOriginalPrice setText:@"原价"];
    
    UILabel *labProductValue = [UILabel new];
    [labProductValue setFont:DEFAULT_BOLD_FONT(17)];
    [labProductValue setTextColor:DEFAULT_NAVBLUECOLOR];
    [labProductValue setTextAlignment:NSTextAlignmentCenter];
    [labProductValue setText:@"活动价"];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayLineColor];
    lineView.frame = CGRectMake(0,CGRectGetMaxY(labProductValue.frame)+1, self.view.frame.size.width,1);
    
// debug
//    [bgHeaderView setBackgroundColor:[UIColor greenColor]];
//    [labOriginalPrice setBackgroundColor:[UIColor redColor]];
    
    [bgHeaderView addSubview:progessView];
    [bgHeaderView addSubview:lineTopView];
    [bgHeaderView addSubview:labProductName];
    [bgHeaderView addSubview:labOriginalPrice];
    [bgHeaderView addSubview:labProductValue];
    [bgHeaderView addSubview:lineView];
    _tableView.tableHeaderView = bgHeaderView;
    
    [labProductName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
        make.top.equalTo(progessView.mas_bottom).offset(2);
    }];
    
    [labProductValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progessView.mas_right);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
        make.top.equalTo(progessView.mas_bottom).offset(2);
    }];
    [labOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labProductValue.mas_left);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
        make.top.equalTo(progessView.mas_bottom).offset(2);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labOriginalPrice.mas_bottom);
        make.top.equalTo(bgHeaderView.mas_bottom);
        make.height.equalTo(@1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
}
-(void)loadServerData {
//    _dataArray = [NSMutableArray arrayWithArray:@[@{@"productname":@"1年或3万公里",
//                                                    @"originalprice":@"1445.00",
//                                                    @"productvalue":@"1160.00"},
//                                                  @{@"productname":@"2年或6万公里",
//                                                    @"originalprice":@"2630.00",
//                                                    @"productvalue":@"2321.00"},
//                                                  @{@"productname":@"至6年或16万公里",
//                                                    @"originalprice":@"3233.00",
//                                                    @"productvalue":@"2901.00"},
//                                                  @{@"productname":@"至8年或20万公里",
//                                                    @"originalprice":@"3654.00",
//                                                    @"productvalue":@"3191.00"}
//                                                  ]];
    _dataArray = [NSMutableArray arrayWithArray:self.priceList.respBody];
    [_tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    lineView.backgroundColor = [UIColor grayLineColor];
    
    UIView *bgFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,100)];
    [bgFooterView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    UILabel *labPreferential = [[UILabel alloc]initWithFrame:CGRectMake(30,20,120,30)];
    [labPreferential setText:@"为您最高节省"];
    [labPreferential setFont:DEFAULT_BOLD_FONT(17)];
    [labPreferential setTextColor:RGBCOLOR(244,184,25)];
    [bgFooterView addSubview:labPreferential];
    
    textLayer = [[CATextLayer alloc]init];
    textLayer.string = @"0";
    textLayer.frame = CGRectMake(CGRectGetMaxX(labPreferential.frame),labPreferential.frame.origin.y,120,30);
    textLayer.fontSize = 25;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = 2;
    textLayer.foregroundColor = [RGBCOLOR(244,184,25) CGColor];
    [bgFooterView.layer addSublayer:textLayer];
    
    UILabel *labPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textLayer.frame),
                                                                textLayer.frame.origin.y,30,30)];
    [labPrice setText:@"元"];
    [labPrice setTextColor:RGBCOLOR(244,184,25)];
    [labPrice setFont:DEFAULT_BOLD_FONT(25)];
    [bgFooterView addSubview:labPrice];
    [bgFooterView addSubview:lineView];
//    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(labPreferential.frame)+20,ScreenWidth,60)];
//    [bgFooterView addSubview:bottomView];
//    [self defaultBottomViewWithSuper:bottomView];
    return bgFooterView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifer =[NSString stringWithFormat:@"cellprice%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PriceModel *priceModel = _dataArray[indexPath.row];
        
        UILabel *labProductName = [UILabel new];
        [labProductName setFont:DEFAULT_FONT(13)];
        [labProductName setTextColor:[UIColor blackColor]];
        [labProductName setTextAlignment:NSTextAlignmentLeft];
        [labProductName setText:priceModel.vc2proName];
        
        UILabel *labOriginalPrice = [UILabel new];
        [labOriginalPrice setFont:DEFAULT_FONT(15)];
        [labOriginalPrice setTextColor:[UIColor blackColor]];
        [labOriginalPrice setTextAlignment:NSTextAlignmentLeft];
        [labOriginalPrice setText:[NSString stringWithFormat:@"%@",priceModel.proPrice]];
        
        UILabel *labProductValue = [UILabel new];
        [labProductValue setFont:DEFAULT_FONT(15)];
        [labProductValue setTextColor:DEFAULT_NAVBLUECOLOR];
        [labProductValue setTextAlignment:NSTextAlignmentLeft];
        [labProductValue setText:[NSString stringWithFormat:@"%@",priceModel.price]];
        
        [cell addSubview:labProductName];
        [cell addSubview:labOriginalPrice];
        [cell addSubview:labProductValue];
        
        [labProductName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.width.equalTo(@150);
            make.left.equalTo(cell.mas_left).offset(15);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        [labOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@80);
            make.left.equalTo(labProductName.mas_right);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        [labProductValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@80);
            make.left.equalTo(labOriginalPrice.mas_right);
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
