//
//  UUBar.h
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUBar : UIView

@property (nonatomic, strong) id<UUChartItem> chartItem;

@property (nonatomic, strong) CAShapeLayer * line;

- (void)setChartItem:(id<UUChartItem> _Nonnull)chartItem animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
