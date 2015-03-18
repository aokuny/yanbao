//
//  CLResModel.h
//  CheleNetClinet
//
//  Created by aokuny on 14-10-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "JSONModel.h"

@interface RespHeadModel : JSONModel
@property (nonatomic, strong) NSString *respCode;
@property (nonatomic, strong) NSString *respShow;
@property (nonatomic, strong) NSString *respDebug;
@end

@interface RespModel : JSONModel
@property (nonatomic,strong) RespHeadModel* respHead;
@property (nonatomic,strong) NSDictionary *respBody;
@end
