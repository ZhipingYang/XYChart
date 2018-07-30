//
//  ChartGroup.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "ChartGroup.h"
#import "XYChartItem.h"

@interface ChartGroup()
{
    NSArray<NSArray<id<XYChartItem>> *> * _dataList;
    NSArray<NSAttributedString *> *_names;
}

@end

@implementation ChartGroup

- (instancetype)initWithStyle:(XYChartType)type section:(NSUInteger)section row:(NSUInteger)row
{
    self = [self initWithDataList:[ChartGroup getDataListWithSection:section row:row]];
    if (self) {
        _type = type;
        self.autoSizingRowWidth = YES;
    }
    return self;
}
- (instancetype)initWithStyle:(XYChartType)type section:(NSUInteger)section row:(NSUInteger)row width:(CGFloat)width
{
    self = [self initWithDataList:[ChartGroup getDataListWithSection:section row:row]];
    if (self) {
        _type = type;
        self.widthOfRow = width;
        self.autoSizingRowWidth = NO;
    }
    return self;
}

+ (NSArray<NSArray<id<XYChartItem>> *> *)getDataListWithSection:(NSUInteger)section row:(NSUInteger)row
{
    NSArray * dataList = [[self randomSection:section row:row] xy_map:^id(NSArray<NSString *> *obj1, NSUInteger idx1) {
        return [obj1 xy_map:^id(NSString *obj, NSUInteger idx) {
            XYChartItem *item = [[XYChartItem alloc] init];
            item.value = @(obj.integerValue);
            item.color = [UIColor xy_random];
            item.duration = 0.3;
            item.showName = obj;
            return item;
        }];
    }];
    
    return dataList;
}

#pragma mark - helper

+ (NSArray <NSString *>*)randomStrings:(NSUInteger)count
{
    NSMutableArray <NSString *>*mArr = @[].mutableCopy;
    for (int i=0; i<count; i++) {
        NSInteger num = arc4random()%100;
        [mArr addObject:@(num).stringValue];
    }
    return [NSArray arrayWithArray:mArr];
}
+ (NSArray <NSArray<NSString *>*>*)randomSection:(NSUInteger)section row:(NSUInteger)row
{
    NSMutableArray <NSArray<NSString *>*>*mArr = @[].mutableCopy;
    for (int i=0; i<section; i++) {
        [mArr addObject:[self randomStrings:row]];
    }
    return [NSArray arrayWithArray:mArr];
}

@end

