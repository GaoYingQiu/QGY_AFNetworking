//
//  HttpRequestAPICode.h
//  SmartCommunity
//
//  Created by jojo on 16/9/20.
//  Copyright © 2016年 huamai. All rights reserved.
//

#ifndef QGYHttpRequestAPICode_h
#define QGYHttpRequestAPICode_h

typedef enum{
    
    /********以下是xx平台接口***********/

    Http_Login = 1000, //登录
    Http_ChatSessionList = 1001 , //聊天记录接口
    Http_ChatSessionListDelete = 1002 //删除某条消息记录；
 
}QGYRequestAPICode;
#endif /* HttpRequestAPICode_h */
