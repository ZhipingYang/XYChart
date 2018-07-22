//
//  XYBarChart.h
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

@interface XYBarChart : UIView<UUChartContainer>

@property (nonatomic, strong) id<UUChartGroup>chartGroup;

@end
