//
//  XYBarChart.m
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "XYBarChart.h"
#import "XYBarView.h"
#import "XYBarCell.h"
#import "XYChart.h"

@interface XYBarChart ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL _shouldAnimation;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *animatedRows;
@property (nonatomic) CFTimeInterval nextRowAnimationAvailableTime;

@end

@implementation XYBarChart

- (instancetype)initWithChartView:(XYChart *)chartView
{
    self = [super init];
    if (self) {
        _chartView = chartView;
        [self initBaseUIElements];
    }
    return self;
}

- (void)initBaseUIElements
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[XYBarCell class] forCellWithReuseIdentifier:NSStringFromClass([XYBarCell class])];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    [_collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - XYChartContainer

- (void)reloadData:(BOOL)animation
{
    _shouldAnimation = animation;
    self.animatedRows = animation ? [NSMutableSet set] : nil;
    self.nextRowAnimationAvailableTime = 0;
    [self.collectionView reloadData];
}

- (NSTimeInterval)animationSpanForRow:(NSUInteger)row
{
    NSUInteger sections = [self.chartView.dataSource numberOfSectionsInChart:self.chartView];
    NSTimeInterval rowDuration = XYChartDefaultAnimationDuration();
    for (NSUInteger section = 0; section < sections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        id<XYChartItem> item = [self.chartView.dataSource chart:self.chartView itemOfIndex:indexPath];
        rowDuration = MAX(rowDuration, XYChartResolvedAnimationDuration(item ? item.duration : 0));
    }
    return rowDuration + MAX((NSInteger)sections - 1, 0) * [XYBarCell animationCascadeStep];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_chartView.dataSource numberOfRowsInChart:_chartView];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XYBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYBarCell class]) forIndexPath:indexPath];
    BOOL shouldAnimateCell = _shouldAnimation && ![self.animatedRows containsObject:@(indexPath.row)];
    [cell updateChart:_chartView index:indexPath.row animation:shouldAnimateCell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[XYBarCell class]] == NO) {
        return;
    }
    if (_shouldAnimation == NO || [self.animatedRows containsObject:@(indexPath.row)]) {
        [(XYBarCell *)cell startAnimationsIfNeededWithBaseDelay:0];
        return;
    }
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval scheduledStart = MAX(now, self.nextRowAnimationAvailableTime);
    NSTimeInterval delay = scheduledStart - now;
    self.nextRowAnimationAvailableTime = scheduledStart + [self animationSpanForRow:indexPath.row];
    [self.animatedRows addObject:@(indexPath.row)];
    [(XYBarCell *)cell startAnimationsIfNeededWithBaseDelay:delay];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XYChartConfiguration *configuration = [_chartView resolvedConfiguration];
    const BOOL isAutoSizing = configuration.autoSizingRowWidth;
    NSUInteger rows = [_chartView.dataSource numberOfRowsInChart:_chartView];
    const CGFloat rowWidth = XYChartResolvedRowWidth(xy_width(self), rows, isAutoSizing, configuration.rowWidth);
    return CGSizeMake(rowWidth, xy_height(self));
}

@end
