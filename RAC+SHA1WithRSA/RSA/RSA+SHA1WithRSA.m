//
//  RSA+SHA1WithRSA.m
//  Demo
//
//  Created by 徐结兵 on 2018/5/6.
//  Copyright © 2018年 xujiebing. All rights reserved.
//

#import "RSA+SHA1WithRSA.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+BWTBase64.h"

@implementation RSA (SHA1WithRSA)

#pragma mark - 公共方法

+ (NSString *)signSHA1WithRSA:(NSString *)signatureString
                   privateKey:(NSString *)privateKey {
    if (privateKey.length == 0) {
        return nil;
    }
    uint8_t *signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
    SecKeyRef privateKeyRef = [self addPrivateKey:privateKey];
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    NSData *signatureBytes = [signatureString dataUsingEncoding:NSUTF8StringEncoding];
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) );
    memset((void *)signedBytes, 0x0, signedBytesSize);
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self p_getHashBytes:signatureBytes] bytes],
                                CC_SHA1_DIGEST_LENGTH,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    if (sanityCheck == noErr){
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    } else {
        return nil;
    }
    if (signedBytes) {
        free(signedBytes);
    }
    return [signedHash base64EncodedString];
}

+ (BOOL)verifySHA1WithRSA:(NSString *)signatureString
                signature:(NSString *)signature
                publicKey:(NSString *)publicKey {
    if (publicKey.length == 0 || signatureString.length == 0 || signature.length == 0) {
        return NO;
    }
    NSData *signatureStringData = [signatureString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc] initWithBase64EncodedString:signature options:NSDataBase64DecodingIgnoreUnknownCharacters];
    SecKeyRef publicKeyRef = [self addPublicKey:publicKey];
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKeyRef);
    const void* signedHashBytes = [signatureData bytes];
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([signatureStringData bytes], (CC_LONG)[signatureStringData length], hashBytes)) {
        return NO;
    }
    OSStatus status = SecKeyRawVerify(publicKeyRef,
                                      kSecPaddingPKCS1SHA1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    return status == errSecSuccess;
}

#pragma mark - 私有方法

+ (NSData *)p_getHashBytes:(NSData *)plainText {
    
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    // Malloc a buffer to hold hash.
    hashBytes = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void*)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)CC_SHA1_DIGEST_LENGTH];
    if (hashBytes) free(hashBytes);
    return hash;
}

@end
