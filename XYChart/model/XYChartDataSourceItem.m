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
@property (nonatomic, strong) XYChartConfiguration *configuration;

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
    return XYChartExpandedRange(minValue, maxValue);
}

- (instancetype)initWithDataList:(NSArray <NSArray <id<XYChartItem>>*> *)dataList
{
    self = [super init];
    if (self) {
        _configuration = [XYChartConfiguration defaultConfiguration];
        _configuration.automaticallyAdjustsVisibleRange = YES;
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
    NSUInteger expectedCount = _dataList.firstObject.count;
    [dataList enumerateObjectsUsingBlock:^(NSArray<id<XYChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.count != expectedCount) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"dataList的子数组个数不一致"
                                         userInfo:nil];
        }
    }];
    
    if (self.configuration.automaticallyAdjustsVisibleRange && _dataList.count > 0 && _dataList.firstObject.count > 0) {
        self.configuration.visibleRange = XYChartAutoRangeWithItems(_dataList);
    }
}

- (void)setRange:(XYRange)range
{
    self.configuration.visibleRange = range;
    self.configuration.automaticallyAdjustsVisibleRange = NO;
}

- (XYRange)range
{
    return self.configuration.visibleRange;
}

- (void)setNumberOfLevels:(NSUInteger)numberOfLevels
{
    self.configuration.numberOfLevels = numberOfLevels;
}

- (NSUInteger)numberOfLevels
{
    return self.configuration.numberOfLevels;
}

- (void)setWidthOfRow:(CGFloat)widthOfRow
{
    self.configuration.rowWidth = widthOfRow;
}

- (CGFloat)widthOfRow
{
    return self.configuration.rowWidth;
}

- (void)setAutoSizingRowWidth:(BOOL)autoSizingRowWidth
{
    self.configuration.autoSizingRowWidth = autoSizingRowWidth;
}

- (BOOL)autoSizingRowWidth
{
    return self.configuration.autoSizingRowWidth;
}

#pragma mark - XYChartDataSource

- (XYChartConfiguration *)chartConfiguration:(XYChart *)chart
{
    return self.configuration;
}

- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart
{
    return self.dataList.count;
}

- (NSUInteger)numberOfRowsInChart:(XYChart *)chart
{
    __block NSUInteger maxRowCount = 0;
    [self.dataList enumerateObjectsUsingBlock:^(NSArray<id<XYChartItem>> * _Nonnull sectionItems, NSUInteger idx, BOOL * _Nonnull stop) {
        maxRowCount = MAX(maxRowCount, sectionItems.count);
    }];
    return maxRowCount;
}

- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index
{
    NSMutableArray<NSString *> *names = [NSMutableArray arrayWithCapacity:self.dataList.count];
    [self.dataList enumerateObjectsUsingBlock:^(NSArray<id<XYChartItem>> * _Nonnull sectionItems, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = sectionItems.xy_safeIdx(index).value.stringValue;
        [names addObject:name.length > 0 ? name : @"unknown"];
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
    return self.configuration.visibleRange;
}

- (NSUInteger)numberOfLevelInChart:(XYChart *)chart
{
    return self.configuration.numberOfLevels;
}

- (CGFloat)rowWidthOfChart:(XYChart *)chart
{
    return self.configuration.rowWidth;
}

- (BOOL)autoSizingRowInChart:(XYChart *)chart
{
    return self.configuration.autoSizingRowWidth;
}

@end


