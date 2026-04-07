#import <UIKit/UIKit.h>
#import <XYChart/XYChart.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoChartCardView : UIView

@property (nonatomic, strong, readonly) XYChart *chartView;
@property (nonatomic, strong, readonly) UILabel *eventLabel;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                    chartType:(XYChartType)chartType NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (void)updateLayoutForAvailableWidth:(CGFloat)availableWidth compactHeight:(BOOL)compactHeight;

@end

NS_ASSUME_NONNULL_END
