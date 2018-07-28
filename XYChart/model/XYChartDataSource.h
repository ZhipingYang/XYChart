//
//  XYChartDataSource.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYChartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYChartDataSource : NSObject<XYChartDataSource>

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

/**
 default：多条线路的item.name累加 比如：@[@[‘a’,'b'],@['c','d']] => @["a:c","b:d"]
 富文本：
 @{
    NSFontAttributeName: [UIFont systemFontOfSize:10],
    NSForegroundColorAttributeName: UUChartItem.color,
 }
 */
@property (nonatomic, strong) NSArray <NSAttributedString *> *names;

/**
 default:
  @{ NSFontAttributeName: [UIFont systemFontOfSize:10],
     NSForegroundColorAttributeName: [UIColor lightGrayColor]}
 */
- (void)setConfigYLabelBlock:(NSAttributedString * _Nonnull (^ _Nullable)(CGFloat))configYLabelBlock;


#pragma mark - 重点

/**
 必须设置的
 */
@property (nonatomic, readonly) NSArray <NSArray <id<XYChartItem>>*> *dataList;

- (instancetype)initWithDataList:(NSArray <NSArray <id<XYChartItem>>*> *)dataList;

@end

NS_ASSUME_NONNULL_END
