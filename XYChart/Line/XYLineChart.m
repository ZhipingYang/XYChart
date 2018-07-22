//
//  XYLineChart.m
//  UUChartView
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    _scrolView.frame = self.bounds;
    if (_chartGroup.autoSizeX) {
        _scrolView.contentSize = _scrolView.frame.size;
    } else {
        _scrolView.contentSize = CGSizeMake(_chartGroup.xSectionWidth * _itemViews.count, uu_height(_scrolView));
    }
    _linesView.frame = CGRectMake(0, 0, _scrolView.contentSize.width, _scrolView.contentSize.height-UUChartXLabelHeight);
    
    [_itemViews enumerateObjectsUsingBlock:^(XYLineItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_chartGroup.autoSizeX) {
            CGFloat width = uu_width(self)/_itemViews.count;
            obj.frame = CGRectMake(idx*width, 0, width, uu_height(self));
        } else {
            obj.frame = CGRectMake(idx*_chartGroup.xSectionWidth, 0, _chartGroup.xSectionWidth, uu_height(self));
        }
    }];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup
{
    [self setChartGroup:chartGroup animation:_chartGroup ? NO : YES];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup animation:(BOOL)animation
{
    _chartGroup = chartGroup;
    
    [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemViews removeAllObjects];
    
    _linesView.chartGroup = chartGroup;
    
    const NSUInteger count = _chartGroup.dataList.firstObject.count;
    for (int i=0; i<count; i++) {
        XYLineItemView *itemView = [[XYLineItemView alloc] init];
        [itemView setChartGroup:_chartGroup index:i];
        [self.scrolView addSubview:itemView];
        [_itemViews addObject:itemView];
    }
    [self setNeedsLayout];
}

- (void)reloadData:(BOOL)animation
{
    
}

@end
