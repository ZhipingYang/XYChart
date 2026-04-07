//
//  XYChartConfiguration.h
//  XYChart
//
//  Created by Codex on 2026/4/7.
//

#import "XYChartConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYChartConfiguration : NSObject<NSCopying>

/**
 default 0...100 when auto range is disabled
 */
@property (nonatomic) XYRange visibleRange;

/**
 default NO, datasource item enables it by default
 */
@property (nonatomic) BOOL automaticallyAdjustsVisibleRange;

/**
 default 5
 */
@property (nonatomic) NSUInteger numberOfLevels;

/**
 default 60
 */
@property (nonatomic) CGFloat rowWidth;

/**
 default YES
 */
@property (nonatomic) BOOL autoSizingRowWidth;

+ (instancetype)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
