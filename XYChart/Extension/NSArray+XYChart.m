//
//  NSArray+Map1.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "NSArray+XYChart.h"

@implementation NSArray (XYChart)

- (NSArray *)xy_mapIndex:(id  _Nonnull (^)(id _Nonnull, NSUInteger))block
{
    NSAssert(block!=nil, @"block can't be nil");
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        id value = block(object, index);
        [result xy_safeAdd:value];
    }];
    
    return [NSArray arrayWithArray:result];
}

- (NSArray *)xy_map:(id  _Nonnull (^)(id _Nonnull))block
{
    NSAssert(block!=nil, @"block can't be nil");
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        id value = block(object);
        [result xy_safeAdd:value];
    }];
    
    return [NSArray arrayWithArray:result];
}

- (NSArray *)_xy_recurrenceAllSubelement
{
    NSMutableArray *all = @[].mutableCopy;
    void (^getSubViewsBlock)(id current) = ^(id current){
        if ([current isKindOfClass:[NSArray class]]) {
            [all addObjectsFromArray:[(NSArray *)current _xy_recurrenceAllSubelement]];
        } else {
            [all xy_safeAdd:current];
        }
    };
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        getSubViewsBlock(obj);
    }];
    return [NSArray arrayWithArray:all];
}

- (NSArray *)xy_flatMap:(id  _Nonnull (^)(id _Nonnull))block {
    return [[self _xy_recurrenceAllSubelement] xy_map:block];
}

- (id  _Nonnull (^)(NSUInteger))xy_safeIdx
{
    __weak typeof(self) weakSelf = self;
    id (^block)(NSUInteger index) = ^(NSUInteger index) {
        return (weakSelf.count-1)<index ? nil : weakSelf[index];
    };
    return block;
}

@end


@implementation NSMutableArray (XYChart)

- (void)xy_safeAdd:(id)obj
{
    if (obj) {
        [self addObject:obj];
    }
}

@end
