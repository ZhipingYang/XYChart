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

- (void)setDataSource:(id<XYChartDataSource> _Nonnull)dataSource index:(NSUInteger)index chart:(XYChart *)chart;

@end

NS_ASSUME_NONNULL_END
