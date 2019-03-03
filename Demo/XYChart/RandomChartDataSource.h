//
//  ChartGroup.h
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "XYChartDataSourceItem.h"

@interface RandomChartDataSource : XYChartDataSourceItem

@property (nonatomic, readonly) XYChartType type;

- (instancetype)initWithStyle:(XYChartType)type section:(NSUInteger)section row:(NSUInteger)row;

- (instancetype)initWithStyle:(XYChartType)type section:(NSUInteger)section row:(NSUInteger)row width:(CGFloat)width;

@end
