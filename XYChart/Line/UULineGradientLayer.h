//
//  UULineGradientLayer.h
//  UUChartView
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UUChartProtocol.h"

@interface UULineGradientLayer : CAGradientLayer

@property (nonatomic, readonly) id <UUChartItem>pre;
@property (nonatomic, readonly) id <UUChartItem>next;

+ (instancetype)layerWithPre:(id<UUChartItem>)pre next:(id<UUChartItem>)next;

@end
