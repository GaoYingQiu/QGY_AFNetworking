//
//  GYNetWorkError.h
//  qiugaoying
//
//  Created by qiugaoying on 15/9/8.
//  Copyright (c) 2015年 qiugaoying. All rights reserved.
//

#ifndef qiugaoying_QGYNetWorkError_h
#define qiugaoying_QGYNetWorkError_h

#define NetworkTimeoutInterval 10

#define CustomErrorDomain @""

typedef enum : NSInteger{
    
    CustomResCodeNotNetConnect =  0, //没有网络
    CustomResCode_NeedBindBankCard= 2, //需要绑定银行卡 2
    CustomResCode_NeedSetAccountPwd= 3, //需要设置资金密码
    CustomResCode_GameMaintenance= 4, //游戏维护中
    CustomResCodeSuccess = 200, //请求成功
    CustomResCodeThirdBind = 202, //需要绑定手机号
    CustomResCodeAccountExecption = -4001, //账号异常
    CustomResCodeAccountTokenExpire = 100, //token失效，需重新登录  1
    
}QGYCustomResCode;


#endif
