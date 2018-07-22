//
//  UUBarCell.m
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "UUBarCell.h"
#import "UUBar.h"

@interface UUBarCell()

@property (nonatomic, strong) id<UUChartGroup> chartGroup;

@property (nonatomic, strong) NSArray <id<UUChartItem>>*barsDataArray;

@end

@implementation UUBarCell
{
    
}

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
    _barContainerView.frame = CGRectMake(4, 0, self.bounds.size.width-8, self.bounds.size.height-UUChartXLabelHeight);
    _nameLabel.frame = CGRectMake(0, size.height-UUChartXLabelHeight, size.width, UUChartXLabelHeight);
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

- (void)setChartGroup:(id<UUChartGroup>)chartGroup index:(NSUInteger)index
{
    _chartGroup = chartGroup;
    self.nameLabel.attributedText = _chartGroup.names.xy_safeIdx(index);
    
    NSMutableArray <id<UUChartItem>>*mArr = @[].mutableCopy;
    [chartGroup.dataList enumerateObjectsUsingBlock:^(NSArray<id<UUChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mArr addObject:obj.xy_safeIdx(index)];
    }];
    _barsDataArray = [NSArray arrayWithArray:mArr];
    [self reloadBars];
}

- (void)reloadBars
{
    const CGFloat count = _barsDataArray.count;
    const CGSize size = self.barContainerView.bounds.size;

    [_barContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_barsDataArray enumerateObjectsUsingBlock:^(id<UUChartItem>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UUBar *bar = [[UUBar alloc] initWithFrame:CGRectMake((size.width/count)*idx, 0, size.width/count, size.height)];
        [self.barContainerView addSubview:bar];
        bar.chartItem = obj;
    }];
}

@end
