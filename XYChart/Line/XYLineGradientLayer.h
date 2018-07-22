//
//  XYLineGradientLayer.h
//  UUChartView
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XYChartProtocol.h"

@interface XYLineGradientLayer : CAGradientLayer

@property (nonatomic, readonly) id <UUChartItem>pre;
@property (nonatomic, readonly) id <UUChartItem>next;

+ (instancetype)layerWithPre:(id<UUChartItem>)pre next:(id<UUChartItem>)next;

@end
