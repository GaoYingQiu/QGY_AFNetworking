//
//  LoginRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/6/30.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "LoginRequest.h"
#import "GYLoginManager.h"
#import <MJExtension.h>

@implementation LoginRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Login;
    }
    return self;
}

-(void)setRequestParams:(NSMutableDictionary *)params{
 
    [params setObject:self.account forKey:@"userName"];
    [params setObject:self.pwd  forKey:@"password"];
}

-(NSString *) getAPIRequestMethodName{
    return @"api/account/login";
}

-(void) parseResponse:(QGYBaseResponse *)response
{
    //根据业务请求，在此做 得到网络数据响应成功后的 业务逻辑处理，缓存处理；
    LoginData *currentLoginUser = [LoginData mj_objectWithKeyValues:response.dataDic];
    response.responseObject = currentLoginUser;
    if(currentLoginUser && currentLoginUser.token.length){
       
        [GYLoginManager shareInstance].currentLoginData =  currentLoginUser; //缓存用户登录信息；
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_LoginStateChange" object:@(YES)]; //发出登录成功的通知；
       
        if(currentLoginUser.repeatRemoteLogin){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_LoginInOtherPlace" object:nil]; //告知用户已经异地登录了；
        }
    }else{
        [GYLoginManager shareInstance].currentLoginData = nil;
    }
}
@end
