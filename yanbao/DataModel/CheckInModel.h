//
//  CheckInModel.h
//  yanbao
//
//  Created by aokuny on 15/3/20.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import "JSONModel.h"

@protocol CheckInModel
@end

@interface CheckInModel : JSONModel
//@property (nonatomic, strong) NSString <Optional>*numcheckid;
//@property (nonatomic, strong) NSString <Optional>*vc2carnumber;
//@property (nonatomic, strong) NSString <Optional>*vc2vin;
//@property (nonatomic, strong) NSString <Optional>*vc2date;
//@property (nonatomic, strong) NSString <Optional>*vc2status;
//@property (nonatomic, strong) NSString <Optional>*vc2Resion;
@property (nonatomic, strong) NSString <Optional>*carNo;
@property (nonatomic, strong) NSString <Optional>*result;
@property (nonatomic, strong) NSString <Optional>*queryTime;
@property (nonatomic, strong) NSString <Optional>*vin;
@property (nonatomic, strong) NSString <Optional>*remarks;
@property (nonatomic, strong) NSString <Optional>*relationId;

@end
