//
//  AppDelegate.h
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "firstViewController.h"
#import "secondViewController.h"
#import "thirdViewController.h"
#import "forthViewController.h"
#import "Reachability.h"
#import "DeviceSender.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,DeviceSenderDelegate>
{
    UITabBarController *tbarController;
    Reachability  *hostReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) firstViewController *fcontroller;
@property (strong, nonatomic) secondViewController *scontroller;
@property (strong, nonatomic) thirdViewController *tcontroller;
@property (strong, nonatomic) forthViewController *focontroller;

@end
