//
//  NIMMessage.h
//  Ying2018
//
//  Created by qiugaoying on 2018/10/28.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, QGYMessageType){
    QGYMessageTypeText          = 0, //文本类型消息
    QGYMessageTypeImage         = 1 //图片类型消息
};

typedef NS_ENUM(NSInteger, MessageReadStatuType){
    MessageStatuRead = 0 , //已读
    MessageStatuUnRead = 1, //未读
};

typedef NS_ENUM(NSInteger, MessageSendStatuType){
    MessageStatuSending = 0, //发送中
    MessageStatuSuccess = 1,  //发送成功
    MessageStatuFail = 2  //发送失败
};

@interface QGYMessage : NSObject

@property (nonatomic, strong)   NSString * message_id;          //本地消息id
@property (nonatomic, strong)   NSString * server_message_id;   //云端消息id ，删除本地消息时候时候，清空云端记录;可控制一个开关是否要一起清空云端数据；
@property (nonatomic, assign)   QGYMessageType message_type;    //消息类型
@property (nonatomic, strong)   NSString * from_uid;            //发送方账号id；
@property (nonatomic, strong)   NSString * session_id;          //对方账号(消息会话Id)
@property (nonatomic, strong)   NSString * content;             //文本内容，或者图片的真实远程Url路径或者声音
@property (nonatomic, strong)   NSString * headImg;             //发送方头像
@property (nonatomic, strong)   NSString * thumbPath;           //发送图片，模糊带出图片显示， 上传图片本地缓存路径
@property (nonatomic, assign)   MessageReadStatuType read_status; //默认已读状态
@property (nonatomic, assign)   MessageSendStatuType send_status; //消息发送状态
@property (nonatomic, assign)   NSTimeInterval timestamp;         //发送时间
@property (nonatomic, assign)   BOOL isOutgoingMsg;               //是否往外发送

//---------------- 业务 字段 ----------------
@property (nonatomic, strong) NSString *imgUrl;  //图片url
@property (nonatomic, strong) NSString * sendDate; //消息发送时间；
@end
