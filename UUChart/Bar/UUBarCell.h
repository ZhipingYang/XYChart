//
//  UUBarCell.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUBarCell : UICollectionViewCell

@property (nonatomic, strong) UIView *barContainerView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, readonly) id<UUChartGroup> chartGroup;

- (void)setChartGroup:(id<UUChartGroup> _Nonnull)chartGroup index:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
