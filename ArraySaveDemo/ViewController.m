//
//  ViewController.m
//  ArraySaveDemo
//
//  Created by Tianlong on 2017/9/13.
//  Copyright © 2017年 Tianlong. All rights reserved.
//

#import "ViewController.h"

@interface Person : NSObject
@property (nonatomic , copy) NSString *name;
@end

@implementation Person
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testArray];
}

-(void)testArray{
    /** 不可变数组 */
    //角标越界
    //数组 = nil
    NSArray *array = nil;
    NSLog(@"array[1] = %@",array[2]);
    
    //count = 0
    NSArray *array1 = @[];
    NSLog(@"array1[1] = %@",array1[2]);
    
    //只有一个元素
    NSArray *array2 = @[@"123"];
    NSLog(@"array2[2] = %@",array2[2]);
    
    //多个元素
    NSArray *array3 = @[@"123",@"321",@"456"];
    NSLog(@"array3[8] = %@",array3[8]);
    
    //创建数组传入nil
    NSArray *array4 = [NSArray arrayWithContentsOfURL:nil];
    NSArray *array5 = [NSArray arrayWithObjects:nil, nil];
    NSArray *array6 = [NSArray arrayWithArray:nil];
    NSArray *array7 = [NSArray arrayWithObject:nil];
    NSArray *array8 = [NSArray arrayWithObjects:nil count:1];
    
    
    /**
     * 可变指针 指向 不可变数组
     * 此种指向需要注意,如果用不可变数组对象,访问了可变数组的方法会造成崩溃
     * 下面的数组其真实类型是不可变数组
     */
    NSMutableArray *arrayI = nil;
    NSLog(@"arrayI[1] = %@",arrayI[2]);
    [arrayI addObject:nil];
    [arrayI insertObject:nil atIndex:0];
    
    
    //count = 0
    NSMutableArray *array1I = @[];
    NSLog(@"array1I[1] = %@",array1I[2]);
    //[array1I addObject:nil];//语法错误,不可变访问可变方法,崩溃
    //[array1I insertObject:nil atIndex:0];//语法错误,不可变访问可变方法,崩溃
    
    //只有一个元素
    NSMutableArray *array2I = @[@"123"];
    NSLog(@"array2I[2] = %@",array2I[2]);
    
    //多个元素
    NSMutableArray *array3I = @[@"123",@"321",@"456"];
    NSLog(@"array3I[8] = %@",array3I[8]);
    
    //创建数组传入nil
    NSMutableArray *array4I = [NSArray arrayWithContentsOfURL:nil];
    NSMutableArray *array5I = [NSArray arrayWithObjects:nil, nil];
    NSMutableArray *array6I = [NSArray arrayWithArray:nil];
    NSMutableArray *array7I = [NSArray arrayWithObject:nil];
    NSMutableArray *array8I = [NSArray arrayWithObjects:nil count:1];
    
    
    /**
     * 可变指针 指向 可变数组
     */
    NSMutableArray *arrayM = nil;
    [arrayM addObject:nil];
    [arrayM insertObject:nil atIndex:3];
    
    NSMutableArray *array1M = [NSMutableArray array];
    [array1M addObject:nil];
    [array1M insertObject:nil atIndex:0];
    
    
    NSMutableArray *array2M = [[NSMutableArray alloc] init];
    [array2M addObject:nil];
    [array2M insertObject:nil atIndex:1];
    
    NSMutableArray *array3M = [NSMutableArray arrayWithObject:@"123"];
    [array3M addObject:nil];
    [array3M insertObject:nil atIndex:1];
    
    NSMutableArray *array16M = [NSMutableArray arrayWithContentsOfURL:nil];
    NSMutableArray *array18M = [NSMutableArray arrayWithObjects:nil, nil];
    NSMutableArray *array19M = [NSMutableArray arrayWithArray:nil];
    NSMutableArray *array14M = [NSMutableArray arrayWithObject:nil];
    NSMutableArray *array15M = [NSMutableArray arrayWithObjects:nil count:1];
    
    //测试插入对象为空
    NSMutableArray *array20M = [NSMutableArray array];
    [array20M addObject:nil];
    [array20M addObject:[[Person alloc]init]];
    [array20M addObject:[[Person alloc]init]];
    NSLog(@"array16M = %@",array20M);
    id obj = array20M[0];
    if ([obj isKindOfClass:[NSNull class]]) {
        NSLog(@"我是个null");
    }
    
    Person *p1 = array20M[0];
    NSLog(@"p1.name = %@",p1.name);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
