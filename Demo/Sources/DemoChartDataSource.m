#import "DemoChartDataSource.h"
#import <XYChart/XYChartItem.h>

@interface DemoChartDataSource ()

@property (nonatomic, copy) NSArray<NSString *> *rowTitles;
@property (nonatomic, copy, readwrite) NSArray<NSString *> *seriesNames;
@property (nonatomic, copy, readwrite) NSArray<UIColor *> *palette;
@property (nonatomic, copy, readwrite) NSString *unitSuffix;

@end

@implementation DemoChartDataSource

- (instancetype)initWithValues:(NSArray<NSArray<NSNumber *> *> *)values
                     rowTitles:(NSArray<NSString *> *)rowTitles
                   seriesNames:(NSArray<NSString *> *)seriesNames
                       palette:(NSArray<UIColor *> *)palette
                    unitSuffix:(NSString *)unitSuffix
                  baseDuration:(NSTimeInterval)baseDuration
                  durationStep:(NSTimeInterval)durationStep
{
    NSMutableArray<NSArray<id<XYChartItem>> *> *dataList = [NSMutableArray array];

    [values enumerateObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull sectionValues, NSUInteger section, BOOL * _Nonnull stop) {
        UIColor *sectionColor = palette[section % palette.count];
        NSString *seriesName = section < seriesNames.count ? seriesNames[section] : [NSString stringWithFormat:@"Series %lu", (unsigned long)(section + 1)];
        NSMutableArray<id<XYChartItem>> *items = [NSMutableArray array];

        [sectionValues enumerateObjectsUsingBlock:^(NSNumber * _Nonnull value, NSUInteger row, BOOL * _Nonnull innerStop) {
            XYChartItem *item = [[XYChartItem alloc] init];
            NSString *rowTitle = row < rowTitles.count ? rowTitles[row] : [NSString stringWithFormat:@"P%lu", (unsigned long)(row + 1)];
            item.value = value;
            item.color = sectionColor;
            item.duration = MAX(baseDuration, 0.12) + (durationStep * section);
            NSString *valueText = unitSuffix.length > 0 ? [NSString stringWithFormat:@"%@%@", value, unitSuffix] : value.stringValue;
            item.showName = [NSString stringWithFormat:@"%@ | %@ | %@", seriesName, rowTitle, valueText];
            [items addObject:item];
        }];

        [dataList addObject:[items copy]];
    }];

    self = [super initWithDataList:[dataList copy]];
    if (self) {
        _rowTitles = [rowTitles copy];
        _seriesNames = [seriesNames copy];
        _palette = [palette copy];
        _unitSuffix = [unitSuffix copy];
    }
    return self;
}

+ (NSArray<NSString *> *)titlesWithPrefix:(NSString *)prefix count:(NSUInteger)count start:(NSUInteger)start
{
    NSMutableArray<NSString *> *titles = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger idx = 0; idx < count; idx++) {
        [titles addObject:[NSString stringWithFormat:@"%@%lu", prefix, (unsigned long)(start + idx)]];
    }
    return [titles copy];
}

+ (instancetype)weeklyLineDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@28, @34, @41, @52, @49, @63, @74],
        @[@19, @26, @34, @40, @47, @54, @62]
    ]
                                                                    rowTitles:@[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"]
                                                                  seriesNames:@[@"Engagement", @"Conversion"]
                                                                      palette:@[
        [UIColor systemBlueColor],
        [UIColor systemTealColor]
    ]
                                                                    unitSuffix:@"%"
                                                                  baseDuration:0.22
                                                                  durationStep:0.03];
    dataSource.configuration.numberOfLevels = 5;
    dataSource.configuration.autoSizingRowWidth = YES;
    return dataSource;
}

+ (instancetype)monthlyLineDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@32, @36, @39, @45, @52, @58, @61, @67, @72, @76, @82, @88],
        @[@24, @29, @31, @38, @44, @49, @53, @57, @63, @68, @71, @75],
        @[@18, @22, @27, @31, @36, @43, @48, @54, @59, @66, @73, @79]
    ]
                                                                    rowTitles:@[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"]
                                                                  seriesNames:@[@"North", @"West", @"Online"]
                                                                      palette:@[
        [UIColor systemIndigoColor],
        [UIColor systemGreenColor],
        [UIColor systemOrangeColor]
    ]
                                                                    unitSuffix:@"k"
                                                                  baseDuration:0.30
                                                                  durationStep:0.05];
    dataSource.configuration.numberOfLevels = 6;
    dataSource.configuration.autoSizingRowWidth = NO;
    dataSource.configuration.rowWidth = 62.0;
    return dataSource;
}

+ (instancetype)velocityLineDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@112, @109, @104, @96, @92, @88, @90, @86, @81, @79, @83, @77, @74, @71, @69, @66]
    ]
                                                                    rowTitles:[self titlesWithPrefix:@"H" count:16 start:8]
                                                                  seriesNames:@[@"Latency"]
                                                                      palette:@[
        [UIColor systemPinkColor]
    ]
                                                                    unitSuffix:@"ms"
                                                                  baseDuration:0.18
                                                                  durationStep:0.0];
    dataSource.configuration.numberOfLevels = 5;
    dataSource.configuration.autoSizingRowWidth = NO;
    dataSource.configuration.rowWidth = 52.0;
    return dataSource;
}

+ (instancetype)groupedBarDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@18, @23, @29, @34, @38, @44],
        @[@14, @19, @24, @30, @35, @41],
        @[@11, @16, @22, @26, @32, @37],
        @[@8, @13, @17, @21, @27, @31]
    ]
                                                                    rowTitles:@[@"S1", @"S2", @"S3", @"S4", @"S5", @"S6"]
                                                                  seriesNames:@[@"Starter", @"Growth", @"Scale", @"Plus"]
                                                                      palette:@[
        [UIColor systemOrangeColor],
        [UIColor systemPinkColor],
        [UIColor systemGreenColor],
        [UIColor systemBlueColor]
    ]
                                                                    unitSuffix:@"%"
                                                                  baseDuration:0.3
                                                                  durationStep:0.05];
    dataSource.configuration.numberOfLevels = 6;
    dataSource.configuration.autoSizingRowWidth = NO;
    dataSource.configuration.rowWidth = 86.0;
    return dataSource;
}

+ (instancetype)forecastBarDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@42, @46, @51, @57, @61, @68, @74, @80],
        @[@40, @44, @49, @54, @60, @64, @70, @77]
    ]
                                                                    rowTitles:@[@"Q1", @"Q2", @"Q3", @"Q4", @"Q5", @"Q6", @"Q7", @"Q8"]
                                                                  seriesNames:@[@"Actual", @"Plan"]
                                                                      palette:@[
        [UIColor systemRedColor],
        [UIColor systemTealColor]
    ]
                                                                    unitSuffix:@"M"
                                                                  baseDuration:0.46
                                                                  durationStep:0.08];
    dataSource.configuration.numberOfLevels = 5;
    dataSource.configuration.autoSizingRowWidth = YES;
    return dataSource;
}

+ (instancetype)launchBarDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@12, @18, @27, @35, @42, @48, @56, @61, @68, @74]
    ]
                                                                    rowTitles:[self titlesWithPrefix:@"D" count:10 start:1]
                                                                  seriesNames:@[@"Lift"]
                                                                      palette:@[
        [UIColor systemIndigoColor]
    ]
                                                                    unitSuffix:@"%"
                                                                  baseDuration:0.24
                                                                  durationStep:0.0];
    dataSource.configuration.numberOfLevels = 5;
    dataSource.configuration.autoSizingRowWidth = NO;
    dataSource.configuration.rowWidth = 56.0;
    return dataSource;
}

- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index
{
    NSString *title = index < self.rowTitles.count ? self.rowTitles[index] : [NSString stringWithFormat:@"%lu", (unsigned long)(index + 1)];
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:11 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor secondaryLabelColor]
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue
{
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:10 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName: [UIColor tertiaryLabelColor]
    };
    NSString *title = self.unitSuffix.length > 0 ? [NSString stringWithFormat:@"%.0f%@", sectionValue, self.unitSuffix] : [NSString stringWithFormat:@"%.0f", sectionValue];
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

@end
