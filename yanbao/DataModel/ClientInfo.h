//
//  CLClientInfo.h
//  CheleNetClient
//
//  Created by aokuny on 14-9-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MemberInfo.h"

enum ImageQuality {HighDefinition =1,Common =2};

@interface ClientInfo : NSObject

@property (assign, nonatomic) BOOL isLogin;
@property(nonatomic, strong)NSString *guid;
@property(nonatomic, strong)NSString *token;
//@property(nonatomic, strong) MemberInfo *memberinfo;
@property (nonatomic, assign) BOOL isReachNetwork;

+ (instancetype)sharedClinetInfo;
+ (BOOL)isLogin;
+ (NSURL *) CL_urlForStoreName:(NSString *)storeFileName;
+ (NSURL *) CL_addStoreNamed:(NSString *) storeFileName;

-(void)saveLoginGuid:(NSString *)guid token:(NSString *)tokenStr;
-(void)loadGuidAndToken;
-(void)clearGuidAndToken;
-(void) clearAllUserInfo;
/*
 * 是否根据网络智能读取图片
 */
+(NSString *) isIntelligence;
-(void) saveIntelligence:(NSString *)intelligence;
+(enum ImageQuality)getImageQualityType;
-(void) saveImageQualityType:(enum ImageQuality) ImageQuality;

@end
