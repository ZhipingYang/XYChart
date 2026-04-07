//
//  UULineItemView.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYLineItemView : UIView

@property (nonatomic, copy, nullable) void(^handleBlock)(XYLineItemView *view, NSArray<NSNumber *> *sectionIndexes, NSArray<id<XYChartItem>> *items, NSArray<CALayer *> *circles);

- (void)setItems:(NSArray <id<XYChartItem>>*)items name:(NSAttributedString *)name range:(XYRange)range;
- (void)showMenuForItems:(NSArray <id<XYChartItem>>*)items targetCircles:(NSArray<CALayer *> *)circles;
- (void)startAnimate:(BOOL)animate delay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
