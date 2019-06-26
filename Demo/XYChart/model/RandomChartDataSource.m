//
//  ChartGroup.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "RandomChartDataSource.h"
#import <XYChart/XYChartItem.h>

@implementation RandomChartDataSource

- (instancetype)initWithStyle:(XYChartType)type section:(NSUInteger)section row:(NSUInteger)row
{
    self = [self initWithDataList:[RandomChartDataSource getDataListWithSection:section row:row]];
    if (self) {
        _type = type;
        self.autoSizingRowWidth = YES;
    }
    return self;
}

- (instancetype)initWithStyle:(XYChartType)type section:(NSUInteger)section row:(NSUInteger)row width:(CGFloat)width
{
    self = [self initWithDataList:[RandomChartDataSource getDataListWithSection:section row:row]];
    if (self) {
        _type = type;
        self.widthOfRow = width;
        self.autoSizingRowWidth = NO;
    }
    return self;
}

+ (NSArray<NSArray<id<XYChartItem>> *> *)getDataListWithSection:(NSUInteger)section row:(NSUInteger)row
{
    NSArray * dataList = [[self randomSection:section row:row] xy_map:^id(NSArray<NSNumber *> *obj1) {
        return [obj1 xy_map:^id(NSNumber *obj) {
            XYChartItem *item = [[XYChartItem alloc] init];
            item.value = obj;
            item.color = [UIColor xy_random];
            item.duration = 0.3;
            item.showName = obj.stringValue;
            return item;
        }];
    }];
    
    return dataList;
}

#pragma mark - helper

+ (NSArray <NSNumber *>*)randomStrings:(NSUInteger)count
{
    NSMutableArray <NSNumber *>*mArr = @[].mutableCopy;
    for (int i=0; i<count; i++) {
        NSInteger num = arc4random()%100;
        [mArr addObject:@(num)];
    }
    return [NSArray arrayWithArray:mArr];
}

+ (NSArray <NSArray<NSNumber *>*>*)randomSection:(NSUInteger)section row:(NSUInteger)row
{
    NSMutableArray <NSArray<NSNumber *>*>*mArr = @[].mutableCopy;
    for (int i=0; i<section; i++) {
        [mArr addObject:[self randomStrings:row]];
    }
    return [NSArray arrayWithArray:mArr];
}

@end

