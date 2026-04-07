#import <XYChart/XYChartDataSourceItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoChartDataSource : XYChartDataSourceItem

@property (nonatomic, copy, readonly) NSArray<NSString *> *seriesNames;
@property (nonatomic, copy, readonly) NSArray<UIColor *> *palette;
@property (nonatomic, copy, readonly) NSString *unitSuffix;

+ (instancetype)weeklyLineDemo;
+ (instancetype)monthlyLineDemo;
+ (instancetype)velocityLineDemo;
+ (instancetype)groupedBarDemo;
+ (instancetype)forecastBarDemo;
+ (instancetype)launchBarDemo;

@end

NS_ASSUME_NONNULL_END
