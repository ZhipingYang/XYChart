//
//  FORTrackGesture.m
//  FORGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "FORTrackGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FORTrackGesture{
    NSMutableSet* activeTouches;
}

static FORTrackGesture* _instance = nil;

- (id)init {
    if(_instance) return _instance;
    if((self = [super init])){
        _instance = self;
        self.delaysTouchesBegan = NO;
        self.delaysTouchesEnded = NO;
        self.cancelsTouchesInView = NO;
        
        activeTouches = [NSMutableSet set];
    }
    return _instance;
}

@synthesize activeTouches;

+ (FORTrackGesture*)sharedInstace {
    if(!_instance){
        _instance = [[[FORTrackGesture class] alloc] init];
        _instance.delegate = _instance;
    }
    return _instance;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [activeTouches unionSet:touches];
    if(self.state == UIGestureRecognizerStatePossible){
        self.state = UIGestureRecognizerStateBegan;
    }else{
        self.state = UIGestureRecognizerStateChanged;
    }
    [_touchDelegate forTouchesBegan:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateChanged;
    [_touchDelegate forTouchesMoved:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [activeTouches minusSet:touches];
    if(![activeTouches count]){
        self.state = UIGestureRecognizerStateEnded;
    }
    [_touchDelegate forTouchesEnded:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [activeTouches minusSet:touches];
    if(![activeTouches count]){
        self.state = UIGestureRecognizerStateEnded;
    }
    [_touchDelegate forTouchesCancelled:touches];
}

#pragma mark - UIGestureRecognizer

- (BOOL) canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer{
    return NO;
}

- (BOOL) shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}


@end
