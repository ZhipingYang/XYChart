//
//  XYChart.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYChart : UIView<XYChartContainer>

@property (nonatomic, strong, nullable) id<XYChartDataSource> chartGroup;

- (instancetype)initWithFrame:(CGRect)frame chartGroup:(nullable id<XYChartDataSource>)chartGroup;

@end

NS_ASSUME_NONNULL_END
