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
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_chartView.dataSource numberOfRowsInChart:_chartView];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XYBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYBarCell class]) forIndexPath:indexPath];
    [cell updateChart:_chartView index:indexPath.row animation:_shouldAnimation];
    return cell;
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
