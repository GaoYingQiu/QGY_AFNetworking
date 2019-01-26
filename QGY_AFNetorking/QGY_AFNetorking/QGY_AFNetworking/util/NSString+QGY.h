//
//  NSString+NTES.h
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (QGY)

//唯一字符串
+(NSString *)qgy_uniqueStringForMessage;

//md5加密
- (NSString *)qgy_MD5String;

@end
