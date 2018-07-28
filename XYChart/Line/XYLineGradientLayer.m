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

@end

@implementation XYLineGradientLayer

+ (instancetype)layerWithPre:(id<XYChartItem>)pre next:(id<XYChartItem>)next range:(XYRange)range
{
    CGFloat startY = pre.value.floatValue > next.value.floatValue ? 0:1;
    CGFloat endY = pre.value.floatValue > next.value.floatValue ? 1:0;

    XYLineGradientLayer *gradient = [super layer];
    gradient.pre = pre;
    gradient.next = next;
    gradient.range = range;
    gradient.colors = @[(id)pre.color.CGColor, (id)next.color.CGColor];
    gradient.startPoint = CGPointMake(0, startY);
    gradient.endPoint = CGPointMake(1, endY);
    
    gradient.hidden = !pre || !next;
    
    return gradient;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    _shapeLayer.frame = self.bounds;
    
    CGFloat topY = XYChartLineWidth*2;
    CGFloat bottomY = (xy_height(self)-XYChartLineWidth*2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, _pre.value.floatValue>_next.value.floatValue ? topY : bottomY);
    CGPathAddLineToPoint(path, NULL, xy_width(self), _pre.value.floatValue>_next.value.floatValue ? bottomY : topY);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, xy_width(self), xy_height(self));
    shapeLayer.lineWidth = XYChartLineWidth;
    shapeLayer.path = path;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self addSublayer:shapeLayer];
    self.mask = shapeLayer;
    
    CGPathRelease(path);
}

@end

