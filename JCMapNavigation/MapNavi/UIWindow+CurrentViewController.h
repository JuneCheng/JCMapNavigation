//
//  UIWindow+CurrentViewController.h
//  IOSFrame
//
//  Created by JuneCheng on 2018/11/22.
//  Copyright © 2018  ChengJun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (CurrentViewController)

+ (UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
