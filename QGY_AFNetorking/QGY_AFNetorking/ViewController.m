//
//  ViewController.m
//  QGY_AFNetorking
//
//  Created by qiugaoying on 2019/1/26.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "ViewController.h"
#import "GYNetworkingManager.h"
#import "GYLoginManager.h"

#import "LoginRequest.h"
#import "ChatRecordListRequest.h"
#import "ChatSessionDeleteRequest.h"

@interface ViewController ()<QGYDataRequestDelegate>

@property(nonatomic,strong) NSString *account; //账号
@property(nonatomic,strong) NSString *pwd; //密码

@property(nonatomic,strong) NSMutableArray *dataList; //数据源；

@property(nonatomic,strong) ChatRecordListRequest *chatRecordListRequest;
@property(nonatomic,assign) NSInteger pageNumber; //当前页
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chatRecordListRequest = [[ChatRecordListRequest alloc]init];
        _chatRecordListRequest.delegate  = self;
        _pageNumber = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

#pragma mark - request Test
-(void)doUserLoginRequest
{
    LoginRequest *request  = [[LoginRequest alloc] init];
    request.delegate  = self; //指定请求回调委托
    
    //传参
    request.account = self.account;
    request.pwd = self.pwd;
    
    //让 网络发射器 去执行 登录请求；
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

//加载某个会话的聊天记录
-(void)doChatRecordListRequest
{
    _chatRecordListRequest.pageIndex = self.pageNumber; //分页
    _chatRecordListRequest.sessionId = @"会话id";
    
    [[GYNetworkingManager shareInstance] executeRequest:_chatRecordListRequest];
}

//加载下一页；
-(void)chatRecordList_loadNextPage
{
    self.pageNumber ++;
    [self doChatRecordListRequest];
}

//加载首页；
-(void)chatRecordList_refreshFirstPage
{
    self.pageNumber = 1;
    [self doChatRecordListRequest];
}

//删除某个会话
-(void)doDeleteChatRecordById
{
    ChatSessionDeleteRequest *request = [[ChatSessionDeleteRequest alloc]init];
    request.delegate = self;
    request.imid = @"记录id";
    [[GYNetworkingManager shareInstance] executeRequest:request];
}


#pragma mark - QGYDataRequestDelegate 网络请求回调处理；
-(void) onRequestSuccess:(QGYBaseResponse *)response  //业务成功回调
{
   // 根据请求的tag 处理不同请求回调后的 数据展现到UI 或其他处理；
    switch (response.requestAPICode) {
        case Http_ChatSessionListDelete:
        {
            NSLog(@"删除成功！");
            break;
        }
        case Http_Login:
        {
            if([GYLoginManager shareInstance].isLogin){
                //登录成功；
                /*
                if(self.loginBlock){
                    self.loginBlock();
                }
                 */
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case Http_ChatSessionList:
        {
            if(self.pageNumber == 1){
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:response.responseObject];
//           [self.tableView reloadData];
            break;
        }
    }
}

-(void) onRequestStatusError:(QGYBaseResponse *)response //业务失败回调
{
   // 根据失败码做相应的业务处理；
}

-(void) onRequestError:(NSError *)error request:(QGYBaseDataRequest *)request//由于网络或其他原因导致请求失败，需把请求带回
{
    //界面 通知用户网络错误， UI 友好体验， 网络重试等 处理；
}


#pragma mark - Getter & Setter
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
@end
