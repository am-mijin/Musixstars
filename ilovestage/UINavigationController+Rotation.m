//
//  UINavigationController+Rotation.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController(Rotation)

- (NSUInteger)supportedInterfaceOrientations {
    if (self.topViewController.presentedViewController) {
        return self.topViewController.presentedViewController.supportedInterfaceOrientations;
    }
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
