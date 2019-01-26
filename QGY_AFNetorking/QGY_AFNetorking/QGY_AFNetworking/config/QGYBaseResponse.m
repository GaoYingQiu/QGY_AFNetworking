//
//  BaseResponse.m
//  qiugaoying
//
//  Created by qiugaoying on 19/1/26.
//  Copyright (c) 2015年 qiugaoying. All rights reserved.
//

#import "QGYBaseResponse.h"

@implementation QGYBaseResponse

- (instancetype)initWithData:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
    
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            
            id resultCode = [dic objectForKey:@"result"];
            if (resultCode && [resultCode isKindOfClass:[NSNumber class]]) {
                self.result = [resultCode boolValue];
            }
         
            id operateCode = [dic objectForKey:@"operateCode"];
            if (operateCode && [operateCode isKindOfClass:[NSNumber class]]) {
                self.recode = [operateCode integerValue];
            }
            
            id resultMsg = [dic objectForKey:@"msg"];
            if (resultMsg && [resultMsg isKindOfClass:[NSString class]]) {
                self.remsg = resultMsg;
            }
            
            id responseData = [dic objectForKey:@"data"];
            self.responseObject = responseData;
            if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
                self.dataDic = responseData;
            }
        }
    }
    return self;
}

//        {
//            data = "<null>";
//            msg = "\U670d\U52a1\U5668\U5fd9\Uff0c\U8bf7\U7a0d\U540e\U91cd\U8bd5";
//            operateCode = 0;
//            result = 0;
//        }
@end
