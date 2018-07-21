//
//  UUChartGroup.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUChartGroup.h"
#import "UUChartItem.h"

@interface UUChartGroup()
{
    NSUInteger _section;
    NSUInteger _row;
    NSAttributedString *(^_configYLabelBlock)(CGFloat value);
}
@property (nonatomic) UUChartStyle chartStyle;

@end

@implementation UUChartGroup

- (instancetype)initWithStyle:(UUChartStyle)style
{
    self = [super init];
    if (self) {
        self.chartStyle = style;
        self.maxValue = 100;
        self.minValue = 0;
        self.ySectionNumber = 5;
        self.xSectionWidth = 60;
        self.autoSizeX = YES;
    }
    return self;
}
- (instancetype)initWithStyle:(UUChartStyle)style section:(NSUInteger)section row:(NSUInteger)row
{
    self = [self initWithStyle:style];
    if (self) {
        _section = section;
        _row = row;
    }
    return self;
}
- (instancetype)initWithStyle:(UUChartStyle)style section:(NSUInteger)section row:(NSUInteger)row width:(CGFloat)width
{
    self = [self initWithStyle:style];
    if (self) {
        _section = section;
        _row = row;
        self.xSectionWidth = width;
        self.autoSizeX = NO;
    }
    return self;
}
- (instancetype)init
{
    return [self initWithStyle:UUChartStyleLine];
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
        self.configYLabelBlock = block;
    }
    return _configYLabelBlock;
}

- (void)setConfigYLabelBlock:(NSAttributedString *(^)(CGFloat))configYLabelBlock
{
    _configYLabelBlock = [configYLabelBlock copy];
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
                id <UUChartItem>item = self.dataList.safeIndex(i).safeIndex(idx);
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
        _dataList = [[self randomSection:_section row:_row] uu_map:^id(NSArray<NSString *> *obj1, NSUInteger idx1) {
            return [obj1 uu_map:^id(NSString *obj, NSUInteger idx) {
                UUChartItem *item = [[UUChartItem alloc] init];
                item.percent = (obj.floatValue-self.minValue)/(self.maxValue-self.minValue);
                item.color = [UIColor random];
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







