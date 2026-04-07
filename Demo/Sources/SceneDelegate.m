#import "SceneDelegate.h"
#import "DemoViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    (void)session;
    (void)connectionOptions;
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }

    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = [UIColor colorWithRed:0.965 green:0.949 blue:0.918 alpha:1.0];
    self.window.rootViewController = [[DemoViewController alloc] init];
    [self.window makeKeyAndVisible];
}

@end
