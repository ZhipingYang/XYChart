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
    
    if (_dataList.count>0 & _dataList.firstObject.count>0) {
        NSArray <XYChartItem *>*numbers = [_dataList xy_flatMap:^id _Nonnull(NSArray<id<XYChartItem>> * _Nonnull obj) {
            return obj;
        }];
        //TODO: if XYChartItem's value keypath was renamed, wow... sad story!!!
        NSNumber * max = [numbers valueForKeyPath:@"value.@max.intValue"];
        NSNumber * min = [numbers valueForKeyPath:@"value.@min.intValue"];
        if (max > min) {
            CGFloat distance = (max.floatValue - min.floatValue) * 0.2;
            self.range = XYRangeMake(min.floatValue - distance, max.floatValue + distance);
        }
    }
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







