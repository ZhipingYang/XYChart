#import <XYChart/XYChartDataSourceItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoChartDataSource : XYChartDataSourceItem

+ (instancetype)weeklyLineDemo;
+ (instancetype)monthlyLineDemo;
+ (instancetype)groupedBarDemo;

@end

NS_ASSUME_NONNULL_END
