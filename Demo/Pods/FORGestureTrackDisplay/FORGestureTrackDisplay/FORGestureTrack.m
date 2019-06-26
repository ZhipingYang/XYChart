//
//  FORGestureTrack.m
//  FORGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "FORGestureTrack.h"
#import <objc/runtime.h>

#pragma mark - FORTrackGesture Category

@interface FORTrackGesture (Private)
+ (FORTrackGesture *) sharedInstace;
@end

#pragma mark -  FORGestureTrack

@interface FORGestureTrack : UIView <FORGestureDelegate>

@property (nonatomic, strong) UIColor* dotColor;

@property (nonatomic, assign) CGFloat dotWidth;

@end

@implementation FORGestureTrack{
    FORTrackGesture* touchGesture;
    NSMutableDictionary* dots;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self finishInit];
    }
    return self;
}

-(void)finishInit {
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    touchGesture = [FORTrackGesture sharedInstace];
    [touchGesture setTouchDelegate:self];
    dots = [NSMutableDictionary dictionary];
    self.dotWidth = 44;
    self.dotColor = [UIColor lightGrayColor];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}

-(void)setDotColor:(UIColor *)dotColor {
    if(!dotColor) {
        dotColor = [UIColor lightGrayColor];
    }
    _dotColor = dotColor;
}

-(void)updateTouch:(UITouch *)t {
    
    NSMutableSet* seenKeys = [NSMutableSet set];
    CGPoint loc = [t locationInView:self];
    NSNumber* key = [NSNumber numberWithUnsignedInteger:t.hash];
    [seenKeys addObject:key];
    
    UIView* dot = [dots objectForKey:key];
    
    if(!dot){
        dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dotWidth, _dotWidth)];
        dot.backgroundColor = _dotColor;
        dot.layer.cornerRadius = _dotWidth/2;
        dot.tag = key.unsignedIntegerValue;
        [self addSubview:dot];
        [dots setObject:dot forKey:key];
        
        UIView* anim = [[UIView alloc] initWithFrame:dot.frame];
        anim.opaque = NO;
        anim.backgroundColor = [UIColor clearColor];
        anim.layer.cornerRadius = _dotWidth/2;
        anim.layer.borderColor = _dotColor.CGColor;
        anim.layer.borderWidth = 3;
        anim.center = loc;
        anim.tag = NSUIntegerMax;
        [self addSubview:anim];
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            anim.transform = CGAffineTransformMakeScale(1.5, 1.5);
            anim.alpha = 0;
        } completion:^(BOOL finished){
            [anim removeFromSuperview];
        }];
    }
    dot.center = loc;
}

-(void)removeViewFor:(UITouch *)t {
    NSNumber* key = [NSNumber numberWithUnsignedInteger:t.hash];
    UIView* dot = [dots objectForKey:key];
    [dot removeFromSuperview];
    [dots removeObjectForKey:key];
}

-(void)didMoveToSuperview {
    [touchGesture.view removeGestureRecognizer:touchGesture];
    [self.superview addGestureRecognizer:touchGesture];
}

-(void)forTouchesBegan:(NSSet *)touches {
    NSArray* siblings = self.superview.subviews;
    if([siblings indexOfObject:self] != [siblings count]-1){
        // ensure we are the top most view
        [self.superview addSubview:self];
    }
    for(UITouch* t in touches){
        [self updateTouch:t];
    }
}

-(void)forTouchesMoved:(NSSet *)touches {
    for(UITouch* t in touches){
        [self updateTouch:t];
    }
}

-(void)forTouchesEnded:(NSSet *)touches {
    for(UITouch* t in touches){
        [self removeViewFor:t];
    }
}

-(void)forTouchesCancelled:(NSSet *)touches {
    for(UITouch* t in touches){
        [self removeViewFor:t];
    }
}

#pragma mark - Ignore Touches

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

@end


const static char * FORGestureTrackView = "FORGestureTrackView";

@implementation UIWindow (tracking)

- (void)startTracking
{
    self.for_track = [[FORGestureTrack alloc] initWithFrame:self.bounds];
    self.for_track.layer.zPosition = CGFLOAT_MAX;
    [self addSubview:self.for_track];
}

- (void)endTracking
{
    if (self.for_track) {
        [self.for_track removeFromSuperview];
        self.for_track = nil;
    }
}

- (void)setFor_track:(FORGestureTrack *)for_track
{
    objc_setAssociatedObject(self, FORGestureTrackView, for_track, OBJC_ASSOCIATION_RETAIN);
}

- (FORGestureTrack *)for_track
{
    id obj = objc_getAssociatedObject(self, FORGestureTrackView);
    if ([obj isKindOfClass:[FORGestureTrack class]]) {
        return (FORGestureTrack *)obj;
    }
    return nil;
}

@end


