//
//  UUChartItem.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUChartItem : NSObject<UUChartItem>

@property (nonatomic) CGFloat percent;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) UIColor *color;

- (void)setName:(nullable NSString *)name;

@end

NS_ASSUME_NONNULL_END
