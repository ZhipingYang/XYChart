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

@property (nonatomic, strong) id<XYChartItem> chartItem;

@property (nonatomic, strong) CAShapeLayer * line;

- (void)setChartItem:(id<XYChartItem> _Nonnull)chartItem animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
