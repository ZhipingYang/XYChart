//
//  NSArray+XYChart.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (XYChart)

/**
 提供数组元素类型转换的方法 比如 @[@(1),@(2),@(3)] => @[@"1",@"2",@"3"]
 转换失败用NSNull替换
 
 @param block 子元素转换成所对应的id类型, （注意：必有返回值）
 @return 新数组 新元素类型
 */
- (NSArray *)xy_mapIndex:(nullable id (^)(ObjectType obj, NSUInteger idx))block;
- (NSArray *)xy_map:(nullable id (^)(ObjectType obj))block;
- (NSArray *)xy_flatMap:(nullable id (^)(id obj))block;

/**
 安全取值
 */
@property (nonatomic, readonly) ObjectType (^xy_safeIdx)(NSUInteger index);

@end



@interface NSMutableArray<ObjectType> (XYChart)

- (void)xy_safeAdd:(ObjectType)obj;
- (void)xy_flexibleReuseWithContains:(NSInteger)count map:(ObjectType (^)(void))map handle:(void (^)(ObjectType obj))handle;

@end

NS_ASSUME_NONNULL_END
