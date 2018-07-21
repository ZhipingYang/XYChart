//
//  UUChartProtocol.h
//  UUChartView
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

@import UIKit;
#import "UIColor+UUChart.h"

#define UUChartYLabelWidth 30
#define UUChartXLabelHeight 20

typedef NS_ENUM(NSInteger, UUChartStyle){
    UUChartStyleLine = 0,
    UUChartStyleBar
};

NS_ASSUME_NONNULL_BEGIN

/**
 单个数据展示
 */
@protocol UUChartItem

@required
@property (nonatomic, readonly) CGFloat percent;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) UIColor *color;

@optional
@property (nonatomic, readonly, nullable) NSString *name;

@end


/**
 多套对比数据展示
 */
@protocol UUChartGroup

@property (nonatomic, readonly) UUChartStyle chartStyle;

@property (nonatomic, readonly) CGFloat minValue;

@property (nonatomic, readonly) CGFloat maxValue;

@property (nonatomic, readonly) NSUInteger ySectionNumber;

@property (nonatomic, readonly) NSUInteger xSectionWidth;

@property (nonatomic, readonly) BOOL autoSizeX;

@property (nonatomic, readonly) NSArray <NSArray <id<UUChartItem>>*> *dataList;

@property (nonatomic, readonly) NSArray <NSAttributedString *> *names;

@end

@protocol UUChartContainer

@property (nonatomic, readonly) id<UUChartGroup>chartGroup;

- (void)setChartGroup:(id<UUChartGroup>)chartGroup animation:(BOOL)animation;

- (void)reloadData:(BOOL)animation;

@end


NS_ASSUME_NONNULL_END
