//
//  NSObject+Runtime.h
//  MsgTest
//
//  Created by Tianlong on 2017/9/13.
//  Copyright © 2017年 Tianlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)
/**
 获取属性列表
 */
+(void)getPropertyList;
/**
 方法列表
 */
+(void)getMethodList;
/**
 成员列表
 */
+(void)getIvarList;
/**
 协议列表
 */
+(void)getProtocolList;
#pragma mark - 方法交换
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
