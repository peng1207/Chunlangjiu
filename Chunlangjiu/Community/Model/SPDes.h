//
//  SPDes.h
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/10.
//  Copyright © 2019 Chunlang. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SPDes : NSObject
#pragma mark --- des
/**
 *  des加密
 *
 *  @param sText 加密数据
 *  @param key   加密的key
 *
 *  @return 返回加密后的数据
 */
+ (NSString *)encryptWithText:(NSString *)sText key:(NSString *)key;
/**
 *  des解密
 *
 *  @param sText 解密数据
 *  @param key   解密的key
 *
 *  @return 返回解密之后的数据
 */
+ (NSString *)decryptWithText:(NSString *)sText key:(NSString *)key;
@end


