//
//  ActivityList.h
//  yanbao
//
//  Created by aokuny on 14/12/25.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "JSONModel.h"

@protocol ActivityModel
@end

@interface ActivityModel:JSONModel
// 活动ID
@property (nonatomic,strong) NSString <Optional>*numactivityId;
// 商品ID
@property (nonatomic,strong) NSString <Optional>*vc2proId;
// 活动名称
@property (nonatomic,strong) NSString <Optional>*vc2activityName;
@end

@interface ActivityList : JSONModel
@property (nonatomic,strong) NSArray<ActivityModel> *respBody;
@end
