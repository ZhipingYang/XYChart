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

@property (nonatomic, readonly) id <XYChartItem>pre;
@property (nonatomic, readonly) id <XYChartItem>next;

+ (instancetype)layerWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range;

@end
