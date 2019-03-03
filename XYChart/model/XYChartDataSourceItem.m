//
//  XYChartDataSource.m
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartDataSourceItem.h"
#import "XYChartItem.h"

@interface XYChartDataSourceItem()
{
    NSAttributedString *(^_configYLabelBlock)(CGFloat value);
    NSArray<NSAttributedString *> *_names;
}

@property (nonatomic, strong) NSArray <NSArray <id<XYChartItem>>*> *dataList;

@end

@implementation XYChartDataSourceItem

- (instancetype)initWithDataList:(NSArray <NSArray <id<XYChartItem>>*> *)dataList
{
    self = [super init];
    if (self) {
        self.range = XYRangeMake(0, 100);
        self.numberOfLevels = 5;
        self.widthOfRow = 60;
        self.autoSizingRowWidth = YES;
        self.dataList = dataList;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDataList:@[]];
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
                [mStr appendAttributedString:block(item.showName, item.color)];
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

#pragma mark - XYChartDataSource

- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart
{
    return self.dataList.count;
}

- (NSUInteger)numberOfRowsInChart:(XYChart *)chart
{
    NSArray <NSNumber *>*numers = [_dataList xy_map:^id _Nonnull(NSArray<id<XYChartItem>> * _Nonnull obj, NSUInteger idx) {
        return [NSNumber numberWithInt:(int)obj.count];
    }];
    __block NSInteger number = 0;
    [numers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.intValue > number) {
            number = obj.intValue;
        }
    }];
    return number;
}

- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index
{
    NSArray <NSString *>* names = [self.dataList xy_map:^id _Nonnull(NSArray<id<XYChartItem>> * _Nonnull obj, NSUInteger idx) {
        return obj.xy_safeIdx(index).value.stringValue ?: @"unkown";
    }];
    NSString *showName = [names componentsJoinedByString:@":"];
    NSDictionary *dic = @{
                          NSFontAttributeName: [UIFont systemFontOfSize:10],
                          NSForegroundColorAttributeName: [UIColor xy_separatedColor]
                          };
    return [[NSMutableAttributedString alloc] initWithString:showName attributes:dic];
}

- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.f",sectionValue]
                                           attributes:
            @{
              NSFontAttributeName: [UIFont systemFontOfSize:10],
              NSForegroundColorAttributeName: [UIColor lightGrayColor],
              }
            ];
}

- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index
{
    return self.dataList.xy_safeIdx(index.section).xy_safeIdx(index.row);
}

- (XYRange)visibleRangeInChart:(XYChart *)chart
{
    return self.range;
}

- (NSUInteger)numberOfLevelInChart:(XYChart *)chart
{
    return self.numberOfLevels;
}

- (CGFloat)rowWidthOfChart:(XYChart *)chart
{
    return self.widthOfRow;
}

- (BOOL)autoSizingRowInChart:(XYChart *)chart
{
    return self.autoSizingRowWidth;
}

@end







