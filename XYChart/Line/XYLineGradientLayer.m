//
//  XYLineGradientLayer.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYLineGradientLayer.h"

@interface XYLineGradientLayer()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) id <XYChartItem>pre;
@property (nonatomic, strong) id <XYChartItem>next;
@property (nonatomic) XYRange range;

@property (nonatomic, strong) CADisplayLink *link;
    
@end

@implementation XYLineGradientLayer

+ (instancetype)layerWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range
{
    XYLineGradientLayer *gradient = [super layer];
    [gradient updateWithPre:pre next:next range:range];
    return gradient;
}

- (void)dealloc
{
    [_link invalidate];
}

- (void)updateWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range
{
    self.hidden = !pre || !next;
    if (self.hidden) { return; }
    
    _pre = pre;
    _next = next;
    _range = range;

    CGFloat startY = pre.value.floatValue > next.value.floatValue ? 0:1;
    CGFloat endY = pre.value.floatValue > next.value.floatValue ? 1:0;
    self.colors = @[(id)pre.color.CGColor, (id)next.color.CGColor];
    self.startPoint = CGPointMake(0, startY);
    self.endPoint = CGPointMake(1, endY);
    
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = XYChartLineWidth;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        [self addSublayer:_shapeLayer];
        self.mask = _shapeLayer;
    }
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    CGFloat topY = XYChartLineWidth*2;
    CGFloat bottomY = (xy_height(self)-XYChartLineWidth*2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, _pre.value.floatValue>_next.value.floatValue ? topY : bottomY);
    CGPathAddLineToPoint(path, NULL, xy_width(self), _pre.value.floatValue>_next.value.floatValue ? bottomY : topY);
    _shapeLayer.frame = CGRectMake(0, 0, xy_width(self), xy_height(self));
    _shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)startAnimate:(BOOL)animate
{
    if (animate == NO) { return; }
    if (_shapeLayer.strokeEnd > 0 && _shapeLayer.strokeEnd < 1) { return; }
    
    _shapeLayer.strokeEnd = 0;
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateFlipAction)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
    
- (void)animateFlipAction
{
    _shapeLayer.strokeEnd += 1/(60.0 * self.pre.duration);
    if (_shapeLayer.strokeEnd > 1) {
        [_link invalidate];
        _link = nil;
        _shapeLayer.strokeEnd = 1;
    }
}

@end
