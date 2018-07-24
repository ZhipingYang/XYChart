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
@property (nonatomic) NSUInteger section;
@property (nonatomic) NSUInteger row;

@end

@implementation ChartGroup

- (instancetype)initWithStyle:(XYChartStyle)style section:(NSUInteger)section row:(NSUInteger)row
{
    self = [self initWithStyle:style];
    if (self) {
        _section = section;
        _row = row;
    }
    return self;
}
- (instancetype)initWithStyle:(XYChartStyle)style section:(NSUInteger)section row:(NSUInteger)row width:(CGFloat)width
{
    self = [self initWithStyle:style];
    if (self) {
        _section = section;
        _row = row;
        self.widthOfRow = width;
        self.autoSizingRowWidth = NO;
    }
    return self;
}

- (NSArray<NSArray<id<XYChartItem>> *> *)dataList
{
    if (!_dataList) {
        _dataList = [[self randomSection:_section row:_row] xy_map:^id(NSArray<NSString *> *obj1, NSUInteger idx1) {
            return [obj1 xy_map:^id(NSString *obj, NSUInteger idx) {
                XYChartItem *item = [[XYChartItem alloc] init];
                item.percent = (obj.floatValue-self.minValue)/(self.maxValue-self.minValue);
                if (self.section==1 && self.row>=7) {
                    item.color = [UIColor xy_rainBow:idx];
                } else {
                    item.color = [UIColor xy_random];
                }
                item.duration = 0.3;
                item.name = obj;
                return item;
            }];
        }];
        // 更新其他
        _names = nil;
        [self names];
    }
    return _dataList;
}

#pragma mark - helper

- (NSArray <NSString *>*)randomStrings:(NSUInteger)count
{
    NSMutableArray <NSString *>*mArr = @[].mutableCopy;
    for (int i=0; i<count; i++) {
        NSInteger num = arc4random()%(NSInteger)([self maxValue]-[self minValue])*0.6;
        [mArr addObject:@(num+[self minValue]+([self maxValue]-[self minValue])*0.2).stringValue];
    }
    return [NSArray arrayWithArray:mArr];
}
- (NSArray <NSArray<NSString *>*>*)randomSection:(NSUInteger)section row:(NSUInteger)row
{
    NSMutableArray <NSArray<NSString *>*>*mArr = @[].mutableCopy;
    for (int i=0; i<section; i++) {
        [mArr addObject:[self randomStrings:row]];
    }
    return [NSArray arrayWithArray:mArr];
}

@end
