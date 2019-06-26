//
//  FORTrackGesture.h
//  FORGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FORGestureDelegate <NSObject>

- (void)forTouchesBegan:(NSSet *)touches;

- (void)forTouchesMoved:(NSSet *)touches;

- (void)forTouchesEnded:(NSSet *)touches;

- (void)forTouchesCancelled:(NSSet *)touches;

@end



@interface FORTrackGesture : UIGestureRecognizer <UIGestureRecognizerDelegate>

@property (readonly) NSSet *activeTouches;

@property (nonatomic, weak) NSObject<FORGestureDelegate>* touchDelegate;


- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithTarget:(id)target action:(SEL)action NS_UNAVAILABLE;

@end
