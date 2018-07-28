//
//  XYChart.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#include "XYChartProtocol.h"

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface XYChart : UIView<XYChartContainer>

@property (nonatomic, weak, nullable) id<XYChartDataSource> dataSource;
@property (nonatomic, weak, nullable) id<XYChartDelegate> delegate;

@property (nonatomic, readonly) XYChartType chartType;

- (instancetype)initWithFrame:(CGRect)frame chartType:(XYChartType)chartType;

@end

NS_ASSUME_NONNULL_END
