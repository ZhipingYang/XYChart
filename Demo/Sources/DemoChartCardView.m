#import "DemoChartCardView.h"

@interface DemoChartCardView ()

@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UIStackView *headerStackView;
@property (nonatomic, strong) UIStackView *titleStackView;
@property (nonatomic, strong) UIView *accentContainerView;
@property (nonatomic, strong) UIView *accentView;
@property (nonatomic, strong) UIView *eventContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *metaLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *legendLabel;
@property (nonatomic, strong) UIButton *replayButton;
@property (nonatomic, strong, readwrite) XYChart *chartView;
@property (nonatomic, strong, readwrite) UILabel *eventLabel;
@property (nonatomic, strong) NSLayoutConstraint *chartHeightConstraint;
@property (nonatomic) XYChartType chartType;
@property (nonatomic, copy) NSArray<NSString *> *currentLegendTitles;
@property (nonatomic, copy) NSArray<UIColor *> *currentLegendColors;
@property (nonatomic, strong) UIColor *currentAccentColor;
@property (nonatomic) BOOL isCompactHeight;

@end

@implementation DemoChartCardView

static UIColor *XYDemoAccentBackgroundColor(UIColor *color)
{
    return [color colorWithAlphaComponent:0.14];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle chartType:(XYChartType)chartType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.chartType = chartType;
        self.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(20.0, 20.0, 18.0, 20.0);
        self.backgroundColor = [UIColor colorWithRed:0.992 green:0.984 blue:0.969 alpha:1.0];
        self.layer.cornerRadius = 20.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithRed:0.871 green:0.835 blue:0.761 alpha:1.0].CGColor;
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1.0].CGColor;
        self.layer.shadowOpacity = 0.06;
        self.layer.shadowOffset = CGSizeMake(0, 8);
        self.layer.shadowRadius = 20.0;

        _contentStackView = [[UIStackView alloc] init];
        _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentStackView.axis = UILayoutConstraintAxisVertical;
        _contentStackView.spacing = 14.0;

        _headerStackView = [[UIStackView alloc] init];
        _headerStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _headerStackView.axis = UILayoutConstraintAxisHorizontal;
        _headerStackView.alignment = UIStackViewAlignmentTop;
        _headerStackView.spacing = 12.0;

        _titleStackView = [[UIStackView alloc] init];
        _titleStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _titleStackView.axis = UILayoutConstraintAxisVertical;
        _titleStackView.spacing = 6.0;
        [_titleStackView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

        _accentContainerView = [[UIView alloc] init];
        _accentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        _accentContainerView.hidden = YES;

        _accentView = [[UIView alloc] init];
        _accentView.translatesAutoresizingMaskIntoConstraints = NO;
        _accentView.layer.cornerRadius = 3.0;
        _accentView.hidden = YES;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor colorWithRed:0.188 green:0.176 blue:0.157 alpha:1.0];
        _titleLabel.text = title;

        _metaLabel = [[UILabel alloc] init];
        _metaLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _metaLabel.numberOfLines = 0;
        _metaLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
        _metaLabel.textColor = [UIColor colorWithRed:0.514 green:0.475 blue:0.424 alpha:1.0];
        _metaLabel.hidden = YES;

        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _subtitleLabel.textColor = [UIColor colorWithRed:0.420 green:0.388 blue:0.345 alpha:1.0];
        _subtitleLabel.text = subtitle;

        _chartView = [[XYChart alloc] initWithType:chartType];
        _chartView.translatesAutoresizingMaskIntoConstraints = NO;
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.layer.cornerRadius = 14.0;
        _chartView.layer.masksToBounds = YES;
        _chartView.layer.borderWidth = 1.0;
        _chartView.layer.borderColor = [UIColor colorWithRed:0.918 green:0.902 blue:0.863 alpha:1.0].CGColor;

        _legendLabel = [[UILabel alloc] init];
        _legendLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _legendLabel.numberOfLines = 0;
        _legendLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _legendLabel.textColor = [UIColor colorWithRed:0.369 green:0.345 blue:0.314 alpha:1.0];
        _legendLabel.hidden = YES;

        _replayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _replayButton.translatesAutoresizingMaskIntoConstraints = NO;
        _replayButton.layer.cornerRadius = 12.0;
        _replayButton.layer.borderWidth = 1.0;
        _replayButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _replayButton.contentEdgeInsets = UIEdgeInsetsMake(8.0, 12.0, 8.0, 12.0);
        _replayButton.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        _replayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, -6.0);
        [_replayButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_replayButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_replayButton setTitle:@"Replay" forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_replayButton setImage:[UIImage systemImageNamed:@"arrow.clockwise"] forState:UIControlStateNormal];
        }
        [_replayButton addTarget:self action:@selector(handleReplayTap) forControlEvents:UIControlEventTouchUpInside];

        _eventContainerView = [[UIView alloc] init];
        _eventContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        _eventContainerView.layer.cornerRadius = 12.0;
        _eventContainerView.layer.borderWidth = 1.0;
        _eventContainerView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(10.0, 14.0, 10.0, 14.0);

        _eventLabel = [[UILabel alloc] init];
        _eventLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _eventLabel.numberOfLines = 0;
        _eventLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _eventLabel.textColor = [UIColor colorWithRed:0.569 green:0.345 blue:0.125 alpha:1.0];
        _eventLabel.backgroundColor = UIColor.clearColor;
        _eventLabel.textAlignment = NSTextAlignmentLeft;
        _eventLabel.text = @"Tap a point or bar to verify delegate callbacks.";

        [self addSubview:_contentStackView];
        [_contentStackView addArrangedSubview:_accentContainerView];
        [_contentStackView addArrangedSubview:_headerStackView];
        [_headerStackView addArrangedSubview:_titleStackView];
        [_headerStackView addArrangedSubview:_replayButton];
        [_titleStackView addArrangedSubview:_titleLabel];
        [_titleStackView addArrangedSubview:_metaLabel];
        [_contentStackView addArrangedSubview:_subtitleLabel];
        [_contentStackView addArrangedSubview:_chartView];
        [_contentStackView addArrangedSubview:_legendLabel];
        [_contentStackView addArrangedSubview:_eventContainerView];
        [_accentContainerView addSubview:_accentView];
        [_eventContainerView addSubview:_eventLabel];

        _chartHeightConstraint = [_chartView.heightAnchor constraintEqualToConstant:220.0];

        [NSLayoutConstraint activateConstraints:@[
            [_contentStackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
            [_contentStackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
            [_contentStackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
            [_contentStackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],

            [_accentContainerView.heightAnchor constraintEqualToConstant:6.0],
            [_accentView.leadingAnchor constraintEqualToAnchor:_accentContainerView.leadingAnchor],
            [_accentView.topAnchor constraintEqualToAnchor:_accentContainerView.topAnchor],
            [_accentView.bottomAnchor constraintEqualToAnchor:_accentContainerView.bottomAnchor],
            [_accentView.widthAnchor constraintEqualToConstant:58.0],
            [_replayButton.heightAnchor constraintGreaterThanOrEqualToConstant:36.0],
            _chartHeightConstraint,
            [_eventContainerView.heightAnchor constraintGreaterThanOrEqualToConstant:44.0],
            [_eventLabel.topAnchor constraintEqualToAnchor:_eventContainerView.layoutMarginsGuide.topAnchor],
            [_eventLabel.leadingAnchor constraintEqualToAnchor:_eventContainerView.layoutMarginsGuide.leadingAnchor],
            [_eventLabel.trailingAnchor constraintEqualToAnchor:_eventContainerView.layoutMarginsGuide.trailingAnchor],
            [_eventLabel.bottomAnchor constraintEqualToAnchor:_eventContainerView.layoutMarginsGuide.bottomAnchor],
        ]];

        [self updateLayoutForAvailableWidth:390.0 compactHeight:NO];
    }
    return self;
}

- (CGFloat)preferredChartHeightForWidth:(CGFloat)availableWidth compactHeight:(BOOL)compactHeight
{
    CGFloat clampedWidth = MAX(availableWidth, 280.0);
    if (self.chartType == XYChartTypeBar) {
        CGFloat ratio = compactHeight ? 0.30 : 0.42;
        return MIN(MAX(clampedWidth * ratio, 170.0), 280.0);
    }
    
    CGFloat ratio = compactHeight ? 0.34 : 0.52;
    return MIN(MAX(clampedWidth * ratio, 190.0), 300.0);
}

- (void)handleReplayTap
{
    [UIView animateWithDuration:0.14
                     animations:^{
        self.replayButton.transform = CGAffineTransformMakeScale(0.94, 0.94);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.22
                              delay:0
             usingSpringWithDamping:0.72
              initialSpringVelocity:0.35
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.replayButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    if (self.replayHandler) {
        self.replayHandler(self);
    }
}

- (void)updateLegendLabel
{
    if (self.currentLegendTitles.count == 0) {
        self.legendLabel.attributedText = nil;
        self.legendLabel.hidden = YES;
        return;
    }

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    CGFloat markerFontSize = self.isCompactHeight ? 12.0 : 13.0;
    CGFloat textFontSize = self.isCompactHeight ? 11.0 : 12.0;
    [self.currentLegendTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"    "]];
        }
        UIColor *color = idx < self.currentLegendColors.count ? self.currentLegendColors[idx] : [UIColor secondaryLabelColor];
        NSDictionary *dotAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:markerFontSize weight:UIFontWeightBold],
            NSForegroundColorAttributeName: color
        };
        NSDictionary *titleAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:textFontSize weight:UIFontWeightMedium],
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.369 green:0.345 blue:0.314 alpha:1.0]
        };
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"o" attributes:dotAttributes]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", title] attributes:titleAttributes]];
    }];
    self.legendLabel.attributedText = text;
    self.legendLabel.hidden = NO;
}

- (void)updatePresentationWithBadges:(NSArray<NSString *> *)badges
                        legendTitles:(NSArray<NSString *> *)legendTitles
                        legendColors:(NSArray<UIColor *> *)legendColors
                     interactionHint:(NSString *)interactionHint
                          replayTitle:(NSString *)replayTitle
                         accentColor:(UIColor *)accentColor
{
    self.metaLabel.text = badges.count > 0 ? [badges componentsJoinedByString:@"  |  "] : nil;
    self.metaLabel.hidden = badges.count == 0;

    self.currentLegendTitles = [legendTitles copy];
    self.currentLegendColors = [legendColors copy];
    [self updateLegendLabel];

    self.eventLabel.text = interactionHint;
    [self.replayButton setTitle:replayTitle.length > 0 ? replayTitle : @"Replay" forState:UIControlStateNormal];

    UIColor *accent = accentColor ?: [UIColor colorWithRed:0.569 green:0.345 blue:0.125 alpha:1.0];
    self.currentAccentColor = accent;
    if (accentColor) {
        self.accentContainerView.hidden = NO;
        self.accentView.hidden = NO;
        self.accentView.backgroundColor = accent;
        self.eventContainerView.backgroundColor = XYDemoAccentBackgroundColor(accent);
        self.eventContainerView.layer.borderColor = [accent colorWithAlphaComponent:0.18].CGColor;
        self.eventLabel.textColor = accent;
    } else {
        self.accentContainerView.hidden = YES;
        self.accentView.hidden = YES;
        self.eventContainerView.backgroundColor = [UIColor colorWithRed:0.969 green:0.933 blue:0.859 alpha:1.0];
        self.eventContainerView.layer.borderColor = [UIColor colorWithRed:0.902 green:0.855 blue:0.761 alpha:1.0].CGColor;
        self.eventLabel.textColor = accent;
    }
    self.replayButton.tintColor = accent;
    self.replayButton.layer.borderColor = [accent colorWithAlphaComponent:0.18].CGColor;
    self.replayButton.backgroundColor = [accent colorWithAlphaComponent:0.08];
    self.chartView.layer.borderColor = [accent colorWithAlphaComponent:0.14].CGColor;
}

- (void)updateLayoutForAvailableWidth:(CGFloat)availableWidth compactHeight:(BOOL)compactHeight
{
    CGFloat clampedWidth = MAX(availableWidth, 280.0);
    CGFloat horizontalMargin = clampedWidth >= 430.0 ? 24.0 : 16.0;
    CGFloat verticalMargin = compactHeight ? 14.0 : 20.0;
    CGFloat chartHeight = [self preferredChartHeightForWidth:clampedWidth compactHeight:compactHeight];

    self.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin);
    self.contentStackView.spacing = compactHeight ? 12.0 : 14.0;
    self.chartHeightConstraint.constant = chartHeight;
    self.isCompactHeight = compactHeight;

    self.titleLabel.font = [UIFont systemFontOfSize:(compactHeight ? 20.0 : 22.0) weight:UIFontWeightSemibold];
    self.metaLabel.font = [UIFont systemFontOfSize:(compactHeight ? 10.0 : 11.0) weight:UIFontWeightSemibold];
    self.subtitleLabel.font = [UIFont systemFontOfSize:(compactHeight ? 12.0 : 13.0) weight:UIFontWeightRegular];
    self.eventLabel.font = [UIFont systemFontOfSize:(compactHeight ? 11.0 : 12.0) weight:UIFontWeightMedium];
    self.headerStackView.spacing = compactHeight ? 10.0 : 12.0;
    self.titleStackView.spacing = compactHeight ? 4.0 : 6.0;
    self.replayButton.titleLabel.font = [UIFont systemFontOfSize:(compactHeight ? 11.0 : 12.0) weight:UIFontWeightSemibold];
    self.replayButton.contentEdgeInsets = compactHeight ? UIEdgeInsetsMake(7.0, 10.0, 7.0, 10.0) : UIEdgeInsetsMake(8.0, 12.0, 8.0, 12.0);
    self.eventContainerView.directionalLayoutMargins = compactHeight ? NSDirectionalEdgeInsetsMake(8.0, 12.0, 8.0, 12.0) : NSDirectionalEdgeInsetsMake(10.0, 14.0, 10.0, 14.0);
    [self updateLegendLabel];
}

@end
