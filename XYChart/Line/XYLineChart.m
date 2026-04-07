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

@property (nonatomic, strong) UIScrollView *scrollView;
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
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _linesView = [[XYLinesView alloc] initWithChartView:chartView];
        [_scrollView addSubview:_linesView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    XYChartConfiguration *configuration = [_chartView resolvedConfiguration];
    const BOOL isAutoSizing = configuration.autoSizingRowWidth;
    const NSUInteger itemCount = self.itemViews.count;
    const CGFloat rowWidth = XYChartResolvedRowWidth(xy_width(self), itemCount, isAutoSizing, configuration.rowWidth);
    const CGFloat contentWidth = XYChartResolvedContentWidth(xy_width(self), itemCount, isAutoSizing, configuration.rowWidth);
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(contentWidth, xy_height(_scrollView));
    _linesView.frame = CGRectMake(0, 0, contentWidth, XYChartPlotHeight(xy_height(_scrollView)));
    
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
    const XYRange range = [_chartView resolvedConfiguration].visibleRange;

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
        [self.scrollView addSubview:itemView];
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
    NSObject<XYChartDelegate> *delegate = (NSObject<XYChartDelegate> *)self.chartView.delegate;
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
