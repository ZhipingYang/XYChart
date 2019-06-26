//
//  UUBar.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBarView : UIView

@property (nonatomic, readonly) id<XYChartItem> chartItem;
@property (nonatomic, readonly) XYRange range;

@property (nonatomic, strong) CAShapeLayer * line;
@property (nonatomic, copy) void(^handleBlock)(XYBarView *view);

- (void)setChartItem:(id<XYChartItem> _Nonnull)chartItem range:(XYRange)range;

@end

NS_ASSUME_NONNULL_END
