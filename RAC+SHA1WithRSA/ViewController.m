//
//  ViewController.m
//  RAC+SHA1WithRSA
//
//  Created by 徐结兵 on 2018/5/8.
//  Copyright © 2018年 xujiebing. All rights reserved.
//

#import "ViewController.h"
#import "RSA+SHA1WithRSA.h"
#import "AlertTool.h"

static NSString *kSignString = @"待签名信息";
static NSString *kSign = nil;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 签名
- (IBAction)signSHA1WithRSA:(id)sender {
    NSString *sign = [RSA signSHA1WithRSA:kSignString privateKey:kPrivateKey];
    kSign = sign;
    NSLog(@"******************** \n\n %@ \n\n **********", kSign);
    [AlertTool alertViewWithMessage:kSign];
}

// 验签
- (IBAction)verifySHA1WithRSA:(id)sender {
    if (kSign.length == 0) {
        [AlertTool alertViewWithMessage:@"请先加签"];
        return;
    }
    BOOL verify = [RSA verifySHA1WithRSA:kSignString signature:kSign publicKey:kPublicKey];
    NSString *message = nil;
    if (verify) {
        message = @"签名验证成功";
    } else {
        message = @"签名验证失败";
    }
    [AlertTool alertViewWithMessage:message];
    NSLog(@"******************** \n\n %@ \n\n **********", message);
}


@end
