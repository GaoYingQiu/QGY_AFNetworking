//
//  GYLoginManager.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/26.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "GYLoginManager.h"
#import "GYSandBoxHelper.h"
#import <MJExtension.h>

//对自定义的Object 归档 需要实现NSCoding协议的方法；
//类似Java 的对象序列化 ，需要实现序列化接口方法规则
@implementation LoginData

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"userId" : @"id"
             };
}

+(NSDictionary*)mj_objectClassInArray
{
    return @{@"lastLoginInfoResp":[LastLoginInfoResp class]};
}


/*  用以下方式 实现对象的 编码 和 解码 （MJExtension） */
 - (id)initWithCoder:(NSCoder *)decoder \
 { \
 if (self = [super init]) { \
 [self mj_decode:decoder]; \
 } \
 return self; \
 } \
 \
 - (void)encodeWithCoder:(NSCoder *)encoder \
 { \
 [self mj_encode:encoder]; \
 }
 
@end

@implementation LastLoginInfoResp
- (id)initWithCoder:(NSCoder *)decoder \
{ \
    if (self = [super init]) { \
        [self mj_decode:decoder]; \
    } \
    return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
    [self mj_encode:encoder]; \
}

@end


@interface GYLoginManager()
@property(nonatomic,copy) NSString *cacheFilePath; //归档到沙盒的路径
@end

@implementation GYLoginManager

+(instancetype)shareInstance
{
    static GYLoginManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[GYSandBoxHelper getAppDocumentPath]stringByAppendingPathComponent:@"qgy2019_login_data"];
        instance = [[GYLoginManager alloc]initWithFilePath:filePath];
    });
    return instance;
}

-(instancetype)initWithFilePath:(NSString *)path
{
    if(self == [super init]){
        _cacheFilePath = path;
        [self readCacheData];
    }
    return self;
}

//读取缓存数据
-(void)readCacheData
{
    NSString *filePath = [self cacheFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _currentLoginData = [object isKindOfClass:[LoginData class]] ? object : nil;
    }
}

//返回当前是否登录
-(BOOL)isLogin
{
    return _currentLoginData.token? YES : NO;
}

-(void)setCurrentLoginData:(LoginData *)currentLoginData
{
    _currentLoginData = currentLoginData;
    if(_currentLoginData == nil)
    {
        _currentLoginData = [[LoginData alloc]init];
    }
    [self saveData];
}

//保存数据
-(void)saveData
{
//    NSData *data = [NSData data];
    if(_currentLoginData){
        //或者以下写法，将对象写入文件系统
        [NSKeyedArchiver archiveRootObject:_currentLoginData toFile:[self cacheFilePath]];
//        data = [NSKeyedArchiver archivedDataWithRootObject:_currentLoginData];
    }
//    [data writeToFile:[self cacheFilePath] atomically:YES];
}
@end
