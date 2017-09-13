//
//  NSArray+Save.m
//  MsgTest
//
//  Created by Tianlong on 2017/9/12.
//  Copyright © 2017年 Tianlong. All rights reserved.
//

#import "NSArray+Save.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.m"

@implementation NSArray (Save)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            /** 不可变数组 */
            //空
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectAtIndex:)];
            //非空
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(anyObjectAtIndex:)];
            
            /** 可变数组 */
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(addObject:) swizzledSelector:@selector(mutableAddObject:)];
            
            /** 只有一个元素 */
            //数组中只有一个元素
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(singleObjectIndex:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(singleInsertObject:atIndex:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(addObject:) swizzledSelector:@selector(singleAddObject:)];
            
            /** 类方法创建的数组,插入空时,下面这两个会崩溃 */
            [objc_getClass("__NSPlaceholderArray") swizzleMethod:@selector(initWithObjects:count:) swizzledSelector:@selector(swizzInitWithObjects:count:)];
        }
    });
}

#pragma mark - 不可变
/**
 空:nil 或 count = 0
 */
- (id)emptyObjectAtIndex:(NSInteger)index{
    NSLog(@"数组 = nil 或者 count = 0 返回 nil %s",__FUNCTION__);
    return nil;
}

/**
 多个元素
 */
- (id)anyObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSLog(@"取值时: 索引越界,返回 nil %s",__FUNCTION__);
        return nil;
    }
    id obj = [self anyObjectAtIndex:index];
    if ([obj isKindOfClass:[NSNull class]]) {
        NSLog(@"取值时: 取出的元素类型为 NSNull 类型,返回 nil %s",__FUNCTION__);
        return nil;
    }
    return obj;
}

#pragma mark - 两个类方法引起的崩溃
/**
 arrayWithObject
 arrayWithObjects:nil count:1
 */
-(id)swizzInitWithObjects:(const id [])objects count:(NSUInteger)cnt{
    for (int i=0; i<cnt; i++) {
        if (objects == NULL){
            NSLog(@"objects 为 NULL, 返回 nil %s",__FUNCTION__);
            return nil;
        }
        if (objects[i] == nil){
            NSLog(@"取值时: 取出的元素为 nil, 返回 nil %s",__FUNCTION__);
            return nil;
        }
    }
    return [self swizzInitWithObjects:objects count:cnt];
}

#pragma mark - 可变数组
/**
 取值
 */
- (id)mutableObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSLog(@"取值时: 索引越界, 返回 nil %s",__FUNCTION__);
        return nil;
    }
    id obj = [self mutableObjectAtIndex:index];
    if ([obj isKindOfClass:[NSNull class]]) {
        NSLog(@"取值时: 取出的元素类型为 NSNull, 返回 nil %s",__FUNCTION__);
        return nil;
    }
    return obj;
}

/**
 插入
 */
- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }else{
        NSLog(@"插入值时: 元素类型为 nil, %s",__FUNCTION__);
        [self mutableInsertObject:[NSNull null] atIndex:index];
    }
}

-(void)mutableAddObject:(id)object{
    if (object) {
        [self mutableAddObject:object];
    }else{
        NSLog(@"插入值时: 元素类型为 nil, %s",__FUNCTION__);
        [self mutableAddObject:[NSNull null]];
    }
}


#pragma mark - 数组中只有一个元素时三个方法不分可变和不可变
/**
 取值
 */
- (id)singleObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSLog(@"数组中只有一个元素, 取值时: 索引越界, 返回 nil %s",__FUNCTION__);
        return nil;
    }
    id obj = [self singleObjectIndex:index];
    if ([obj isKindOfClass:[NSNull class]]) {
        NSLog(@"数组中只有一个元素, 取值时: 元素类型为 NSNull 类型, 返回 nil %s",__FUNCTION__);
        return nil;
    }
    return obj;
}

/**
 插入
 */
- (void)singleInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self singleInsertObject:object atIndex:index];
    }else{
        //数组中有一个元素时,判断下真实类型,如果是NSArray,则不添加
        Class superClass = self.superclass;
        NSString *superClassStr = NSStringFromClass(superClass);
        if (![superClassStr isEqualToString:@"NSArray"]) {
            NSLog(@"数组中只有一个元素, 并且数组真实类型为NSMutableArray 插入值: 元素类型为 nil, %s",__FUNCTION__);
            [self singleInsertObject:[NSNull null] atIndex:index];
        }else{
            NSLog(@"真实类型是NSArray,什么都不做 %s",__FUNCTION__);
        }
    }
}

-(void)singleAddObject:(id)object{
    if (object) {
        [self singleAddObject:object];
    }else{
        //数组中有一个元素时,判断下真实类型,如果是NSArray,则不添加
        Class superClass = self.superclass;
        NSString *superClassStr = NSStringFromClass(superClass);
        if (![superClassStr isEqualToString:@"NSArray"]) {
            NSLog(@"数组中只有一个元素, 并且数组真实类型为NSMutableArray 插入值: 元素类型为 nil, %s",__FUNCTION__);
            [self singleAddObject:[NSNull null]];
        }else{
            NSLog(@"真实类型是NSArray,什么都不做 %s",__FUNCTION__);
        }
    }
}
@end

