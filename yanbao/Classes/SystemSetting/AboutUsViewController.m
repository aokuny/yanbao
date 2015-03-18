//
//  AboutUsViewController.m
//  yanbao
//  关于我们
//  Created by aokuny on 14/12/11.

#import "AboutUsViewController.h"

@interface AboutUsViewController (){
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButton];
    [self setTitle:@"关于车乐无忧"];
    [self.view setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    
    UILabel *labTitle = [UILabel new];
    [labTitle setFont:DEFAULT_BOLD_FONT(15)];
    [labTitle setTextColor:DEFAULT_NAVBLUECOLOR];
    [labTitle setText:@"车乐延保会员可享有打折服务优惠"];
    [labTitle setTextAlignment:NSTextAlignmentLeft];
    [labTitle setBackgroundColor:[UIColor clearColor]];
    [labTitle setNumberOfLines:0];
    [self.view addSubview:labTitle];
    
    UIImageView *imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus"]];
    [self.view addSubview:imgview];
    
    UITextView *textView = [UITextView new];
//    textView.userInteractionEnabled = NO;
    [textView setEditable:NO];
    [textView setBackgroundColor:BACKGROUNDCOLOR_GRAY];
    [textView setTextColor:RGBCOLOR(102,102,102)];
    [textView setText:@"车乐无忧网是国内首家针对汽车延保服务的电子商务平台。对大多数车主来说，目前在国内要找到合适的汽车延长保修服务并不容易，在4S店服务规范，环境舒适，但价格过高；而路边小店虽然便宜，可是材料真假、服务质量难以让人放心。\n\n车乐延保与4S店延保享有同等的产品配件、服务标准，并且相应价格均比4S店更便宜。另外，车乐延保会员可享有签约维修店的维修打折服务和其他优惠等。新车旧车均可购买，厂保期后也可购买，且多次、重复购买，不受限制。作为国内首家线上售卖汽车延保的网站，我们在各个环节都经过了严密的数据加密，确保用户信息安全。同时，车乐无忧网有人保公司承保及专业的汽修商鉴定服务，并且配有专业的客服系统24小时处理客户投诉，出现问题一个电话即可就近安排解决。"];
    [textView setFont:DEFAULT_BOLD_FONT(13)];
    [self.view addSubview:textView];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.height.equalTo(@25);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(5);
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.height.equalTo(@120);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgview.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
