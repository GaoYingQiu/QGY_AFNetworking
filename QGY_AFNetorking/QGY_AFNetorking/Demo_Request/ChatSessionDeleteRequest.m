//
//  ChatSessionDeleteRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/8/23.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "ChatSessionDeleteRequest.h"

@implementation ChatSessionDeleteRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_ChatSessionListDelete;
    }
    return self;
}


-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:self.imid?:@"" forKey:@"imid"];
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/userCenter/message/chatRecord_delete";
}

-(void)parseResponse:(QGYBaseResponse *)response
{
    
}
@end
