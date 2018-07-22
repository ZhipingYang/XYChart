//
//  XYChartGroup.m
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartGroup.h"
#import "XYChartItem.h"

@interface XYChartGroup()
{
    NSAttributedString *(^_configYLabelBlock)(CGFloat value);
}
@property (nonatomic) XYChartStyle chartStyle;

@end

@implementation XYChartGroup

- (instancetype)initWithStyle:(XYChartStyle)style
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

- (instancetype)init
{
    return [self initWithStyle:XYChartStyleLine];
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
        
        _names = [self.dataList.firstObject xy_map:^id(id<XYChartItem> obj, NSUInteger idx) {
            NSMutableAttributedString *mStr = [NSMutableAttributedString new];
            for (int i=0; i<self.dataList.count; i++) {
                id <XYChartItem>item = self.dataList.xy_safeIdx(i).xy_safeIdx(idx);
                [mStr appendAttributedString:block(item.name, item.color)];
                if (i!=self.dataList.count-1) {
                    [mStr appendAttributedString:block(@":",[UIColor lightGrayColor])];
                }
            }
            return mStr;
        }];
    }
    return _names;
}

- (void)setDataList:(NSArray<NSArray<id<XYChartItem>> *> *)dataList
{
    _dataList = dataList;
    NSUInteger count = _dataList.firstObject.count;
    [dataList enumerateObjectsUsingBlock:^(NSArray<id<XYChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(obj.count == count, @"dataList的子数组个数不一致");
    }];
}

@end







