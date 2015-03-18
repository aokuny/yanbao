//
//  VersionModel.h
//  yanbao
//  版本信息
//  Created by aokuny on 15/1/9.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import "JSONModel.h"
#import "RespModel.h"

@interface VersionModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*numclientGenre;
@property (nonatomic, strong) NSString <Optional>*vc2downloadUrl;
@property (nonatomic, strong) NSString <Optional>*vc2iosplistUrl;
@property (nonatomic, strong) NSString <Optional>*numappId;
@property (nonatomic, strong) NSString <Optional>*numversionCode;
@property (nonatomic, strong) NSString <Optional>*vc2versionName;
@property (nonatomic, strong) NSString <Optional>*datcreateDate;
@property (nonatomic, strong) NSString <Optional>*nummanualCode;
@property (nonatomic, strong) NSString <Optional>*vc2packageValue;
@property (nonatomic, strong) NSString <Optional>*vc2channelName;
@property (nonatomic, strong) NSString <Optional>*numchannelNumber;
@property (nonatomic, strong) NSString <Optional>*vc2downloadName;
@property (nonatomic, strong) NSString <Optional>*vc2versionDescription;
@end
