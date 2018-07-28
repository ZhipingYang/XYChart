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

- (void)setItems:(NSArray <id<XYChartItem>>*)items range:(XYRange)range;

@end

NS_ASSUME_NONNULL_END
