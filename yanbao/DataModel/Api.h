//
//  Api.h
//  yanbao
//
//  Created by aokuny on 14-10-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import <Foundation/Foundation.h>
#import "JGProgressHUD+Add.h"
#import "RespModel.h"
#import "AppUtil.h"
#import "Reachability.h"


//#define MACRO_PRODUCT 1
#ifdef                MACRO_PRODUCT
/*测试IP*/
#define BASE_URL   @"http://192.168.4.109:8188/ihandy_yanbao_app_server/"
#else
/*外网地址*/
//#define BASE_URL   @"http://www.chelenet.com:8082/ihandy_yanbao_app_server_channel"
#define BASE_URL   @"http://www.chelenet.com:8082/ihandy_yanbao_app_server_wapsite"
#endif

// 升级地址
//#define DOMAIN_URL @"https://www.chelenet.com"
// 渠道
#define CHANNEL_NUMBER @"21"
// 类型 2为ios
#define CHANNEL_GENRE @"2"
// 显示的版本号
#define CHANNEL_DISPLAYVERSION @"1.0.8"
// 默认标题
#define DEFAULT_TITLE @"车乐无忧"
// 服务电话
#define DEFAULT_PHONENUMBER @"400-920-1951"
// 默认按钮颜色 (黄色)
#define DEFAULT_BTNCOLOR RGBCOLOR(244,184,25)
// 默认字体颜色
#define DEFAULT_FONTCOLOR RGBCOLOR(0,51,102)
// 背景灰色
#define BACKGROUNDCOLOR_GRAY RGBCOLOR(237,237,243)
// 蓝色
#define DEFAULT_NAVBLUECOLOR RGBCOLOR(16,150,213)

// 应用ID 发布itunes时生成的ID
#define APPID @"414478124"

/*腾讯微博*/
#define TencentWeiboAppKey     @"1103074867"
#define TencentWeiboAppKeySecret  @"0mV0MmY64ZK9zZSV"
#define TencentWeiboREDIRECTURI             @"http://www.baidu.com"

/*QQ空间,QQ*/
#define QQHLSDKAppKey @"1103074867"
#define QQHLSDKAppSecret @"0mV0MmY64ZK9zZSV"

/*微信*/
#define WXSDKAppKey @"wxe084293a2b896acf"
#define WXSDKAppSecret @"d00ed4d36263aab4aed222d82a67bb28"

/*新浪微博*/
#define SINAWEIBOAppKey @"3749353156"
#define SINAWEIBOAppSecret @"c1730b2fefc30574f444a10e016d7d72"
#define SINAWEIBOREDIRECTURI @"http://www.sina.com"

/*接口*/

#define YB_BRANDLIST  @"interface/getbrandlist.do" /*品牌接口*/

#define YB_GEARBOX    @"interface/getgearboxlist.do" /*变速箱类型接口*/

#define YB_DISPLACEMENT  @"interface/getengineoutputlist.do" /*发动机排量接口*/

#define YB_PRODUCTLIST  @"interface/getprolist.do" /*产品列表*/

#define YB_ACTIVITYLIST   @"interface/getactivitylist.do" /*活动列表*/

#define YB_PRICE @"interface/getpreferentialpricelist.do" /*价格列表*/

#define YB_INFOBYVIN  @"interface/getinfobyvin.do" /*vin码获取汽车数据*/

#define YB_VERSION_INFO @"version/checkLatestVersion.do" /*版本更新*/

#define YB_CHANNEL_NUMBER @"interface/getchannelinfo.do" /*根据渠道码获取渠道编号*/


#define YB_PRODUCTLIST_NEW  @"interface/getNewProList.do" /*产品列表*/
#define YB_ACTIVITYLIST_NEW   @"interface/getNewActivityList.do" /*活动列表*/
#define YB_PRICE_NEW @"interface/getNewPreferentialPriceList.do" /*价格列表*/

#define YB_CHECKLIST @"interface/getquerylist.do" /*查询核保状态列表*/
#define YB_CHECKADD @"interface/queryunderwriting.do" /*增加查询核保信息*/
#define YB_CHECKDELETE @"interface/deleteuserquery.do" /*删除核保信息*/



// 测试环境
//#define YB_VERSION_INFO @"ihandy_yanbao_app_server/version/checkLatestVersion.do" /*版本更新*/



typedef void (^ObjectBlock)(id resultObj, RespHeadModel* head);

typedef void (^SyncObjectBlock)(id resultObj,NSString *error);

@interface Api : NSObject

+ (void )invokePost:(NSString *)URLString parameters:(id)parameters completion: (ObjectBlock)completeBlock;

+ (void )invokeGet:(NSString *)URLString parameters:(id)parameters completion: (ObjectBlock)completeBlock;

+ (void )invokeGetPage:(NSString *)URLString parameters:(id)parameters completion: (ObjectBlock)completeBlock;

+ (void )invokeGetSync:(NSString *)URLString parameters:(id)parameters completion: (SyncObjectBlock)completeBlock;

+ (instancetype)sharedInstance;

+ (BOOL) reachable;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end
