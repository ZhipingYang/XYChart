//
//  AppDelegate.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "AppDelegate.h"
#import <FORGestureTrack.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window startTracking];
    return YES;
}

@end
