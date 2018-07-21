//
//  UULineItemView.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUChartProtocol.h"

@interface UULineItemView : UIView

@property (nonatomic, readonly) id<UUChartGroup> chartGroup;
@property (nonatomic, readonly) NSUInteger index;

- (void)setChartGroup:(id<UUChartGroup> _Nonnull)chartGroup index:(NSUInteger)index;

@end
