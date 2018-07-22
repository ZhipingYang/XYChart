//
//  NSArray+Map.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (Map)

/**
 提供数组元素类型转换的方法 比如 @[@(1),@(2),@(3)] => @[@"1",@"2",@"3"]
 转换失败用NSNull替换
 
 @param block 子元素转换成所对应的id类型, （注意：必有返回值）
 @return 新数组 新元素类型
 */
- (NSArray *)uu_map:(nonnull id (^)(ObjectType obj, NSUInteger idx))block;

/**
 获取当前数组中满足闭包条件下的最大值 比如比较age大小：@[father, son] => father

 @param block 比较对象返回升降序值
 @return 最大值对象
 */
- (nullable ObjectType)uu_max:(NSComparisonResult (^)(ObjectType pre, ObjectType next))block;

/**
 获取当前数组中满足闭包条件下的最小值 比如比较age大小：@[father, mother, son] => son
 
 @param block 比较对象返回升降序值
 @return 最小值对象
 */
- (nullable ObjectType)uu_min:(NSComparisonResult (^)(ObjectType pre, ObjectType next))block;

/**
 安全取值
 */
@property (nonatomic, readonly, nullable) ObjectType (^safeIndex)(NSUInteger index);

@end

NS_ASSUME_NONNULL_END
