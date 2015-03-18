//
//  CLApi.m
//  CheleNetClinet
//
//  Created by aokuny on 14-10-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "Api.h"

@interface Api () <UIAlertViewDelegate>

@end

@implementation Api
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
        [requestSerializer setTimeoutInterval:60];
        [manager setRequestSerializer:requestSerializer];
//        [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
//        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
        self.manager = manager;
    }
    return self;
}

+ (void )invokePost:(NSString *)URLString parameters:(id)parameters completion: (ObjectBlock)completeBlock {
    
    AFHTTPRequestOperationManager *manager  = [Api sharedInstance].manager;
    NSLog(@"请求接口：%@\n参数：%@",[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString], parameters);
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"后台响应包：%@",operation.responseString);
        
        completeBlock(responseObject[@"respBody"],responseObject[@"page"]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        completeBlock(nil,nil);
        showAlertMessage(error.localizedDescription);
    }];
}

+ (void )invokeGet:(NSString *)URLString parameters:(id)parameters completion: (ObjectBlock)completeBlock {
    AFHTTPRequestOperationManager *manager  = [Api sharedInstance].manager;
    NSLog(@"请求接口：%@\n参数：%@",[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString], parameters);
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"后台响应包：%@",operation.responseString);
        completeBlock(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        completeBlock(nil,nil);
//        showAlertMessage(error.localizedDescription);
        if ([error.localizedDescription respondsToSelector:@selector(containsString:)]) {
            if([error.localizedDescription containsString:@"Could not connect"]){
                showAlertMessage(@"网络连接错误，无法连接到服务端！");
            }
        }else{
            showAlertMessage(@"网络连接错误，无法连接到服务端！");
        }
    }];
}

+ (void )invokeGetSync:(NSString *)URLString parameters:(id)parameters completion: (SyncObjectBlock)completeBlock {
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",BASE_URL,URLString];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:requestURL parameters:parameters error:nil];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    if (requestOperation.responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:requestOperation.responseObject options:0 error:nil];
        completeBlock(json,nil);
    }else{
        completeBlock(nil,@"网络连接错误!");
    }
}

+ (void )invokeGetPage:(NSString *)URLString parameters:(id)parameters completion: (ObjectBlock)completeBlock {
    AFHTTPRequestOperationManager *manager  = [Api sharedInstance].manager;
    NSLog(@"请求接口：%@\n参数：%@",[[NSURL URLWithString:URLString relativeToURL:manager.baseURL] absoluteString], parameters);
    
     if (!manager.reachabilityManager.reachable) {
         NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"网络连接异常！", nil)};
         NSError *error = [NSError errorWithDomain:@"com.app" code:111 userInfo:userInfo];
         completeBlock(nil,nil);
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 showAlertMessage(error.localizedDescription);
             });
         });
         return;
     }
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"后台响应包：%@",operation.responseString);
        completeBlock(responseObject[@"respBody"],responseObject[@"page"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        completeBlock(nil,nil);
        //showAlertMessage(error.localizedDescription);
        showAlertMessage(@"服务端连接异常！");
    }];
}


+ (BOOL)reachable
{
    NetworkStatus wifi = [[Reachability reachabilityForLocalWiFi]currentReachabilityStatus];
    //判断wifi是否可用
    NetworkStatus gprs = [[Reachability reachabilityForInternetConnection]currentReachabilityStatus];
    //判断gprs是否可用
    if(wifi==NotReachable&&gprs==NotReachable)
    {
        return NO;
    }
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
    }
}
@end
