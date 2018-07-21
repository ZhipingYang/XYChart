//
//  NSArray+Map1.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "NSArray+UUChart.h"

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

- (id)uu_max:(NSComparisonResult (^)(id, id))block
{
    if (self.count==0) { return nil; }
    if (self.count==1) { return self.firstObject;}
    id max = self.firstObject;
    for (int i=1; i<self.count; i++) {
        if (block(max, self[i]) == NSOrderedAscending) {
            max = self[i];
        }
    }
    return max;
}

- (id)uu_min:(NSComparisonResult (^)(id, id))block
{
    if (self.count==0) { return nil; }
    if (self.count==1) { return self.firstObject;}
    id min = self.firstObject;
    for (int i=1; i<self.count; i++) {
        if (block(min, self[i]) == NSOrderedDescending) {
            min = self[i];
        }
    }
    return min;
}

- (id  _Nonnull (^)(NSUInteger))safeIndex
{
    __weak typeof(self) weakSelf = self;
    id (^block)(NSUInteger index) = ^(NSUInteger index) {
        return (weakSelf.count-1)<index ? nil : weakSelf[index];
    };
    return block;
}

@end
