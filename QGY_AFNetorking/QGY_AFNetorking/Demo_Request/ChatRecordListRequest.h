//
//  ChatListRequest.h
//  Ying2018
//
//  Created by qiugaoying on 2018/8/20.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "QGYBaseDataRequest.h"

//聊天记录接口；

@interface ChatRecordListRequest : QGYBaseDataRequest

@property(nonatomic,strong) NSString *sessionId; //会话id
@property(nonatomic,assign) NSInteger pageIndex; //当前页
@property(nonatomic,assign) NSInteger pageSize; //每页数量
@end

