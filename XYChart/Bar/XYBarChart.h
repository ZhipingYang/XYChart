//
//  XYBarChart.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class XYChart;
@interface XYBarChart : UIView<XYChartContainer>

@property (nonatomic, weak, readonly) XYChart *chartView;

@end

NS_ASSUME_NONNULL_END
