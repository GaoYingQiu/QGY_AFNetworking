//
//  QGYAPIManager.h
//  QGY_AFNetorking
//
//  Created by qiugaoying on 2019/1/26.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#ifndef QGYAPIManager_h
#define QGYAPIManager_h

@class QGYBaseResponse;

//通过IOP的方式来限制派生类的重载
@protocol QGYAPIManager <NSObject>
/**
 *  获取请求api的具体接口方法名
 */
@required
-(NSString *)getAPIRequestMethodName;
/**
 *  设置请求参数
 */
@required
-(void) setRequestParams:(NSMutableDictionary *)params;
/**
 *  解析返回的字典
 *  @param response
 */
@required
-(void) parseResponse:(QGYBaseResponse *)response;

@end

#endif /* QGYAPIManager_h */
