# QGY_AFNetworking
### 解决什么问题？ ###
基于AFNetworking做的一个关于请求类的封装；功能职责：独立的业务请求类，处理业务，数据缓存等； 其目的为减轻ViewController的负重，业务请求相对独立不冗余；  AFNetworking , QGY_AFNetworking,  网络请求封装，MVVM, VIPER, MVC ,多态；

### 原理 ###
VC 发起请求， 一个专门发请求的发射器；我给它取名字 叫 NetManager , 显然 ，为 了不重复创建http 请求基础配置（请求头，Https证书配置等），这是个单例；
发射器 发的是请求； 考虑到每个业务 都有不同的请求；我准备了 一个 超级父类请求 ；取名 DataRequest; 具体的请求，只需传 具体的子类request；
一个APP 请求有很多，为了区分 及 维护方便 ，于是我定义了一个枚举；每个业务请求，只需给它表明一个标识；

### 请求具有什么特性呢？###
1、有请求的API url地址；
2、请求的参数，请求的标识（请求的枚举值）；
3、对请求回来的数据解析好封装（业务数据封装等处理）；


于是我定义了一个名叫APIInterface 的接口协议； 父类请求去实现这个APInterface接口协议； 子类去Override 这几个方法即可；

发出一个请求，必然有 回答；要么成功，要么失败 （有的失败是业务码失败）； 于是 ，我定义了已一个请求回调的接口；RequestCallBackInterface ； （具有三个方法： 业务成功，业务失败，网络其他原因失败）

我从VC 发出去的请求，相当于Android 的Activity; 熟称视图控制器；当然是希望请求回调 回到 视图控制器；
于是我 在 基类视图控制器 BaseViewController 或者BaseActivity(Android) 实现 请求回调 接口协议；实现其中的方法。
具体视图控制器 继承基类， 只需覆盖Override 这三个方法 （具体VC 实现回调后的业务）

最后；页面逻辑就显示得比较简单了，一个单例 NetManager 执行一个 DataRequest (传具体请求子类) ； 视图控制器在具体RequestCallBackInterface 的回调方法 中处理 成功 ，失败后的数据；


### Code Demo ###

```
//登录请求
self.loginRequest.userLogin = self.userName;
self.loginRequest.userPass =  self.userPwd;
[[GYNetworkingManager shareInstance] executeRequest:self.loginRequest];


//朋友圈列表请求
self.dynamicListRequest.pageIndex = 1;
self.dynamicListRequest.pageSize = 20;
[[GYNetworkingManager shareInstance] executeRequest:self.dynamicListRequest];


-(void) onRequestSuccess:(BaseResponse *)response
{
    switch (response.requestAPICode ) {  //请求的枚举
        case Http_Login:
        {
          //返回的登录对象
          // LoginData *data  = response.responseObject;
          break;
        }
        case Http_DynamicList:
        {
          //如果是列表,则从取数组
          NSArray *dataList  = response.tableList.dataList;
          [self allLoadingCompleted:dataList];
          break;
        }
        default:
          break;
    }
}
```
