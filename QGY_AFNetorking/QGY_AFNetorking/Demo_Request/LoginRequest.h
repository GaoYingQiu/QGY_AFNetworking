//
//  LoginRequest.h
//  Ying2018
//
//  Created by qiugaoying on 2018/6/30.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGYBaseDataRequest.h"

@interface LoginRequest : QGYBaseDataRequest

@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *pwd;

@end
