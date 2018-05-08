//
//  AlertTool.m
//  RAC+SHA1WithRSA
//
//  Created by 徐结兵 on 2018/5/8.
//  Copyright © 2018年 xujiebing. All rights reserved.
//

#import "AlertTool.h"
#import <UIKit/UIKit.h>

@implementation AlertTool

+ (void)alertViewWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    [vc presentViewController:alertController animated:YES completion:nil];
}

@end
