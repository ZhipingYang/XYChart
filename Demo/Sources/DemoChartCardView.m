#import "DemoChartCardView.h"

@interface DemoChartCardView ()

@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) XYChart *chartView;
@property (nonatomic, strong, readwrite) UILabel *eventLabel;
@property (nonatomic, strong) NSLayoutConstraint *chartHeightConstraint;
@property (nonatomic) XYChartType chartType;

@end

@implementation DemoChartCardView

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

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor colorWithRed:0.188 green:0.176 blue:0.157 alpha:1.0];
        _titleLabel.text = title;

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

        _eventLabel = [[UILabel alloc] init];
        _eventLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _eventLabel.numberOfLines = 0;
        _eventLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _eventLabel.textColor = [UIColor colorWithRed:0.569 green:0.345 blue:0.125 alpha:1.0];
        _eventLabel.backgroundColor = [UIColor colorWithRed:0.969 green:0.933 blue:0.859 alpha:1.0];
        _eventLabel.layer.cornerRadius = 12.0;
        _eventLabel.layer.masksToBounds = YES;
        _eventLabel.textAlignment = NSTextAlignmentCenter;
        _eventLabel.text = @"Tap a point or bar to verify delegate callbacks.";

        [self addSubview:_contentStackView];
        [_contentStackView addArrangedSubview:_titleLabel];
        [_contentStackView addArrangedSubview:_subtitleLabel];
        [_contentStackView addArrangedSubview:_chartView];
        [_contentStackView addArrangedSubview:_eventLabel];

        _chartHeightConstraint = [_chartView.heightAnchor constraintEqualToConstant:220.0];

        [NSLayoutConstraint activateConstraints:@[
            [_contentStackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
            [_contentStackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
            [_contentStackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
            [_contentStackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],

            _chartHeightConstraint,
            [_eventLabel.heightAnchor constraintGreaterThanOrEqualToConstant:40.0],
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

- (void)updateLayoutForAvailableWidth:(CGFloat)availableWidth compactHeight:(BOOL)compactHeight
{
    CGFloat clampedWidth = MAX(availableWidth, 280.0);
    CGFloat horizontalMargin = clampedWidth >= 430.0 ? 24.0 : 16.0;
    CGFloat verticalMargin = compactHeight ? 14.0 : 20.0;
    CGFloat chartHeight = [self preferredChartHeightForWidth:clampedWidth compactHeight:compactHeight];

    self.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin);
    self.contentStackView.spacing = compactHeight ? 12.0 : 14.0;
    self.chartHeightConstraint.constant = chartHeight;

    self.titleLabel.font = [UIFont systemFontOfSize:(compactHeight ? 20.0 : 22.0) weight:UIFontWeightSemibold];
    self.subtitleLabel.font = [UIFont systemFontOfSize:(compactHeight ? 12.0 : 13.0) weight:UIFontWeightRegular];
    self.eventLabel.font = [UIFont systemFontOfSize:(compactHeight ? 11.0 : 12.0) weight:UIFontWeightMedium];
}

@end
