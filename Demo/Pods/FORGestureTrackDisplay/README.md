# FORGestureTrackDisplay
> FORGestureTrackDisplay is debug tool to displaying and tracking all kinds of gustures when user touch the screen.

![untitled](https://cloud.githubusercontent.com/assets/9360037/26645883/43bc2508-466c-11e7-99ec-baebdbf91257.gif)

## Usage

**first method ( Manual )**

> in this way, just the appdelegate.window can track gustures.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self.window startTracking];
    
    return YES;
}
```

**second method ( auto )**
> I highly recommend this way for auto track gestures in all windows.

```objective-c
@implementation NSObject (Runtime)

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}
@end
```

```objective-c
@implementation UIWindow (Runtime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(becomeKeyWindow) swizzledSel:@selector(xy_becomeKeyWindow)];
        [self swizzleInstanceMethodWithOriginSel:@selector(resignKeyWindow) swizzledSel:@selector(xy_resignKeyWindow)];
    });
}

- (void)xy_becomeKeyWindow
{
    [self xy_becomeKeyWindow];
    [self startTracking];
}

- (void)xy_resignKeyWindow
{
    [self xy_resignKeyWindow];
    [self endTracking];
}
@end
```
