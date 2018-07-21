//
//  NSArray+Map.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (Map)

/**
 提供数组元素类型转换的方法 比如 @[@(1),@(2),@(3)] => @[@"1",@"2",@"3"]
 转换失败用NSNull替换
 
 @param block 子元素转换成所对应的id类型, （注意：必有返回值）
 @return 新数组 新元素类型
 */
- (NSArray *)uu_map:(nonnull id (^)(ObjectType obj, NSUInteger idx))block;

- (nullable ObjectType)uu_max:(NSComparisonResult (^)(ObjectType pre, ObjectType next))block;

- (nullable ObjectType)uu_min:(NSComparisonResult (^)(ObjectType pre, ObjectType next))block;

@end
