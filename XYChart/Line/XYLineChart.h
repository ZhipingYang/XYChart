//
//  XYLineChart.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//



#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYLineChart : UIView<XYChartContainer>

@property (nonatomic, strong) id<XYChartGroup>chartGroup;

@end

NS_ASSUME_NONNULL_END
