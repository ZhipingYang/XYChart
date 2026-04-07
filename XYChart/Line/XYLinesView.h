//
//  UULines.h
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

@class XYChart;
@interface XYLinesView : UIView<XYChartContainer>

@property (nonatomic, weak, readonly) XYChart *chartView;
@property (nonatomic, copy) NSArray<NSNumber *> *segmentAnimationDelays;

@end
