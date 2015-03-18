//
//  CLClientInfo.m
//  CheleNetClient
//
//  Created by aokuny on 14-9-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.
//

#import "ClientInfo.h"
#import "AppUtil.h"
NSString *const kGuid = @"guid";
NSString *const kToken = @"token";
NSString *const kIntelligence = @"Intelligence";
NSString *const kImageQuality = @"ImageQuality";

@implementation ClientInfo
+ (instancetype)sharedClinetInfo
{
    static ClientInfo* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(BOOL)isLogin {
    if ([ClientInfo sharedClinetInfo].guid &&[ClientInfo sharedClinetInfo].token ) {
        return YES;
    }
    return NO;
}

+ (NSString *) CL_directory:(int) type
{
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)CL_applicationDocumentsDirectory
{
	return [self CL_directory:NSDocumentDirectory];
}

+ (NSString *)CL_applicationStorageDirectory
{
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    return [[self CL_directory:NSApplicationSupportDirectory] stringByAppendingPathComponent:applicationName];
}

+ (NSURL *) CL_urlForStoreName:(NSString *)storeFileName
{
	NSArray *paths = [NSArray arrayWithObjects:[self CL_applicationDocumentsDirectory], [self CL_applicationStorageDirectory], nil];
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    for (NSString *path in paths)
    {
        NSString *filepath = [path stringByAppendingPathComponent:storeFileName];
        if ([fm fileExistsAtPath:filepath])
        {
            return [NSURL fileURLWithPath:filepath];
        }
    }
    
    //set default url
    return [NSURL fileURLWithPath:[[self CL_applicationStorageDirectory] stringByAppendingPathComponent:storeFileName]];
}

+ (void) CL_createPathToStoreFileIfNeccessary:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!pathWasCreated)
    {
    }
}

+ (NSURL *) CL_addStoreNamed:(NSString *) storeFileName
{
    NSURL *url = [ClientInfo CL_urlForStoreName:storeFileName];
    
    [ClientInfo CL_createPathToStoreFileIfNeccessary:url];
    
    return url;
}

-(id)init {
    self = [super init];
    if (self) {
        [self loadGuidAndToken];
    }
    return self;
}

-(void)saveLoginGuid:(NSString *)guid token:(NSString *)tokenStr {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:guid forKey:kGuid];
    [userDefaults setObject:tokenStr forKey:kToken];
    [userDefaults synchronize];
    [self loadGuidAndToken];
}

-(void)clearGuidAndToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kGuid];
    [userDefaults removeObjectForKey:kToken];
    [userDefaults synchronize];
    self.token = nil;
    self.guid = nil;
}
/**
 *  用户退出登录，清除所有用户信息。
 */
-(void) clearAllUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kGuid];
    [userDefaults removeObjectForKey:kToken];
    [userDefaults removeObjectForKey:kIntelligence];
    [userDefaults removeObjectForKey:kImageQuality];
    [userDefaults synchronize];
    self.token = nil;
    self.guid = nil;
//    self.memberinfo = nil;
}
-(void)loadGuidAndToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.guid = [userDefaults stringForKey:kGuid];
    self.token = [userDefaults stringForKey:kToken];
}

+(NSString *)isIntelligence{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey : kIntelligence];
}

-(void) saveIntelligence:(NSString *)intelligence{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:intelligence forKey:kIntelligence];
    [userDefaults synchronize];
}
+(enum ImageQuality) getImageQualityType{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults doubleForKey:kImageQuality];
}
-(void) saveImageQualityType:(enum ImageQuality) ImageQuality{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:ImageQuality forKey:kImageQuality];
}
@end
