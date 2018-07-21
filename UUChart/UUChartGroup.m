//
//  UUChartGroup.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUChartGroup.h"
#import "UUChartItem.h"
#import "NSArray+Map.h"

@interface UUChartGroup()

@property (nonatomic) UUChartStyle chartStyle;

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
    return 0;
}

- (CGFloat)maxValue
{
    return 100;
}

- (NSUInteger)ySectionNumber
{
    return 5;
}

- (NSUInteger)xSectionWidth
{
    return 50;
}

- (BOOL)autoSizeX
{
    return YES;
}

- (NSArray<NSAttributedString *> *)names
{
    NSAttributedString *(^block)(NSString *str) = ^(NSString *str) {
        return [[NSAttributedString alloc] initWithString:str
                                               attributes:
                @{
                  NSFontAttributeName: [UIFont systemFontOfSize:12],
                  NSStrokeColorAttributeName: [UIColor lightGrayColor]
                  }];
    };
    NSArray *arr =  [[self demoStrings] uu_map:^id(NSString *obj, NSUInteger idx) {
        return block([NSString stringWithFormat:@"%zd:%@",idx,obj]);
    }];
    return arr;
}

- (NSArray<NSArray<id<UUChartItem>> *> *)dataList
{
    return @[
             [[self demoStrings] uu_map:^id(NSString *obj, NSUInteger idx) {
                 UUChartItem *item = [[UUChartItem alloc] init];
                 item.percent = obj.floatValue/self.maxValue;
                 item.color = [UIColor redColor];
                 item.duration = 0.3;
                 return item;
             }],
             [[self demoStrings2] uu_map:^id(NSString *obj, NSUInteger idx) {
                 UUChartItem *item = [[UUChartItem alloc] init];
                 item.percent = obj.floatValue/self.maxValue;
                 item.color = [UIColor greenColor];
                 item.duration = 0.3;
                 return item;
             }]
             ];
}

- (NSArray <NSString *>*)demoStrings
{
    return @[@"23",@"42",@"25",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
}
- (NSArray <NSString *>*)demoStrings2
{
    return @[@"25",@"42",@"25",@"15",@"33",@"30",@"42",@"32",@"23",@"40",@"42"];
}

@end




