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

static const NSTimeInterval XYBarAnimationCascadeStep = 0.06;

@interface XYBarCell()
{
    NSInteger _row;
}
@property (nonatomic, weak) id<XYChartDataSource> dataSource;
@property (nonatomic, weak) XYChart *chartView;

@property (nonatomic, strong) NSArray <id<XYChartItem>>*barsDataArray;
@property (nonatomic) BOOL isWaitingForAnimation;

@end

@implementation XYBarCell

+ (NSTimeInterval)animationCascadeStep
{
    return XYBarAnimationCascadeStep;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _barContainerView = [UIView new];
        [self.contentView addSubview:_barContainerView];
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.minimumScaleFactor = 0.65;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.isWaitingForAnimation = NO;
    [_barContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.nameLabel.attributedText = nil;
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
    if (count <= 0) {
        return;
    }
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
    self.isWaitingForAnimation = animation;
    [self reloadBars];
}

- (void)reloadBars
{
    const CGFloat count = _barsDataArray.count;
    [_barContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (count <= 0) {
        return;
    }
    
    [_barsDataArray enumerateObjectsUsingBlock:^(id<XYChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYBarView *bar = [[XYBarView alloc] initWithFrame:CGRectMake((xy_width(self.barContainerView)/count)*idx, 0, xy_width(self.barContainerView)/count, xy_height(self.barContainerView))];
        [bar setChartItem:obj range:[self.chartView resolvedConfiguration].visibleRange];
        [self.barContainerView addSubview:bar];
        
        __weak typeof(self) weakSelf = self;
        bar.handleBlock = ^(XYBarView * _Nonnull view) {
            [weakSelf handleTapIfNeed:view];
        };
    }];
}

- (void)startAnimationsIfNeededWithBaseDelay:(NSTimeInterval)baseDelay
{
    if (self.isWaitingForAnimation == NO) {
        return;
    }
    self.isWaitingForAnimation = NO;
    [self.barContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[XYBarView class]]) {
            NSTimeInterval delay = baseDelay + ((NSTimeInterval)idx * XYBarAnimationCascadeStep);
            [(XYBarView *)obj startAnimate:YES delay:delay];
        }
    }];
}

- (void)handleTapIfNeed:(XYBarView *)view
{
    [self.barContainerView bringSubviewToFront:view];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:_row inSection:[_barContainerView.subviews indexOfObject:view]];
    NSObject<XYChartDelegate> *delegate = (NSObject<XYChartDelegate> *)_chartView.delegate;
    if ([delegate respondsToSelector:@selector(chart:clickAnimationOfIndex:)]) {
        CAAnimation *animation = [delegate chart:_chartView clickAnimationOfIndex:path];
        if (animation) {
            [view.showLayer addAnimation:animation forKey:@"Bar_CAAnimation"];
        }
    }
    if ([delegate respondsToSelector:@selector(chart:itemDidClick:)]) {
        [delegate chart:_chartView itemDidClick:view.chartItem];
    }
    BOOL shouldShowMenu = view.chartItem.showName.length > 0;
    if ([delegate respondsToSelector:@selector(chart:shouldShowMenu:)]) {
        shouldShowMenu = [delegate chart:_chartView shouldShowMenu:path];
    }
    if (shouldShowMenu && view.superview && view.window) {
        [view showMenu];
    }
}

@end
