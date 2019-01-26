//
//  NIMMessage.m
//  Ying2018
//
//  Created by qiugaoying on 2018/6/28.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "QGYMessage.h"
#import "NSString+QGY.h"
#import "GYLoginManager.h"

@implementation QGYMessage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _message_id = [NSString qgy_uniqueStringForMessage];
    }
    return self;
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"server_message_id" : @"id",
             @"session_id" : @"sendUserId", //发送方ID
             @"content" : @"message",
            };
}

//字典转模型 完成后的回调
- (void)mj_keyValuesDidFinishConvertingToObject
{
    if(self.read_status == MessageStatuRead){
        self.read_status  = MessageStatuUnRead;
    }else{
        self.read_status  = MessageStatuRead;
    }
    
    if(self.imgUrl && self.imgUrl.length>0)
    {
        self.content = self.imgUrl;
        self.message_type = QGYMessageTypeImage;
    }else{
        self.message_type = QGYMessageTypeText;
    }
    
    NSString *selfId = [GYLoginManager shareInstance].currentLoginData.userId;
    if([self.session_id isEqualToString:selfId]){
        //发送方是自己的情况下，
        self.from_uid = @"out";
    }else{
        self.from_uid = @"in";
    }
    
    //消息时间；
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]]; //en_US
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [inputFormatter dateFromString:self.sendDate];
    self.timestamp =  [date timeIntervalSince1970] * 1000;
    
}


-(BOOL)isOutgoingMsg{
    if([self.from_uid isEqualToString:@"out"]){
        return YES;
    }
    return NO;
}
@end
