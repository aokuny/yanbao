//
//  CheckListTableViewCell.m
//  yanbao
//
//  Created by aokuny on 15/3/20.
//  Copyright (c) 2015年 ihandy. All rights reserved.

#import "CheckListTableViewCell.h"
#import "AppUtil.h"
#import "CheckInModel.h"

@implementation CheckListTableViewCell{
    UILabel *_LabCarNumber;
    UILabel *_LabCarNumberDesc;
    
    UILabel *_LabDateDime;
    
    UILabel *_LabVin;
    UILabel *_LabVinDesc;
    
    UIButton *_BtnStatus;
    UILabel *_LabStatusDesc;
    
    UIView *bgView;
    CheckInModel *gCheckInModel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
        bgView = [UIView new];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        _LabCarNumberDesc = [[UILabel alloc]init];
        [_LabCarNumberDesc setNumberOfLines:0];
        [_LabCarNumberDesc setLineBreakMode:NSLineBreakByTruncatingTail];
        [_LabCarNumberDesc setFont:DEFAULT_FONT(13)];
        [_LabCarNumberDesc setText:@"车牌号码："];
        
        _LabCarNumber = [[UILabel alloc]initWithFrame:CGRectZero];
        [_LabCarNumber setFont:DEFAULT_FONT(13)];
        [_LabCarNumber setNumberOfLines:0];
        [_LabCarNumber setLineBreakMode:NSLineBreakByTruncatingTail];
        
        _LabVinDesc = [[UILabel alloc]init];
        [_LabVinDesc setText:@"VIN码："];
        [_LabVinDesc setFont:DEFAULT_FONT(13)];
        [_LabVinDesc setLineBreakMode:NSLineBreakByTruncatingTail];
        
        _LabVin = [[UILabel alloc]initWithFrame:CGRectZero];
        [_LabVin setFont:DEFAULT_FONT(13)];
        [_LabVin setNumberOfLines:0];
        [_LabVin setLineBreakMode:NSLineBreakByTruncatingTail];
        
        _LabDateDime = [[UILabel alloc]initWithFrame:CGRectZero];
        [_LabDateDime setFont:DEFAULT_FONT(11)];
        _LabDateDime.textColor = RGBCOLOR(148,148,148);
        
        _LabStatusDesc  = [[UILabel alloc]init];
        [_LabStatusDesc setText:@"核保状态："];
        [_LabStatusDesc setFont:DEFAULT_FONT(13)];
        
        _BtnStatus = [[UIButton alloc]initWithFrame:CGRectZero];
        [_BtnStatus.titleLabel setFont:DEFAULT_FONT(13)];
        
        [bgView addSubview:_LabCarNumberDesc];
        [bgView addSubview:_LabCarNumber];
        [bgView addSubview:_LabVinDesc];
        [bgView addSubview:_LabVin];
        [bgView addSubview:_LabDateDime];
        [bgView addSubview:_LabStatusDesc];
        [bgView addSubview:_BtnStatus];
        [self.contentView addSubview:bgView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    float fullwidth = self.contentView.frame.size.width;
    float margin = 10 ;
    [bgView setFrame:CGRectMake(0,0,fullwidth,99)];
    _LabCarNumber.text = gCheckInModel.carNo;
    _LabVin.text = gCheckInModel.vin;
    _LabDateDime.text = gCheckInModel.queryTime;
    _BtnStatus.titleLabel.text = gCheckInModel.result;
    
    [_LabCarNumberDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(margin);
        make.left.equalTo(bgView.mas_left).offset(margin);
        make.width.equalTo(@80);
        make.height.equalTo(@15);
    }];
    [_LabCarNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(_LabCarNumberDesc.mas_baseline);
        make.left.equalTo(_LabCarNumberDesc.mas_right);
        make.right.equalTo(_LabDateDime.mas_left);
    }];
    [_LabDateDime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(_LabCarNumberDesc.mas_baseline);
        make.left.equalTo(_LabCarNumber.mas_right);
        make.right.equalTo(bgView.mas_right);
        make.width.equalTo(@80);
    }];
    
    [_LabVinDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LabCarNumberDesc.mas_bottom).offset(margin);
        make.left.equalTo(_LabCarNumberDesc.mas_left);
        make.right.equalTo(_LabVin.mas_left);
        make.width.equalTo(@80);
    }];
    [_LabVin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(_LabVinDesc.mas_baseline);
        make.left.equalTo(_LabVinDesc.mas_right);
        make.right.equalTo(bgView.mas_right);
    }];
    
    [_LabStatusDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LabVinDesc.mas_bottom).offset(margin);
        make.left.equalTo(_LabVinDesc.mas_left);
        make.width.equalTo(@80);
    }];
    [_BtnStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_LabStatusDesc.mas_right);
        make.baseline.equalTo(_LabStatusDesc.mas_baseline);
        make.width.equalTo(@120);
    }];
}

-(void) setCellDataForModel:(CheckInModel *)chkModel{
    gCheckInModel = chkModel;
    /*核保结果，0核保中、1核保成功、2核保失败*/
    if ([gCheckInModel.result isEqualToString: @"0"]) {
        [_BtnStatus setTitle:@"核保中" forState:UIControlStateNormal];
        [_BtnStatus setBackgroundColor:DEFAULT_BTNCOLOR];
    }else if([gCheckInModel.result isEqualToString: @"1"]){
        [_BtnStatus setTitle:@"核保成功" forState:UIControlStateNormal];
        [_BtnStatus setBackgroundColor:DEFAULT_NAVBLUECOLOR];
    }else{
        [_BtnStatus setTitle:@"核保失败" forState:UIControlStateNormal];
        [_BtnStatus setBackgroundColor:[UIColor redColor]];
        [_BtnStatus addTarget:self action:@selector(showErrorMsg) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void) showErrorMsg{
    if (gCheckInModel.remarks) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败原因" message:gCheckInModel.remarks delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
    }
}

- (void)awakeFromNib {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
