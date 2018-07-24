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

@interface XYBarChart ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation XYBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
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
    [_collectionView reloadData];
}

- (void)setChartGroup:(id<XYChartDataSource>)chartGroup
{
    [self setChartGroup:chartGroup animation:_chartGroup ? NO : YES];
}

- (void)setChartGroup:(id<XYChartDataSource>)chartGroup animation:(BOOL)animation
{
    _chartGroup = chartGroup;
    [self.collectionView reloadData];
}

- (void)reloadData:(BOOL)animation
{
    
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _chartGroup.names.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XYBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYBarCell class]) forIndexPath:indexPath];
    [cell setChartGroup:_chartGroup index:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = _chartGroup.dataList.count > 0 ? _chartGroup.dataList.firstObject.count : 1;
    count = count>0 ? count : 1;
    if (_chartGroup.autoSizingRowWidth) {
        return CGSizeMake(self.bounds.size.width/(CGFloat)count, self.bounds.size.height);
    } else {
        return CGSizeMake(_chartGroup.widthOfRow, self.bounds.size.height);
    }
}

@end
