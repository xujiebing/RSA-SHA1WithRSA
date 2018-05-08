//
//  RSA+SHA1WithRSA.h
//  Demo
//
//  Created by 徐结兵 on 2018/5/6.
//  Copyright © 2018年 xujiebing. All rights reserved.
//

#import "RSA.h"

@interface RSA (SHA1WithRSA)


/**
 SHA1WithRSA加签
 
 @param signatureString 待签名字符串
 @param privateKey 私钥
 @return 签名之后的字符串
 */
+ (NSString *)signSHA1WithRSA:(NSString *)signatureString
                   privateKey:(NSString *)privateKey;

/**
 SHA1WithRSA验签
 
 @param signatureString 验签明文
 @param signature 签名信息
 @param publicKey 公钥
 @return 验证结果   YES:验证成功
 */
+ (BOOL)verifySHA1WithRSA:(NSString *)signatureString signature:(NSString *)signature publicKey:(NSString *)publicKey;

@end
