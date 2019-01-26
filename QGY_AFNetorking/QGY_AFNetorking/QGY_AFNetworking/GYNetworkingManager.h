//
//  GYNetworkingManager.h
//  Qiu2017
//
//  Created by qiugaoying on 2018/6/30.
//  Copyright © 2018年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "QGYBaseDataRequest.h"
#import "FKReachability.h"
#import "QGYMessage.h"

@interface GYNetworkingManager : NSObject

+(instancetype)shareInstance;

@property(nonatomic,strong) NSMutableDictionary *progressDic; //进度缓存
@property (nonatomic, strong) FKReachability     *reachability;
//让网络管理器执行一个请求，
-(void)executeRequest:(QGYBaseDataRequest *)request;

//发送图片消息
-(void)uploadPicture:(QGYMessage *)message progress:(void (^)(void))uploadProgressBlock  complete:(void (^)(void))finishBlock;

//上传单张图片
-(void)uploadOneImage:(UIImage *)image progress:(void (^)(void))uploadProgressBlock  complete:(void (^)(NSString *urlPath))finishBlock;

//获取上传图片的进度
-(double)fetchPictureProgress:(NSString *)messageId;
@end
