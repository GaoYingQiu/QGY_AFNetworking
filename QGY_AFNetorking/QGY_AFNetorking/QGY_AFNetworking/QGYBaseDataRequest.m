//
//  BaseDataService.m
//  qiugaoying
//
//  Created by qiugaoying on 15/9/8.
//  Copyright (c) 2015年 qiugaoying. All rights reserved.
//

#import "QGYBaseDataRequest.h"
#import "NSString+QGY.h"
#import "GYLoginManager.h"

@interface QGYBaseDataRequest()

@property (nonatomic,strong) NSMutableDictionary *requestParams;

@end

@implementation QGYBaseDataRequest

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认配置
        _requestType = RequestTypeGet;
        _requestParams = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - QGYAPIManager Delegate
//子类覆盖该方法设置需要的参数
-(void) setRequestParams:(NSMutableDictionary *)params
{

}

//请求的API方法名
-(NSString *) getAPIRequestMethodName{
    return @"";
}

//处理业务逻辑、缓存 等处理；
-(void) parseResponse:(QGYBaseResponse *)response
{

}

#pragma mark - private Methods

//返回请求参数；
-(NSDictionary *) acquireBaseRequestParamDictionary
{
 //    先排序，过滤掉nil 值，key=value&拼接， 最后加上appKey=？ 去加密   md5加密 得到sign 添加到 参数中
    [self setRequestParams:self.requestParams];
    
    return [self basicParamsAndMd5ProcessSignDic:self.requestParams];
}

-(NSString *)requestDomainUrl
{
    return  [NSString stringWithFormat:@"%@/%@",NetCoachDomain,[self getAPIRequestMethodName]];
}


//MD5加密sign
-(NSDictionary *)basicParamsAndMd5ProcessSignDic:(NSMutableDictionary *)dic{
    
    NSMutableDictionary  *    dictionnary      =   [NSMutableDictionary dictionary];
    dictionnary[@"version"]                    = App_version;
    dictionnary[@"appId"]                      = App_appId;
    dictionnary[@"clientType"]                 = App_clientType;
    dictionnary[@"bundlerId"]                  = App_BundlerId;
    
    NSString *uniqueStr = [NSString qgy_uniqueStringForMessage];
    dictionnary[@"requestId"]                   = [uniqueStr stringByReplacingOccurrencesOfString:@"-" withString:@""];//唯一识别编码
    NSString * token = [GYLoginManager shareInstance].currentLoginData.token?:@"";
    dictionnary[@"token"]                      =  token; //用户token
    dictionnary[@"userId"]                     = [GYLoginManager shareInstance].currentLoginData.userId;
    /*
     加入私有参数
     */
    [dictionnary addEntriesFromDictionary:dic];
    
    NSArray * keyArray = dictionnary.allKeys;
    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *sortKeyArr = [keyArray sortedArrayUsingComparator:sort];
    
    //拼接成字符串
    NSMutableArray *preSignStrArr = [[NSMutableArray alloc]init];
    for (NSString *keyStr in sortKeyArr) {
        
        id valueObj = [dictionnary objectForKey:keyStr];
        NSString *jsonStr = @"";
        if(![valueObj isKindOfClass:[NSString class]]){
            if([valueObj isKindOfClass:[NSNumber class]]){
                
                NSNumber *number = (NSNumber *)valueObj;
                jsonStr = number.stringValue ;
            }
        }else{
            jsonStr = valueObj;
        }
        
        if(jsonStr.length > 0){
             NSString *onePreSignStr = [NSString stringWithFormat:@"%@=%@",keyStr,jsonStr];
             [preSignStrArr addObject:onePreSignStr];
        }
    }
    
    NSString * preSignStr = [preSignStrArr componentsJoinedByString:@"&"];
    
    NSString *processStr = [preSignStr stringByAppendingString:[NSString stringWithFormat:@"&appKey=%@",App_appKey]];
    NSString  * md5String = processStr.qgy_MD5String;
    dictionnary[@"sign"] = md5String;
    
    NSLog(@"post请求参数：%@", dictionnary);
    return dictionnary;
}

+ (void) monitoringNetworkingStatus:(id<JJHttpNetworkStatus>) delegate
{
    
    //代理为空，直接返回
    if (!delegate) return;
    
    // 1.监控网络
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                [delegate didNetworkChanged:HttpUnkownNetWork];
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [delegate didNetworkChanged:HttpNoUseNetWork];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [delegate didNetworkChanged:HttpMobileNetWork];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [delegate didNetworkChanged:HttpWiFiNetWork];
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}

@end

 /*
 *  1、AF3.0开始 AFURLConnectionOperation,AFHTTPRequestOperation,AFHTTPRequestOperationManager 已废除。
 * AFHTTPSessionManager 去请求 将替代 AFHTTPRequestOperationManager 类似功能。
 * NSURLSessionTask 替代 AFHTTPRequestOperation
 *  2、由于Xcode 7中，NSURLConnection的API已经正式被苹果弃用，苹果增强关于NSURLSession提供的任何额外功能。
 *  3、AF3.0 支持的iOS 7， Mac OS X的10.9， watchOS 2 ， tvOS 9 和Xcode 7
 */
