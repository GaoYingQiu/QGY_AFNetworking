//
//  BaseDataService.h
//
//  Created by qiugaoying on 15/9/8.
//  Copyright (c) 2015年 LJK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//qgy
#import "QGYBaseResponse.h"
#import "QGYNetWorkError.h"
#import "QGYHttpRequestAPICode.h"
#import "QGYNetworkProtol.h"
#import "QGYAPIManager.h"

#define App_version      @"1.0.0.0"
#define App_Number       @1000
#define App_clientType   @3
#define App_BundlerId   @"com.qiu.testDemo"

#define NetCoachDomain   @"http://jiaolian.api.net:48091"
#define App_appId       @"b39b15b82096b034"
#define App_appKey      @"81d1c8e2fdc48e19"

typedef enum {
    HttpWiFiNetWork,
    HttpMobileNetWork,
    HttpNoUseNetWork,
    HttpUnkownNetWork
}HttpNetWorkStatusType;

typedef enum:NSUInteger
{
    RequestTypeGet,
    RequestTypePost,
    RequestTypePostMultipart,
}RequestType;


@protocol JJHttpNetworkStatus <NSObject>

@required
- (void)didNetworkChanged:(HttpNetWorkStatusType) type;
@end


@interface QGYBaseDataRequest : NSObject<QGYAPIManager>

@property (nonatomic,weak) id<QGYDataRequestDelegate> delegate; //请求回调方法
@property (nonatomic,assign) RequestType requestType; //请求类型
@property (nonatomic,assign) QGYRequestAPICode requestApiCode; //请求API
@property (nonatomic,strong) id requestObject; //请求所带的对象(回调后需使用或更改对象时候赋值；)

#pragma mark - APIManager Delegate
//子类覆盖该方法设置需要的参数
-(void) setRequestParams:(NSMutableDictionary *)params;
//请求的API方法名
-(NSString *) getAPIRequestMethodName;

//解析数据
-(void) parseResponse:(QGYBaseResponse *)response;

//提供给NetManager 获取参数
@property (nonatomic,strong,readonly) NSString *requestDomainUrl; //请求url

//获取请求参数
-(NSDictionary *) acquireBaseRequestParamDictionary;

/**
 *监视网络状态
 */
//+ (void) monitoringNetworkingStatus:(id<JJHttpNetworkStatus>) delegate;

@end
