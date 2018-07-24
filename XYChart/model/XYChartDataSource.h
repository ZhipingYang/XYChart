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
 default 0
 */
@property (nonatomic) CGFloat minValue;

/**
 default 100
 */
@property (nonatomic) CGFloat maxValue;

/**
 default 5
 */
@property (nonatomic) NSUInteger numberOfSections;

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
@property (nonatomic, strong) NSArray <NSArray <id<XYChartItem>>*> *dataList;

- (instancetype)initWithStyle:(XYChartStyle)style;

/**
 默认 UUChartStyleLine
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
