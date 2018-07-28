//
//  UUChartItem.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYChartItem : NSObject<XYChartItem>

@property (nonatomic) NSNumber *value;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, readwrite) NSString *name;

@end

NS_ASSUME_NONNULL_END
