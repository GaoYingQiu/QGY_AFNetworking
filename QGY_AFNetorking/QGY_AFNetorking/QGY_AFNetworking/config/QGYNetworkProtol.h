//
//  GYNetworkProtol.h
//  Qiu2017
//
//  Created by qiugaoying on 2018/6/30.
//  Copyright © 2018年 zy. All rights reserved.
//

#ifndef QGYNetworkProtol_h
#define QGYNetworkProtol_h

@class QGYBaseResponse;
@class QGYBaseDataRequest;


//在ViewController实现的请求协议返回的结果协议
@protocol QGYDataRequestDelegate <NSObject>

@optional

-(void) onRequestSuccess:(QGYBaseResponse *)response;
-(void) onRequestStatusError:(QGYBaseResponse *)response;
-(void) onRequestError:(NSError *)error request:(QGYBaseDataRequest *)request;//由于网络或其他原因导致请求失败，需把请求带回

@end


#endif /* GYNetworkProtol_h */
