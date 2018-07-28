//
//  XYLineChart.m
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "XYLineChart.h"
#import "XYLineItemView.h"
#import "XYLinesView.h"

@interface XYLineChart ()

@property (nonatomic, strong) UIScrollView *scrolView;
@property (nonatomic, strong) XYLinesView *linesView;

@property (nonatomic, strong) NSMutableArray <XYLineItemView *>* itemViews;

@end

@implementation XYLineChart

- (instancetype)initWithChartView:(XYChart *)chartView
{
    self = [super init];
    if (self) {
        _chartView = chartView;
        _itemViews = @[].mutableCopy;
        _scrolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrolView.showsVerticalScrollIndicator = NO;
        _scrolView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrolView];
        
        _linesView = [XYLinesView new];
        [_scrolView addSubview:_linesView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const BOOL isAutoSizing = [_dataSource autoSizingRowInChart:_chartView];
    const BOOL rowWidth = isAutoSizing ? xy_width(self)/self.itemViews.count
                                       : [_dataSource rowWidthOfChart:_chartView];
    
    _scrolView.frame = self.bounds;
    _scrolView.contentSize = CGSizeMake(rowWidth * _itemViews.count, xy_height(_scrolView));
    _linesView.frame = CGRectMake(0, 0, _scrolView.contentSize.width, _scrolView.contentSize.height-XYChartRowLabelHeight);
    
    [_itemViews enumerateObjectsUsingBlock:^(XYLineItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx*rowWidth, 0, rowWidth, xy_height(self));
    }];
}

- (void)setDataSource:(NSObject<XYChartDataSource> *)dataSource
{
    [self setDataSource:dataSource animation:_dataSource ? NO : YES];
}

- (void)setDataSource:(id<XYChartDataSource>)dataSource animation:(BOOL)animation
{
    _dataSource = dataSource;
    
    [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemViews removeAllObjects];
    
    [_linesView setDataSource:_dataSource chartView:_chartView];
    
    const NSUInteger rows = [_dataSource numberOfRowsInChart:_chartView];
    const XYRange range = [_dataSource visibleRangeInChart:_chartView];
    
    for (int index=0; index<rows; index++) {
        XYLineItemView *itemView = [[XYLineItemView alloc] init];
        
        // 收集数组点
        NSMutableArray <id<XYChartItem>>*mArr = @[].mutableCopy;
        for (int section=0; section<[_dataSource numberOfSectionsInChart:_chartView]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            id<XYChartItem> item = [_dataSource chart:_chartView itemOfIndex:indexPath];
            if (item) {
                [mArr addObject:item];
            }
        }

        [itemView setItems:mArr range:range];
        [self.scrolView addSubview:itemView];
        [_itemViews addObject:itemView];
    }
    [self setNeedsLayout];
}

- (void)reloadData:(BOOL)animation
{
    
}

@end
