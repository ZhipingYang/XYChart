#import "DemoChartDataSource.h"
#import <XYChart/XYChartItem.h>

@interface DemoChartDataSource ()

@property (nonatomic, copy) NSArray<NSString *> *rowTitles;

@end

@implementation DemoChartDataSource

- (instancetype)initWithValues:(NSArray<NSArray<NSNumber *> *> *)values
                     rowTitles:(NSArray<NSString *> *)rowTitles
                       palette:(NSArray<UIColor *> *)palette
{
    NSMutableArray<NSArray<id<XYChartItem>> *> *dataList = [NSMutableArray array];

    [values enumerateObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull sectionValues, NSUInteger section, BOOL * _Nonnull stop) {
        UIColor *sectionColor = palette[section % palette.count];
        NSMutableArray<id<XYChartItem>> *items = [NSMutableArray array];

        [sectionValues enumerateObjectsUsingBlock:^(NSNumber * _Nonnull value, NSUInteger row, BOOL * _Nonnull innerStop) {
            XYChartItem *item = [[XYChartItem alloc] init];
            NSString *rowTitle = row < rowTitles.count ? rowTitles[row] : [NSString stringWithFormat:@"P%lu", (unsigned long)(row + 1)];
            item.value = value;
            item.color = sectionColor;
            item.duration = 0.55 + (0.05 * section);
            item.showName = [NSString stringWithFormat:@"Series %lu | %@ | %@", (unsigned long)(section + 1), rowTitle, value];
            [items addObject:item];
        }];

        [dataList addObject:[items copy]];
    }];

    self = [super initWithDataList:[dataList copy]];
    if (self) {
        _rowTitles = [rowTitles copy];
    }
    return self;
}

+ (instancetype)weeklyLineDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@18, @28, @35, @49, @44, @61, @73],
        @[@12, @22, @31, @38, @50, @57, @66]
    ]
                                                                    rowTitles:@[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"]
                                                                      palette:@[
        [UIColor systemBlueColor],
        [UIColor systemTealColor]
    ]];
    dataSource.configuration.numberOfLevels = 5;
    dataSource.configuration.autoSizingRowWidth = YES;
    return dataSource;
}

+ (instancetype)monthlyLineDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@22, @25, @29, @36, @44, @48, @54, @59, @63, @70, @75, @82],
        @[@18, @21, @26, @33, @38, @42, @47, @53, @57, @61, @67, @71]
    ]
                                                                    rowTitles:@[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"]
                                                                      palette:@[
        [UIColor systemIndigoColor],
        [UIColor systemGreenColor]
    ]];
    dataSource.configuration.numberOfLevels = 6;
    dataSource.configuration.autoSizingRowWidth = NO;
    dataSource.configuration.rowWidth = 54.0;
    return dataSource;
}

+ (instancetype)groupedBarDemo
{
    DemoChartDataSource *dataSource = [[DemoChartDataSource alloc] initWithValues:@[
        @[@28, @34, @39, @45, @53, @57, @62, @68],
        @[@25, @31, @37, @43, @48, @55, @60, @65],
        @[@21, @27, @35, @40, @46, @51, @59, @63]
    ]
                                                                    rowTitles:@[@"W1", @"W2", @"W3", @"W4", @"W5", @"W6", @"W7", @"W8"]
                                                                      palette:@[
        [UIColor systemOrangeColor],
        [UIColor systemPinkColor],
        [UIColor systemGreenColor]
    ]];
    dataSource.configuration.numberOfLevels = 5;
    dataSource.configuration.autoSizingRowWidth = NO;
    dataSource.configuration.rowWidth = 64.0;
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
    NSString *title = [NSString stringWithFormat:@"%.0f", sectionValue];
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

@end
