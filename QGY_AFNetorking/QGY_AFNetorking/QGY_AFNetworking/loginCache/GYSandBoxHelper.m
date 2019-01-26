//
//  GYSandBoxHelper.m
//  QGY_AFNetworking
//
//  Created by qiugaoying on 2019/1/26.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "GYSandBoxHelper.h"

@implementation GYSandBoxHelper

+(NSString *)getAppDocumentPath
{
    static NSString *documentPath = nil;
    static dispatch_once_t onceToken;
    
    //App的 document 路径全局只创建一次。
    dispatch_once(&onceToken, ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [paths[0] stringByAppendingPathComponent:@"QGY_AFNetworking"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
        {
            //没有APPYing2018文件夹 则 创建 该文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
    });
    return  documentPath;
}

+ (NSString *)tmpPath
{
    return [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
}

@end
