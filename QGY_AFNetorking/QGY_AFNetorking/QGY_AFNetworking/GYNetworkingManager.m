//
//  GYNetworkingManager.m
//  Qiu2017
//
//  Created by qiugaoying on 2018/6/30.
//  Copyright © 2018年 zy. All rights reserved.
//

#import "GYNetworkingManager.h"
#import "NSString+QGY.h"

@interface GYNetworkingManager()

@property (nonatomic,strong,readonly) AFHTTPSessionManager *manager; //3.X

@end

@implementation GYNetworkingManager

//单例实例化方法
+(instancetype)shareInstance
{
    static GYNetworkingManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //配置相对路径
        instance = [[GYNetworkingManager alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configManager];
        _progressDic = [[NSMutableDictionary alloc]init];
        [self setupReachability];
    }
    return self;
}

- (void)setupReachability {
    self.reachability = [FKReachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:@"FKReachabilityChangedNotification"
                                               object:nil];
}


-(void)configManager{
    
    _manager = [[AFHTTPSessionManager alloc]init];
    
    AFJSONRequestSerializer *requestSerializer = [[AFJSONRequestSerializer alloc] init];
    requestSerializer.timeoutInterval = 30;
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    _manager.requestSerializer = requestSerializer;
    _manager.responseSerializer = [AFJSONResponseSerializer serializer]; //httpSerializer 需手动转json
    _manager.requestSerializer.timeoutInterval = NetworkTimeoutInterval;
  
    _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
     _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
   
}

#pragma mark - Private Methode
- (void)reachabilityChanged:(NSNotification *)note {
    switch (self.reachability.currentReachabilityStatus) {
        case NotReachable: {
            
            NSLog(@"已断开网络!");
           
        } break;
            
        case ReachableViaWiFi: {
 
        } break;
            
        case ReachableViaWWAN: {
 
        } break;
    }
}

-(void)executeRequest:(QGYBaseDataRequest *)request
{
    //网络不可用
    if (self.reachability.currentReachabilityStatus == NotReachable){
    
        NSError *error = [NSError errorWithDomain:CustomErrorDomain code:CustomResCodeNotNetConnect userInfo:nil];
        [self onError:error requestObj:request];
        return;
    }
    
    switch (request.requestType) {
        case RequestTypeGet:
        case RequestTypePost:
        {
            [_manager POST:request.requestDomainUrl parameters:[request acquireBaseRequestParamDictionary] progress:^(NSProgress *  uploadProgress) {
            } success:^(NSURLSessionDataTask *  task, id   responseObject) {
                [self onSuccess:responseObject requestObj:request];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"错误日志：code%ld ---- %@",error.code, error.localizedDescription);
                [self onError:error requestObj:request];
            }];
            
            break;
        }
        default: break;
    }
}

-(void) onSuccess:(id)result requestObj:(QGYBaseDataRequest<QGYAPIManager> *)request
{
    // NSError *jsonError = nil;
    //NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&jsonError]; 响应时候 如果是HTTPResonseSerialize 需要手动将NSdata 转 字典
//    __weak typeof(self) weakSelf = self;
    
    NSDictionary *resultDic = (NSDictionary *)result;
    if (resultDic) {
        QGYBaseResponse *response =  [[QGYBaseResponse alloc] initWithData:resultDic];
        response.requestAPICode = request.requestApiCode;//请求的API
        response.requestObject = request.requestObject; //使用的请求对象
        NSLog(@"reqest Method:%@ -------**********-------- response finished:%@",[request getAPIRequestMethodName],resultDic);
        if (response.result) {
            
            //解析，将responseObject设置成model对象
            [request parseResponse:response];
            
            if (request.delegate && [request.delegate conformsToProtocol:@protocol(QGYDataRequestDelegate)] && [request.delegate respondsToSelector:@selector(onRequestSuccess:)]) {
                [request.delegate onRequestSuccess:response];
            }
        }else{
            
            if(response.recode == CustomResCodeAccountTokenExpire){
                //检查到token失效，需弹出提示token已失效，然后点击确定后去登录。
              
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_LoginTokenExpire" object:@(1)];
                
            }else{
                
                if (request.delegate && [request.delegate conformsToProtocol:@protocol(QGYDataRequestDelegate)] && [request.delegate respondsToSelector:@selector(onRequestStatusError:)]) {
                    
                    [request.delegate onRequestStatusError:response];
                }
            }
        }
    }
}

-(void) onError:(NSError *)error requestObj:(QGYBaseDataRequest<QGYAPIManager> *)request
{
    if (request.delegate && [request.delegate conformsToProtocol:@protocol(QGYDataRequestDelegate)] && [request.delegate respondsToSelector:@selector(onRequestError:request:)]) {
        [request.delegate onRequestError:error request:request];
    }
}

//图片的下载进度
-(double)fetchPictureProgress:(NSString *)messageId
{
    double progress = 0.0f;
    NSNumber *progressNumber = [self.progressDic objectForKey:messageId];
    if(progressNumber){
        progress = progressNumber.doubleValue;
    }
    return progress;
}


-(void)uploadOneImage:(UIImage *)image progress:(void (^)(void))uploadProgressBlock  complete:(void (^)(NSString *urlPath))finishBlock
{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/ajaxUpload",NetCoachDomain];
    [_manager POST:uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 1、准备一张图片 ，从沙盒 temp 中读取。
        NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
       
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%@",[NSString qgy_uniqueStringForMessage]] fileName:@"first.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        double completeProgress  = uploadProgress.fractionCompleted;
        if(uploadProgressBlock){
            uploadProgressBlock();
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        QGYBaseResponse *imgResponse =  [[QGYBaseResponse alloc] initWithData:responseObject];
        
        if(imgResponse.recode == CustomResCodeSuccess){
            //上传完成 返回后 根据message_id 设置 对应消息的content 以及 发送状态； 移除缓存中的进度。
            NSString * content = (NSString *)imgResponse.responseObject;
        
            //回调给页面 更新UI.
            if(finishBlock){
                finishBlock(content);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(finishBlock){
            finishBlock(@"");
        }
    }];
}



//上传消息图片
-(void)uploadPicture:(QGYMessage *)message progress:(void (^)(void))uploadProgressBlock  complete:(void (^)(void))finishBlock
{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/ajaxUpload",NetCoachDomain];
    [_manager POST:uploadUrl parameters:@{@"tag":@"1"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
            // 1、准备一张图片 ，从沙盒 temp 中读取。
            NSData * imageData = [NSData dataWithContentsOfFile:message.thumbPath];
            NSArray *nameArr = [message.thumbPath componentsSeparatedByString:@"/tmp/"];
            NSString *fileName = nameArr.lastObject;
        
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%@",message.message_id] fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
   
            double completeProgress  = uploadProgress.fractionCompleted;
            [self.progressDic setObject:[NSNumber numberWithDouble:completeProgress] forKey:message.message_id];
            //准备一个字典 ，缓存 message_id 的消息进度。
            if(uploadProgressBlock){
                uploadProgressBlock();
            }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        QGYBaseResponse *imgResponse =  [[QGYBaseResponse alloc] initWithData:responseObject];
        
        if(imgResponse.recode == CustomResCodeSuccess){
            //上传完成 返回后 根据message_id 设置 对应消息的content 以及 发送状态； 移除缓存中的进度。
            message.content = (NSString *)imgResponse.responseObject;
            message.send_status = MessageStatuSuccess;
            [self.progressDic removeObjectForKey:message.message_id];
            //回调给页面 更新UI.
            if(finishBlock){
                finishBlock();
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
        message.content = @"";
        message.send_status = MessageStatuFail;
        [self.progressDic removeObjectForKey:message.message_id];
        if(finishBlock){
            finishBlock();
        }
    }];
}

@end
