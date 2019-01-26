//
//  ChatListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/8/20.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "QGYMessage.h"
#import "ChatRecordListRequest.h"
#import <MJExtension.h>

@implementation ChatRecordListRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_ChatSessionList;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:self.sessionId?:@"" forKey:@"sessionId"];
    [params setObject:@(self.pageIndex)  forKey:@"pageNum"];
    [params setObject:@(self.pageSize)  forKey:@"pageSize"];
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/userCenter/message/listRecord";
}

-(void)parseResponse:(QGYBaseResponse *)response
{
    NSArray *dataArr = [response.dataDic objectForKey:@"items"];
    NSArray *modelList = [QGYMessage mj_objectArrayWithKeyValuesArray:dataArr];
    response.responseObject = modelList;
}

@end
