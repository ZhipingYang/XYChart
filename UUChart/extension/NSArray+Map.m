//
//  NSArray+Map1.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray *)uu_map:(nonnull id (^)(id obj, NSUInteger idx))block
{
    NSAssert(block!=nil, @"block 不能为空, 但还是做了保护");
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        id value = block ? block(object, index) : [NSNull null];
        [result addObject:value];
    }];
    
    return [NSArray arrayWithArray:result];
}

@end
