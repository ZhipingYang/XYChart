//
//  XYLineChart.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//



#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class XYChart;
@interface XYLineChart : UIView<XYChartContainer>

@property (nonatomic, weak, readonly) XYChart *chartView;
@property (nonatomic, weak, nullable) id<XYChartDataSource> dataSource;
@property (nonatomic, weak, nullable) id<XYChartDelegate> delegate;

- (instancetype)initWithChartView:(XYChart *)chartView;

@end

NS_ASSUME_NONNULL_END
