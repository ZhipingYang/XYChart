#import "DemoViewController.h"
#import "DemoChartCardView.h"
#import "DemoChartDataSource.h"

@interface DemoViewController () <XYChartDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UIStackView *primaryChartsRow;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) DemoChartCardView *weeklyLineCard;
@property (nonatomic, strong) DemoChartCardView *monthlyLineCard;
@property (nonatomic, strong) DemoChartCardView *groupedBarCard;
@property (nonatomic, strong) DemoChartDataSource *weeklyLineDataSource;
@property (nonatomic, strong) DemoChartDataSource *monthlyLineDataSource;
@property (nonatomic, strong) DemoChartDataSource *groupedBarDataSource;
@property (nonatomic) BOOL didAnimateCharts;

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.965 green:0.949 blue:0.918 alpha:1.0];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;

    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

    self.contentStackView = [[UIStackView alloc] init];
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.spacing = 20.0;

    self.primaryChartsRow = [[UIStackView alloc] init];
    self.primaryChartsRow.translatesAutoresizingMaskIntoConstraints = NO;
    self.primaryChartsRow.axis = UILayoutConstraintAxisVertical;
    self.primaryChartsRow.spacing = 20.0;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor colorWithRed:0.145 green:0.133 blue:0.118 alpha:1.0];
    self.titleLabel.text = @"XYChart Demo";

    self.introLabel = [[UILabel alloc] init];
    self.introLabel.numberOfLines = 0;
    self.introLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.introLabel.textColor = [UIColor colorWithRed:0.353 green:0.322 blue:0.286 alpha:1.0];
    self.introLabel.text = @"Pure code demo only keeps the pod's core usage: build a datasource, tweak XYChartConfiguration, assign it to XYChart, then observe delegate callbacks.";

    self.weeklyLineCard = [[DemoChartCardView alloc] initWithTitle:@"Weekly Line"
                                                          subtitle:@"Two lines share one datasource item. This card uses automatic row sizing to show the default layout behavior."
                                                         chartType:XYChartTypeLine];
    self.monthlyLineCard = [[DemoChartCardView alloc] initWithTitle:@"Scrollable Line"
                                                           subtitle:@"Twelve points switch to a fixed row width so the chart scrolls horizontally, matching the pod's denser line scenario."
                                                          chartType:XYChartTypeLine];
    self.groupedBarCard = [[DemoChartCardView alloc] initWithTitle:@"Grouped Bar"
                                                          subtitle:@"Three sections reuse the same datasource abstraction and only change chart type plus row width configuration."
                                                         chartType:XYChartTypeBar];

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.contentStackView];

    [self.primaryChartsRow addArrangedSubview:self.weeklyLineCard];
    [self.primaryChartsRow addArrangedSubview:self.monthlyLineCard];

    [self.contentStackView addArrangedSubview:self.titleLabel];
    [self.contentStackView addArrangedSubview:self.introLabel];
    [self.contentStackView addArrangedSubview:self.primaryChartsRow];
    [self.contentStackView addArrangedSubview:self.groupedBarCard];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],

        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],

        [self.contentStackView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:20.0],
        [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.contentView.readableContentGuide.leadingAnchor constant:16.0],
        [self.contentStackView.trailingAnchor constraintEqualToAnchor:self.contentView.readableContentGuide.trailingAnchor constant:-16.0],
        [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-24.0],
    ]];

    self.weeklyLineDataSource = [DemoChartDataSource weeklyLineDemo];
    self.monthlyLineDataSource = [DemoChartDataSource monthlyLineDemo];
    self.groupedBarDataSource = [DemoChartDataSource groupedBarDemo];

    [self bindChart:self.weeklyLineCard.chartView withDataSource:self.weeklyLineDataSource];
    [self bindChart:self.monthlyLineCard.chartView withDataSource:self.monthlyLineDataSource];
    [self bindChart:self.groupedBarCard.chartView withDataSource:self.groupedBarDataSource];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGFloat availableWidth = CGRectGetWidth(self.view.readableContentGuide.layoutFrame);
    if (availableWidth <= 0) {
        availableWidth = CGRectGetWidth(self.view.safeAreaLayoutGuide.layoutFrame) - 32.0;
    }
    CGFloat safeHeight = CGRectGetHeight(self.view.safeAreaLayoutGuide.layoutFrame);
    BOOL compactHeight = safeHeight < 700.0;
    BOOL wideLayout = availableWidth >= 700.0;

    self.contentStackView.spacing = wideLayout ? 24.0 : 20.0;
    self.primaryChartsRow.axis = wideLayout ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
    self.primaryChartsRow.distribution = wideLayout ? UIStackViewDistributionFillEqually : UIStackViewDistributionFill;
    self.titleLabel.font = [UIFont systemFontOfSize:(wideLayout ? 40.0 : 34.0) weight:UIFontWeightBold];
    self.introLabel.font = [UIFont systemFontOfSize:(wideLayout ? 16.0 : 15.0) weight:UIFontWeightRegular];

    CGFloat cardWidth = wideLayout ? floor((availableWidth - self.primaryChartsRow.spacing) / 2.0) : availableWidth;
    [self.weeklyLineCard updateLayoutForAvailableWidth:cardWidth compactHeight:compactHeight];
    [self.monthlyLineCard updateLayoutForAvailableWidth:cardWidth compactHeight:compactHeight];
    [self.groupedBarCard updateLayoutForAvailableWidth:availableWidth compactHeight:compactHeight];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.didAnimateCharts) {
        self.didAnimateCharts = YES;
        [self.weeklyLineCard.chartView reloadData:YES];
        [self.monthlyLineCard.chartView reloadData:YES];
        [self.groupedBarCard.chartView reloadData:YES];
    }
}

- (void)bindChart:(XYChart *)chartView withDataSource:(DemoChartDataSource *)dataSource
{
    chartView.delegate = self;
    [chartView setDataSource:dataSource animation:NO];
}

- (UILabel *)eventLabelForChart:(XYChart *)chart
{
    if (chart == self.weeklyLineCard.chartView) {
        return self.weeklyLineCard.eventLabel;
    }
    if (chart == self.monthlyLineCard.chartView) {
        return self.monthlyLineCard.eventLabel;
    }
    return self.groupedBarCard.eventLabel;
}

#pragma mark - XYChartDelegate

- (BOOL)chart:(XYChart *)chart shouldShowMenu:(NSIndexPath *)index
{
    return NO;
}

- (void)chart:(XYChart *)chart itemDidClick:(id<XYChartItem>)item
{
    UILabel *eventLabel = [self eventLabelForChart:chart];
    NSString *itemText = item.showName.length > 0 ? item.showName : item.value.stringValue;
    NSString *prefix = chart.type == XYChartTypeBar ? @"Bar tap" : @"Line tap";
    eventLabel.text = [NSString stringWithFormat:@"%@: %@", prefix, itemText];
}

- (CAAnimation *)chart:(XYChart *)chart clickAnimationOfIndex:(NSIndexPath *)index
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.24;
    animation.autoreverses = YES;
    animation.fromValue = @1.0;
    animation.toValue = @1.08;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@end
