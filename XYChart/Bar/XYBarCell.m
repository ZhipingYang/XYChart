//
//  XYBarCell.m
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYBarCell.h"
#import "XYBarView.h"

@interface XYBarCell()

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
    
    const CGSize size = self.bounds.size;
    _barContainerView.frame = CGRectMake(4, 0, self.bounds.size.width-8, self.bounds.size.height-XYChartRowLabelHeight);
    _nameLabel.frame = CGRectMake(0, size.height-XYChartRowLabelHeight, size.width, XYChartRowLabelHeight);
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

- (void)setDataSource:(id<XYChartDataSource> _Nonnull)dataSource index:(NSUInteger)index chart:(XYChart *)chart
{
    _dataSource = dataSource;
    _chartView = chart;
    
    self.nameLabel.attributedText = [_dataSource chart:chart titleOfRowAtIndex:index];
    
    NSMutableArray <id<XYChartItem>>*mArr = @[].mutableCopy;
    for (int section=0; section<[_dataSource numberOfSectionsInChart:chart]; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
        id<XYChartItem> item = [_dataSource chart:_chartView itemOfIndex:indexPath];
        if (item) {
            [mArr addObject:item];
        }
    }
    _barsDataArray = [NSArray arrayWithArray:mArr];
    [self reloadBars];

}

- (void)reloadBars
{
    const CGFloat count = _barsDataArray.count;
    [_barContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_barsDataArray enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYBarView *bar = [[XYBarView alloc] initWithFrame:CGRectMake((xy_width(self.barContainerView)/count)*idx, 0, xy_width(self.barContainerView)/count, xy_height(self.barContainerView))];
        [self.barContainerView addSubview:bar];
        bar.chartItem = obj;
    }];
}

@end
