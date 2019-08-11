//
//  XYBarCell.m
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYBarCell.h"
#import "XYBarView.h"
#import "XYChart.h"

@interface XYBarCell()
{
    NSInteger _row;
}
@property (nonatomic, weak) id<XYChartDataSource> dataSource;
@property (nonatomic, weak) XYChart *chartView;

@property (nonatomic, strong) NSArray <id<XYChartItem>>*barsDataArray;

@end

@implementation XYBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _barContainerView = [UIView new];
        [self.contentView addSubview:_barContainerView];
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _barContainerView.frame = CGRectMake(4, 0, xy_width(self.contentView)-8, xy_height(self)-XYChartRowLabelHeight);
    _nameLabel.frame = CGRectMake(0, xy_height(self)-XYChartRowLabelHeight, xy_width(self), XYChartRowLabelHeight);
    [self updateBarFrames];
}

- (void)updateBarFrames
{
    const CGFloat count = self.barContainerView.subviews.count;
    const CGSize size = self.barContainerView.bounds.size;
    [self.barContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake((size.width/count)*idx, 0, size.width/count, size.height);
        [obj setNeedsLayout];
    }];
}

- (void)updateChart:(XYChart *)chart index:(NSUInteger)index animation:(BOOL)animation
{
    _dataSource = chart.dataSource;
    _chartView = chart;
    _row = index;
    self.nameLabel.attributedText = [_dataSource chart:chart titleOfRowAtIndex:index];
    
    NSMutableArray <id<XYChartItem>>*mArr = @[].mutableCopy;
    
    const NSUInteger sections = [_dataSource numberOfSectionsInChart:chart];
    for (int section=0; section<sections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
        id<XYChartItem> item = [_dataSource chart:_chartView itemOfIndex:indexPath];
        [mArr xy_safeAdd:item];
    }
    _barsDataArray = [NSArray arrayWithArray:mArr];
    [self reloadBars:animation];
}

- (void)reloadBars:(BOOL)animation
{
    const CGFloat count = _barsDataArray.count;
    [_barContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_barsDataArray enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYBarView *bar = [[XYBarView alloc] initWithFrame:CGRectMake((xy_width(self.barContainerView)/count)*idx, 0, xy_width(self.barContainerView)/count, xy_height(self.barContainerView))];
        [bar setChartItem:obj range:[self.dataSource visibleRangeInChart:self.chartView]];
        [self.barContainerView addSubview:bar];
        [bar startAnimate:animation];
        
        __weak typeof(self) weakSelf = self;
        bar.handleBlock = ^(XYBarView * _Nonnull view) {
            [weakSelf handleAnimationIfNeed:view];
        };
    }];
}

- (void)handleAnimationIfNeed:(XYBarView *)view
{
    [self.barContainerView bringSubviewToFront:view];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:_row inSection:[_barContainerView.subviews indexOfObject:view]];
    CAAnimation *animation = [_chartView.delegate chart:_chartView clickAnimationOfIndex:path];
    [view.showLayer addAnimation:animation forKey:@"Bar_CAAnimation"];
}

@end
