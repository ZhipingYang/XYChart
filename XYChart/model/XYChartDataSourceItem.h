//
//  XYChartDataSource.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYChartDataSourceItem : NSObject<XYChartDataSource>

/**
 default the min & max of items value
 */
@property (nonatomic) XYRange range;

/**
 default 5
 */
@property (nonatomic) NSUInteger numberOfLevels;

/**
 default 60
 */
@property (nonatomic) CGFloat widthOfRow;

/**
 default YES;
 */
@property (nonatomic) BOOL autoSizingRowWidth;

#pragma mark - 重点

/**
 必须设置的
 */
@property (nonatomic, readonly) NSArray <NSArray <id<XYChartItem>>*> *dataList;

- (instancetype)initWithDataList:(NSArray <NSArray <id<XYChartItem>>*> *)dataList;

@end

NS_ASSUME_NONNULL_END
