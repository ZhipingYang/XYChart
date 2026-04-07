//
//  XYBarCell.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class XYChart;
@interface XYBarCell : UICollectionViewCell

@property (nonatomic, strong) UIView *barContainerView;
@property (nonatomic, strong) UILabel *nameLabel;

+ (NSTimeInterval)animationCascadeStep;
- (void)updateChart:(XYChart *)chart index:(NSUInteger)index animation:(BOOL)animation;
- (void)startAnimationsIfNeededWithBaseDelay:(NSTimeInterval)baseDelay;

@end

NS_ASSUME_NONNULL_END
