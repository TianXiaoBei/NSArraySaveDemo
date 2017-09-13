//
//  NSObject+Runtime.m
//  MsgTest
//
//  Created by Tianlong on 2017/9/13.
//  Copyright © 2017年 Tianlong. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation NSObject (Runtime)

+(void)applicationWillResignActiveNotification:(NSNotification *)note{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

+(void)load{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

/**
 获取属性列表
 */
+(void)getPropertyList{
    //获取属性列表
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"propertyList = %@",[NSString stringWithUTF8String:propertyName]);
    }
}

/**
 方法列表
 */
+(void)getMethodList{
    //获取属性列表
    unsigned int count;
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"method = %@",NSStringFromSelector(method_getName(method)));
    }
}

/**
 成员列表
 */
+(void)getIvarList{
    //获取成员
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar var = ivarList[i];
        const char *varName = ivar_getName(var);
        NSLog(@"var = %@",[NSString stringWithUTF8String:varName]);
    }
    
}

/**
 协议列表
 */
+(void)getProtocolList{
    //获取协议成员
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *pro = protocolList[i];
        const char *proName = protocol_getName(pro);
        NSLog(@"proName = %@",[NSString stringWithUTF8String:proName]);
    }
}

#pragma mark - 方法交换
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
