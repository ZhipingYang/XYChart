//
//  UUChartView.h
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "UUChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUChartView : UIView<UUChartContainer>

@property (nonatomic, strong, nullable) id<UUChartGroup> chartGroup;

- (instancetype)initWithFrame:(CGRect)frame chartGroup:(nullable id<UUChartGroup>)chartGroup;

@end

NS_ASSUME_NONNULL_END
