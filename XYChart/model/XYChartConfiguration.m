//
//  XYChartConfiguration.m
//  XYChart
//
//  Created by Codex on 2026/4/7.
//

#import "XYChartConfiguration.h"

@implementation XYChartConfiguration

+ (instancetype)defaultConfiguration
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _visibleRange = XYRangeMake(0, 100);
        _automaticallyAdjustsVisibleRange = NO;
        _numberOfLevels = 5;
        _rowWidth = 60;
        _autoSizingRowWidth = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    XYChartConfiguration *configuration = [[[self class] allocWithZone:zone] init];
    configuration.visibleRange = self.visibleRange;
    configuration.automaticallyAdjustsVisibleRange = self.automaticallyAdjustsVisibleRange;
    configuration.numberOfLevels = self.numberOfLevels;
    configuration.rowWidth = self.rowWidth;
    configuration.autoSizingRowWidth = self.autoSizingRowWidth;
    return configuration;
}

@end
