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
    
}

@property (nonatomic, strong) NSArray <NSArray <id<XYChartItem>>*> *dataList;

@end

@implementation XYChartDataSourceItem

static XYRange XYChartAutoRangeWithItems(NSArray<NSArray<id<XYChartItem>> *> *dataList)
{
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = -CGFLOAT_MAX;
    __block BOOL hasValue = NO;
    
    [dataList enumerateObjectsUsingBlock:^(NSArray<id<XYChartItem>> * _Nonnull sectionItems, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionItems enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull item, NSUInteger subIdx, BOOL * _Nonnull subStop) {
            CGFloat value = item.value.doubleValue;
            minValue = MIN(minValue, value);
            maxValue = MAX(maxValue, value);
            hasValue = YES;
        }];
    }];
    
    if (!hasValue) {
        return XYRangeMake(0, 100);
    }
    CGFloat distance = (maxValue - minValue) * 0.2;
    if (distance <= 0) {
        distance = MAX(fabs(maxValue) * 0.2, 1);
    }
    return XYRangeMake(minValue - distance, maxValue + distance);
}

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

- (void)setDataList:(NSArray<NSArray<id<XYChartItem>> *> *)dataList
{
    _dataList = dataList;
    NSUInteger count = _dataList.firstObject.count;
    [dataList enumerateObjectsUsingBlock:^(NSArray<id<XYChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(obj.count == count, @"dataList的子数组个数不一致");
    }];
    
    if (_dataList.count > 0 && _dataList.firstObject.count > 0) {
        self.range = XYChartAutoRangeWithItems(_dataList);
    }
}

#pragma mark - XYChartDataSource

- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart
{
    return self.dataList.count;
}

- (NSUInteger)numberOfRowsInChart:(XYChart *)chart
{
    NSArray <NSNumber *>*numers = [_dataList xy_map:^id _Nonnull(NSArray<id<XYChartItem>> * _Nonnull obj) {
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
    NSArray <NSString *>* names = [self.dataList xy_map:^id _Nonnull(NSArray<id<XYChartItem>> * _Nonnull obj) {
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






