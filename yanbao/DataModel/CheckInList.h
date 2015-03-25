//
//  CheckInList.h
//  yanbao
//
//  Created by aokuny on 15/3/24.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import "JSONModel.h"
#import "CheckInModel.h"
@interface CheckInList : JSONModel
@property (nonatomic, assign) double pageSize;
//@property (nonatomic, assign) double endProperty;
@property (nonatomic, assign) double begin;
@property (nonatomic, assign) double length;
@property (nonatomic, assign) double current;
@property (nonatomic, assign) double count;
@property (nonatomic, assign) double pageNo;
@property (nonatomic, strong) NSArray<CheckInModel> *rows;
@property (nonatomic, assign) double total;
@end
