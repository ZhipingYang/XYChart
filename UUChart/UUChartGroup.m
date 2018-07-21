//
//  UUChartGroup.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUChartGroup.h"
#import "UUChartItem.h"
#import "NSArray+UUChart.h"

@interface UUChartGroup()

@property (nonatomic) UUChartStyle chartStyle;

@property (nonatomic, strong) NSArray <NSArray <id<UUChartItem>>*> *dataList;

@property (nonatomic, strong) NSArray <NSAttributedString *> *names;

@property (nonatomic, copy) NSAttributedString *(^configYLabelBlock)(CGFloat value);

@end

@implementation UUChartGroup

- (instancetype)initWithTyle:(UUChartStyle)style
{
    self = [super init];
    if (self) {
        self.chartStyle = style;
    }
    return self;
}

- (CGFloat)minValue
{
    return 5;
}

- (CGFloat)maxValue
{
    return 555;
}

- (NSUInteger)ySectionNumber
{
    return 5;
}

- (CGFloat)xSectionWidth
{
    return 80;
}

- (NSAttributedString *(^)(CGFloat))configYLabelBlock
{
    if (!_configYLabelBlock) {
        NSAttributedString * (^block)(CGFloat value) = ^(CGFloat value) {
            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.f",value]
                                                   attributes:
                    @{
                      NSFontAttributeName: [UIFont systemFontOfSize:10],
                      NSForegroundColorAttributeName: [UIColor lightGrayColor],
                      }
                    ];
        };
        _configYLabelBlock = block;
    }
    return _configYLabelBlock;
}

- (BOOL)autoSizeX
{
    return NO;
}

- (NSArray<NSAttributedString *> *)names
{
    if (!_names) {
        NSAttributedString *(^block)(NSString *str, UIColor *color) = ^(NSString *str, UIColor *color) {
            return [[NSMutableAttributedString alloc] initWithString:str
                                                          attributes:
                    @{
                      NSFontAttributeName: [UIFont systemFontOfSize:10],
                      NSForegroundColorAttributeName: color,
                      }];
        };
        
        _names = [self.dataList.firstObject uu_map:^id(id<UUChartItem> obj, NSUInteger idx) {
            NSMutableAttributedString *mStr = [NSMutableAttributedString new];
            for (int i=0; i<self.dataList.count; i++) {
                id <UUChartItem>item = self.dataList[i][idx];
                [mStr appendAttributedString:block(item.name, item.color)];
                if (i!=self.dataList.count-1) {
                    [mStr appendAttributedString:block(@":",[UIColor separatedColor])];
                }
            }
            return mStr;
        }];
    }
    return _names;
}

- (NSArray<NSArray<id<UUChartItem>> *> *)dataList
{
    if (!_dataList) {
        _dataList = [[self randomSection:1 row:10] uu_map:^id(NSArray<NSString *> *obj1, NSUInteger idx1) {
            return [obj1 uu_map:^id(NSString *obj, NSUInteger idx) {
                UUChartItem *item = [[UUChartItem alloc] init];
                item.percent = (obj.floatValue-self.minValue)/(self.maxValue-self.minValue);
                item.color = [UIColor random];
                item.duration = 0.3;
                item.name = obj;
                return item;
            }];
        }];
    }
    return _dataList;
}

#pragma mark - helper

- (NSArray <NSString *>*)randomStrings:(NSUInteger)count
{
    NSMutableArray <NSString *>*mArr = @[].mutableCopy;
    for (int i=0; i<count; i++) {
        NSInteger num = arc4random()%(NSInteger)([self maxValue]-[self minValue]);
        [mArr addObject:@(num+[self minValue]).stringValue];
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






