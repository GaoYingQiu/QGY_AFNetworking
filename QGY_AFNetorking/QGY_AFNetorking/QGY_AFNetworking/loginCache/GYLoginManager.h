//
//  GYLoginManager.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/26.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LastLoginInfoResp;
@class LoginData;

//当前登录用户信息
@interface GYLoginManager : NSObject

+(instancetype)shareInstance;

@property (nonatomic,strong)    LoginData   *currentLoginData;
@property (nonatomic , assign) NSInteger badgeCount;

//用户是否登录
-(BOOL)isLogin;
@end

@interface LoginData :NSObject
@property(nonatomic, copy) NSString *token; //登录token
@property(nonatomic, copy) NSString *userId; //用户id
@property(nonatomic, copy) NSString *headImg; //真实头像
@property(nonatomic, copy) NSString *userName;  //账号
@property(nonatomic, copy) NSString *realname;  //真实姓名
@property(nonatomic, copy) NSString *userRole; //用户身份
@property(nonatomic, copy) NSString *phone; //联系电话
@property(nonatomic, copy) NSString *userNote; //个性标签
@property(nonatomic, copy) NSString *userMoney; //费用
@property(nonatomic, copy) NSString *fieldWay; //场租
@property(nonatomic, copy) NSString *follow; //关注人数
@property(nonatomic, copy) NSString *userMark; //个人简介
@property(nonatomic, copy) NSString *mapXy; //定位
@property(nonatomic, copy) NSString *province; //省
@property(nonatomic, copy) NSString *city; //市
@property(nonatomic, copy) NSString *area; //区
@property(nonatomic, copy) NSString *weixinId; //微信
@property(nonatomic, copy) NSString *qqId; //qq
@property(nonatomic, copy) NSString *idCardImg; //身份证
@property(nonatomic, assign) NSInteger remoteLogin;  //异地登录
@property(nonatomic, assign) NSInteger repeatRemoteLogin; //如果为true ，则需要告知用户异地登录了；
@property(nonatomic, strong) LastLoginInfoResp  *lastLoginInfoResp; //最后登录信息
@end

@interface LastLoginInfoResp :NSObject
@property(nonatomic,copy)  NSString *lastLoginAddress;
@property(nonatomic,copy)  NSString *lastLoginDate;
@property(nonatomic,copy)  NSString *lastLoginIp;
@end
