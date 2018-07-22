//
//  UULineChart.h
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//



#import "UUChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UULineChart : UIView<UUChartContainer>

@property (nonatomic, strong) id<UUChartGroup>chartGroup;

- (nullable NSArray <NSValue *>*)getPoints;

@end

NS_ASSUME_NONNULL_END
