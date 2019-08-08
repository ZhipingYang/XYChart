//
//  XYLineGradientLayer.h
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XYChartProtocol.h"

@interface XYLineGradientLayer : CAGradientLayer

@property (nonatomic, readonly) id<XYChartItem> pre;
@property (nonatomic, readonly) id<XYChartItem> next;
@property (nonatomic, readonly) CAShapeLayer *shapeLayer;

+ (instancetype)layerWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range;

- (void)updateWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range;

- (void)startAnimate:(BOOL)animate;

@end
