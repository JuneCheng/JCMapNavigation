//
//  UIWindow+CurrentViewController.m
//  IOSFrame
//
//  Created by JuneCheng on 2018/11/22.
//  Copyright © 2018  ChengJun. All rights reserved.
//

#import "UIWindow+CurrentViewController.h"

@implementation UIWindow (CurrentViewController)

+ (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end
