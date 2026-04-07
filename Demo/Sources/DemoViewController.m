#import "DemoViewController.h"
#import "DemoChartCardView.h"
#import "DemoChartDataSource.h"

@interface DemoViewController () <XYChartDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UIStackView *primaryChartsRow;
@property (nonatomic, strong) UIStackView *secondaryChartsRow;
@property (nonatomic, strong) UIStackView *tertiaryChartsRow;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *featureLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) DemoChartCardView *weeklyLineCard;
@property (nonatomic, strong) DemoChartCardView *monthlyLineCard;
@property (nonatomic, strong) DemoChartCardView *velocityLineCard;
@property (nonatomic, strong) DemoChartCardView *groupedBarCard;
@property (nonatomic, strong) DemoChartCardView *forecastBarCard;
@property (nonatomic, strong) DemoChartCardView *launchBarCard;
@property (nonatomic, strong) DemoChartDataSource *weeklyLineDataSource;
@property (nonatomic, strong) DemoChartDataSource *monthlyLineDataSource;
@property (nonatomic, strong) DemoChartDataSource *velocityLineDataSource;
@property (nonatomic, strong) DemoChartDataSource *groupedBarDataSource;
@property (nonatomic, strong) DemoChartDataSource *forecastBarDataSource;
@property (nonatomic, strong) DemoChartDataSource *launchBarDataSource;
@property (nonatomic) BOOL didAnimateCharts;
@property (nonatomic) BOOL didApplyDocumentationScrollOffset;

@end

@implementation DemoViewController

- (UIStackView *)makeChartRow
{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 20.0;
    return stackView;
}

- (NSArray<DemoChartCardView *> *)allCards
{
    return @[
        self.weeklyLineCard,
        self.monthlyLineCard,
        self.velocityLineCard,
        self.groupedBarCard,
        self.forecastBarCard,
        self.launchBarCard
    ];
}

- (NSArray<UIStackView *> *)allRows
{
    return @[self.primaryChartsRow, self.secondaryChartsRow, self.tertiaryChartsRow];
}

- (NSArray<UIView *> *)animatableViews
{
    NSMutableArray<UIView *> *views = [NSMutableArray arrayWithObjects:self.titleLabel, self.featureLabel, self.introLabel, nil];
    [views addObjectsFromArray:[self allCards]];
    return [views copy];
}

- (DemoChartCardView *)cardForChart:(XYChart *)chart
{
    for (DemoChartCardView *card in [self allCards]) {
        if (card.chartView == chart) {
            return card;
        }
    }
    return self.weeklyLineCard;
}

- (void)reloadCardWithAnimation:(DemoChartCardView *)card
{
    [card.chartView reloadData:YES];
    card.eventLabel.text = @"Animation replayed. Tap a point or bar to inspect the updated value state.";
}

- (CGFloat)documentationScrollOffset
{
    NSString *offsetText = NSProcessInfo.processInfo.environment[@"XYCHART_DEMO_SCROLL_Y"];
    if (offsetText.length == 0) {
        return 0.0;
    }
    return MAX(offsetText.doubleValue, 0.0);
}

- (void)applyDocumentationScrollOffsetIfNeeded
{
    if (self.didApplyDocumentationScrollOffset) {
        return;
    }

    CGFloat requestedOffset = [self documentationScrollOffset];
    if (requestedOffset <= 0.0) {
        return;
    }

    self.didApplyDocumentationScrollOffset = YES;
    [self applyDocumentationScrollOffset:requestedOffset remainingAttempts:6];
}

- (void)applyDocumentationScrollOffset:(CGFloat)requestedOffset remainingAttempts:(NSInteger)remainingAttempts
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [self.contentView layoutIfNeeded];
        [self.contentStackView layoutIfNeeded];
        [self.scrollView layoutIfNeeded];

        CGFloat maxOffset = MAX(self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds), 0.0);
        if (maxOffset <= 0.0 && remainingAttempts > 1) {
            [self applyDocumentationScrollOffset:requestedOffset remainingAttempts:(remainingAttempts - 1)];
            return;
        }

        CGFloat targetOffset = MIN(requestedOffset, maxOffset);
        [self.scrollView setContentOffset:CGPointMake(0, targetOffset) animated:NO];
    });
}

- (void)prepareEntranceAnimationStates
{
    NSArray<UIView *> *animatedViews = [self animatableViews];
    [animatedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.alpha = 0;
        view.transform = CGAffineTransformMakeTranslation(0, 20.0);
    }];
}

- (void)animateEntranceIfNeeded
{
    NSArray<UIView *> *animatedViews = [self animatableViews];
    [animatedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0.56
                              delay:(NSTimeInterval)idx * 0.05
             usingSpringWithDamping:0.9
              initialSpringVelocity:0.28
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            view.alpha = 1;
            view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)configureCard:(DemoChartCardView *)card
           dataSource:(DemoChartDataSource *)dataSource
               badges:(NSArray<NSString *> *)badges
      interactionHint:(NSString *)interactionHint
          replayTitle:(NSString *)replayTitle
{
    [card updatePresentationWithBadges:badges
                          legendTitles:dataSource.seriesNames
                          legendColors:dataSource.palette
                       interactionHint:interactionHint
                           replayTitle:replayTitle
                           accentColor:dataSource.palette.firstObject];
    __weak typeof(self) weakSelf = self;
    __weak DemoChartCardView *weakCard = card;
    card.replayHandler = ^(DemoChartCardView *cardView) {
        [weakSelf reloadCardWithAnimation:(weakCard ?: cardView)];
    };
}

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

    self.primaryChartsRow = [self makeChartRow];
    self.secondaryChartsRow = [self makeChartRow];
    self.tertiaryChartsRow = [self makeChartRow];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor colorWithRed:0.145 green:0.133 blue:0.118 alpha:1.0];
    self.titleLabel.text = @"XYChart Demo";

    self.featureLabel = [[UILabel alloc] init];
    self.featureLabel.numberOfLines = 0;
    self.featureLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    self.featureLabel.textColor = [UIColor colorWithRed:0.451 green:0.408 blue:0.337 alpha:1.0];
    self.featureLabel.text = @"6 CASES  |  REPLAY BUTTON  |  UIMENU  |  DRAW + GROW + TAP FX";

    self.introLabel = [[UILabel alloc] init];
    self.introLabel.numberOfLines = 0;
    self.introLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.introLabel.textColor = [UIColor colorWithRed:0.353 green:0.322 blue:0.286 alpha:1.0];
    self.introLabel.text = @"This demo keeps the pod's API surface simple, but pushes the showcase further: six curated cases, per-card animation replay, richer tap feedback, and tighter layout details across compact and wide iPhone screens.";

    self.weeklyLineCard = [[DemoChartCardView alloc] initWithTitle:@"Weekly Pulse"
                                                          subtitle:@"Two series share one datasource item and use automatic row sizing, so the layout stretches cleanly across compact widths."
                                                         chartType:XYChartTypeLine];
    self.monthlyLineCard = [[DemoChartCardView alloc] initWithTitle:@"Seasonal Draw"
                                                           subtitle:@"Three lines switch to fixed row width so you can watch the chart draw from left to right and inspect values with UIMenu."
                                                          chartType:XYChartTypeLine];
    self.velocityLineCard = [[DemoChartCardView alloc] initWithTitle:@"Velocity Trail"
                                                            subtitle:@"A single dense line focuses on tempo: tighter row spacing, faster redraw, and a more lightweight tap animation for quick trend scans."
                                                           chartType:XYChartTypeLine];
    self.groupedBarCard = [[DemoChartCardView alloc] initWithTitle:@"Product Mix"
                                                          subtitle:@"Grouped bars reuse the exact same datasource abstraction as line charts, while a wider row width keeps four bars readable."
                                                         chartType:XYChartTypeBar];
    self.forecastBarCard = [[DemoChartCardView alloc] initWithTitle:@"Forecast Bar"
                                                           subtitle:@"A lighter two-series bar demo keeps auto width enabled so the cell-based entry animation reads cleanly on smaller phones."
                                                          chartType:XYChartTypeBar];
    self.launchBarCard = [[DemoChartCardView alloc] initWithTitle:@"Launch Lift"
                                                          subtitle:@"A single-series bar run turns the replay button into a compact waterfall demo, useful for showing the entry rhythm without multi-series noise."
                                                         chartType:XYChartTypeBar];

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.contentStackView];

    [self.primaryChartsRow addArrangedSubview:self.weeklyLineCard];
    [self.primaryChartsRow addArrangedSubview:self.monthlyLineCard];
    [self.secondaryChartsRow addArrangedSubview:self.velocityLineCard];
    [self.secondaryChartsRow addArrangedSubview:self.groupedBarCard];
    [self.tertiaryChartsRow addArrangedSubview:self.forecastBarCard];
    [self.tertiaryChartsRow addArrangedSubview:self.launchBarCard];

    [self.contentStackView addArrangedSubview:self.titleLabel];
    [self.contentStackView addArrangedSubview:self.featureLabel];
    [self.contentStackView addArrangedSubview:self.introLabel];
    [self.contentStackView addArrangedSubview:self.primaryChartsRow];
    [self.contentStackView addArrangedSubview:self.secondaryChartsRow];
    [self.contentStackView addArrangedSubview:self.tertiaryChartsRow];

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
        [self.contentStackView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:20.0],
        [self.contentStackView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-20.0],
        [self.contentStackView.widthAnchor constraintLessThanOrEqualToConstant:760.0],
        [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-24.0],
    ]];

    self.weeklyLineDataSource = [DemoChartDataSource weeklyLineDemo];
    self.monthlyLineDataSource = [DemoChartDataSource monthlyLineDemo];
    self.velocityLineDataSource = [DemoChartDataSource velocityLineDemo];
    self.groupedBarDataSource = [DemoChartDataSource groupedBarDemo];
    self.forecastBarDataSource = [DemoChartDataSource forecastBarDemo];
    self.launchBarDataSource = [DemoChartDataSource launchBarDemo];

    [self configureCard:self.weeklyLineCard
             dataSource:self.weeklyLineDataSource
                 badges:@[@"AUTO WIDTH", @"TAP FEEDBACK", @"2 SERIES"]
        interactionHint:@"Tap a dot to update this footer with the selected point."
            replayTitle:@"Replay Pulse"];
    [self configureCard:self.monthlyLineCard
             dataSource:self.monthlyLineDataSource
                 badges:@[@"UIMENU", @"DRAW ANIMATION", @"SCROLL", @"3 SERIES"]
        interactionHint:@"Tap any dot to open UIMenu with per-series values at that month."
            replayTitle:@"Replay Draw"];
    [self configureCard:self.velocityLineCard
             dataSource:self.velocityLineDataSource
                 badges:@[@"SINGLE LINE", @"FAST REDRAW", @"DENSE"]
        interactionHint:@"Tap the line dots to inspect the dense case without opening a menu."
            replayTitle:@"Replay Glide"];
    [self configureCard:self.groupedBarCard
             dataSource:self.groupedBarDataSource
                 badges:@[@"GROUPED BAR", @"UIMENU", @"FIXED WIDTH", @"4 SERIES"]
        interactionHint:@"Tap a bar to see the selected value and the matching UIMenu title."
            replayTitle:@"Replay Cascade"];
    [self configureCard:self.forecastBarCard
             dataSource:self.forecastBarDataSource
                 badges:@[@"AUTO WIDTH", @"CELL ENTRY", @"PLAN VS ACTUAL"]
        interactionHint:@"Bars grow in when cells appear. Tap to compare actual versus plan quickly."
            replayTitle:@"Replay Grow"];
    [self configureCard:self.launchBarCard
             dataSource:self.launchBarDataSource
                 badges:@[@"SINGLE BAR", @"WATERFALL FEEL", @"COMPACT"]
        interactionHint:@"This case is about rhythm: replay it to watch a clean one-series bar cascade."
            replayTitle:@"Replay Lift"];

    [self bindChart:self.weeklyLineCard.chartView withDataSource:self.weeklyLineDataSource];
    [self bindChart:self.monthlyLineCard.chartView withDataSource:self.monthlyLineDataSource];
    [self bindChart:self.velocityLineCard.chartView withDataSource:self.velocityLineDataSource];
    [self bindChart:self.groupedBarCard.chartView withDataSource:self.groupedBarDataSource];
    [self bindChart:self.forecastBarCard.chartView withDataSource:self.forecastBarDataSource];
    [self bindChart:self.launchBarCard.chartView withDataSource:self.launchBarDataSource];

    [self prepareEntranceAnimationStates];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGFloat safeWidth = CGRectGetWidth(self.view.safeAreaLayoutGuide.layoutFrame);
    CGFloat availableWidth = MIN(MAX(safeWidth - 40.0, 280.0), 760.0);
    CGFloat safeHeight = CGRectGetHeight(self.view.safeAreaLayoutGuide.layoutFrame);
    BOOL compactHeight = safeHeight < 700.0;
    BOOL wideLayout = availableWidth >= 700.0;

    self.contentStackView.spacing = wideLayout ? 24.0 : 20.0;
    self.featureLabel.preferredMaxLayoutWidth = availableWidth;
    [[self allRows] enumerateObjectsUsingBlock:^(UIStackView * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
        row.axis = wideLayout ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
        row.distribution = wideLayout ? UIStackViewDistributionFillEqually : UIStackViewDistributionFill;
    }];
    self.titleLabel.font = [UIFont systemFontOfSize:(wideLayout ? 40.0 : 34.0) weight:UIFontWeightBold];
    self.featureLabel.font = [UIFont systemFontOfSize:(wideLayout ? 12.0 : 11.0) weight:UIFontWeightSemibold];
    self.introLabel.font = [UIFont systemFontOfSize:(wideLayout ? 16.0 : 15.0) weight:UIFontWeightRegular];

    CGFloat cardWidth = wideLayout ? floor((availableWidth - self.primaryChartsRow.spacing) / 2.0) : availableWidth;
    [[self allCards] enumerateObjectsUsingBlock:^(DemoChartCardView * _Nonnull card, NSUInteger idx, BOOL * _Nonnull stop) {
        [card updateLayoutForAvailableWidth:cardWidth compactHeight:compactHeight];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.didAnimateCharts) {
        self.didAnimateCharts = YES;
        [self animateEntranceIfNeeded];
        [[self allCards] enumerateObjectsUsingBlock:^(DemoChartCardView * _Nonnull card, NSUInteger idx, BOOL * _Nonnull stop) {
            [card.chartView reloadData:YES];
        }];
    }

    [self applyDocumentationScrollOffsetIfNeeded];
}

- (void)bindChart:(XYChart *)chartView withDataSource:(DemoChartDataSource *)dataSource
{
    chartView.delegate = self;
    [chartView setDataSource:dataSource animation:NO];
}

- (UILabel *)eventLabelForChart:(XYChart *)chart
{
    return [self cardForChart:chart].eventLabel;
}

#pragma mark - XYChartDelegate

- (BOOL)chart:(XYChart *)chart shouldShowMenu:(NSIndexPath *)index
{
    return chart == self.monthlyLineCard.chartView || chart == self.groupedBarCard.chartView || chart == self.forecastBarCard.chartView;
}

- (void)chart:(XYChart *)chart itemDidClick:(id<XYChartItem>)item
{
    UILabel *eventLabel = [self eventLabelForChart:chart];
    NSString *itemText = item.showName.length > 0 ? item.showName : item.value.stringValue;
    NSString *prefix = chart.type == XYChartTypeBar ? @"Bar selected" : @"Line selected";
    eventLabel.text = [NSString stringWithFormat:@"%@: %@", prefix, itemText];
}

- (CAAnimation *)pulseScaleAnimationWithScale:(CGFloat)scale duration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.fromValue = @1.0;
    animation.toValue = @(scale);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

- (CAAnimation *)bounceLiftAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@0, @-7, @2, @0];
    animation.keyTimes = @[@0, @0.35, @0.72, @1];
    animation.duration = 0.3;
    animation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
    ];
    return animation;
}

- (CAAnimation *)glowPulseAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @0.92;
    scaleAnimation.toValue = @1.12;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.55;
    opacityAnimation.toValue = @1.0;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAnimation, opacityAnimation];
    group.duration = 0.26;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return group;
}

- (CAAnimation *)verticalStretchAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.duration = 0.24;
    animation.autoreverses = YES;
    animation.fromValue = @1.0;
    animation.toValue = @1.1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

- (CAAnimation *)horizontalSqueezeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.values = @[@1.0, @0.9, @1.08, @1.0];
    animation.keyTimes = @[@0, @0.25, @0.68, @1];
    animation.duration = 0.28;
    animation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
    ];
    return animation;
}

- (CAAnimation *)chart:(XYChart *)chart clickAnimationOfIndex:(NSIndexPath *)index
{
    if (chart == self.weeklyLineCard.chartView) {
        return [self pulseScaleAnimationWithScale:1.12 duration:0.24];
    }
    if (chart == self.monthlyLineCard.chartView) {
        return [self bounceLiftAnimation];
    }
    if (chart == self.velocityLineCard.chartView) {
        return [self glowPulseAnimation];
    }
    if (chart == self.groupedBarCard.chartView) {
        return [self verticalStretchAnimation];
    }
    if (chart == self.forecastBarCard.chartView) {
        return [self pulseScaleAnimationWithScale:1.08 duration:0.22];
    }
    return [self horizontalSqueezeAnimation];
}

@end
