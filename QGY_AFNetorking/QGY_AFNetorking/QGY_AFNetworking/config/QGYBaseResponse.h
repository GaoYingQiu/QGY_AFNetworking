//
//  BaseResponse.h
//  qiugaoying
//
//  Created by qiugaoying on 19/1/26.
//  Copyright (c) 2015年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGYNetWorkError.h"

@interface QGYBaseResponse : NSObject

@property (nonatomic, strong) NSDictionary *dataDic;    //response 对象
@property (nonatomic, assign) BOOL result;              //true or false
@property (nonatomic, assign) QGYCustomResCode recode;  //结果码
@property (nonatomic, strong) NSString *remsg;          //结果消息
@property (nonatomic, assign) NSInteger requestAPICode; //接口编码
@property (nonatomic, strong) id responseObject;        //解析成model后的返回对象

@property (nonatomic, strong) id requestObject;         //请求时候所带的对象

- (instancetype)initWithData:(NSDictionary *)dic;

@end

