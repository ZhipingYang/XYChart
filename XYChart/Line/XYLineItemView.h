//
//  UULineItemView.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYLineItemView : UIView

@property (nonatomic, readonly, nullable) id<UUChartGroup> chartGroup;
@property (nonatomic, readonly) NSUInteger index;

- (void)setChartGroup:(nullable id<UUChartGroup>)chartGroup index:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
