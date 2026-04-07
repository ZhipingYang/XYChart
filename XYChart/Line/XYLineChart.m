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
#import "XYChart.h"

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
        
        _linesView = [[XYLinesView alloc] initWithChartView:chartView];
        [_scrolView addSubview:_linesView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const BOOL isAutoSizing = [_chartView.dataSource autoSizingRowInChart:_chartView];
    const NSUInteger itemCount = self.itemViews.count;
    const CGFloat visibleItemCount = itemCount > 0 ? itemCount : 1;
    const CGFloat rowWidth = isAutoSizing ? xy_width(self)/visibleItemCount
                                          : [_chartView.dataSource rowWidthOfChart:_chartView];
    
    _scrolView.frame = self.bounds;
    _scrolView.contentSize = CGSizeMake(MAX(rowWidth * itemCount, xy_width(_scrolView)), xy_height(_scrolView));
    _linesView.frame = CGRectMake(0, 0, _scrolView.contentSize.width, _scrolView.contentSize.height-XYChartRowLabelHeight);
    
    [_itemViews enumerateObjectsUsingBlock:^(XYLineItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx*rowWidth, 0, rowWidth, xy_height(self));
    }];
}

#pragma mark - XYChartContainer

- (void)reloadData:(BOOL)animation
{
    [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemViews removeAllObjects];
    
    [_linesView reloadData:animation];
    
    const NSUInteger rows = [_chartView.dataSource numberOfRowsInChart:_chartView];
    const XYRange range = [_chartView.dataSource visibleRangeInChart:_chartView];

    for (int index=0; index<rows; index++) {
        XYLineItemView *itemView = [[XYLineItemView alloc] init];
        __weak typeof(self) weakSelf = self;
        const NSUInteger rowIndex = index;
        itemView.handleBlock = ^(XYLineItemView *view, NSArray<NSNumber *> *sectionIndexes, NSArray<id<XYChartItem>> *items, NSArray<CALayer *> *circles) {
            [weakSelf handleTapForItemView:view row:rowIndex sectionIndexes:sectionIndexes items:items circles:circles];
        };
        
        // 收集数组点
        NSMutableArray <id<XYChartItem>>*mArr = @[].mutableCopy;
        for (int section=0; section<[_chartView.dataSource numberOfSectionsInChart:_chartView]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            id<XYChartItem> item = [_chartView.dataSource chart:_chartView itemOfIndex:indexPath];
            if (item) {
                [mArr addObject:item];
            }
        }
        NSAttributedString *name = [_chartView.dataSource chart:_chartView titleOfRowAtIndex:index];
        [itemView setItems:mArr name:name range:range];
        [self.scrolView addSubview:itemView];
        [_itemViews addObject:itemView];
    }
    [self setNeedsLayout];
}

- (void)handleTapForItemView:(XYLineItemView *)itemView
                         row:(NSUInteger)row
              sectionIndexes:(NSArray<NSNumber *> *)sectionIndexes
                       items:(NSArray<id<XYChartItem>> *)items
                     circles:(NSArray<CALayer *> *)circles
{
    id<XYChartDelegate> delegate = self.chartView.delegate;
    NSMutableArray<id<XYChartItem>> *menuItems = @[].mutableCopy;
    NSMutableArray<CALayer *> *menuCircles = @[].mutableCopy;
    
    [items enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger section = sectionIndexes.xy_safeIdx(idx).unsignedIntegerValue;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        CALayer *circle = circles.xy_safeIdx(idx);
        if ([delegate respondsToSelector:@selector(chart:clickAnimationOfIndex:)]) {
            CAAnimation *animation = [delegate chart:self.chartView clickAnimationOfIndex:indexPath];
            if (animation && circle) {
                [circle addAnimation:animation forKey:@"Line_CAAnimation"];
            }
        }
        if ([delegate respondsToSelector:@selector(chart:itemDidClick:)]) {
            [delegate chart:self.chartView itemDidClick:item];
        }
        
        BOOL shouldShowMenu = item.showName.length > 0;
        if ([delegate respondsToSelector:@selector(chart:shouldShowMenu:)]) {
            shouldShowMenu = [delegate chart:self.chartView shouldShowMenu:indexPath];
        }
        if (shouldShowMenu && item.showName.length > 0 && circle) {
            [menuItems addObject:item];
            [menuCircles addObject:circle];
        }
    }];
    
    if (menuItems.count > 0 && itemView.superview && itemView.window) {
        [itemView showMenuForItems:menuItems targetCircles:menuCircles];
    }
}

@end
