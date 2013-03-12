//
//  AppDelegate.m
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"


#define alert_tag_push 10

@interface AppDelegate()

-(void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize fcontroller=_fcontroller;
@synthesize scontroller=_scontroller;
@synthesize tcontroller=_tcontroller;
@synthesize focontroller=_focontroller;

- (void)dealloc
{
    [_fcontroller release];
    [_scontroller release];
    [_tcontroller release];
    [_focontroller release];
    [_window release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    //或者UIStatusBarStyleDefault
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
    [hostReach startNotifier];
    
    NSMutableArray *controllers=[NSMutableArray array];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //firstController
    self.fcontroller=[[[firstViewController alloc]initWithNibName:@"firstViewController" bundle:nil]autorelease];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:self.fcontroller];
    [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"top22@2x.png"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:nav1];
    [nav1 release];
    
    //secondController
    self.scontroller=[[[secondViewController alloc]initWithNibName:@"secondViewController" bundle:nil]autorelease];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:self.scontroller];
    [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"top22@2x.png"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:nav2];
    [nav2 release];
    
    //thirdController
    self.tcontroller=[[[thirdViewController alloc]initWithNibName:@"thirdViewController" bundle:nil]autorelease];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:self.tcontroller];
    [nav3.navigationBar setBackgroundImage:[UIImage imageNamed:@"top22@2x.png"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:nav3];
    [nav3 release];
    
    //forthController
    self.focontroller=[[[forthViewController alloc]initWithNibName:@"forthViewController" bundle:nil]autorelease];
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:self.focontroller];
    [nav4.navigationBar setBackgroundImage:[UIImage imageNamed:@"top22@2x.png"] forBarMetrics:UIBarMetricsDefault];
    [controllers addObject:nav4];
    [nav4 release];
    
    
    tbarController=[[UITabBarController alloc]init];
    tbarController.delegate=self;
    tbarController.viewControllers=controllers;
    tbarController.customizableViewControllers=controllers;
    [[tbarController tabBar] setSelectedImageTintColor:[UIColor whiteColor]];
    [[tbarController tabBar] setBackgroundColor:[UIColor whiteColor]];
    [[tbarController tabBar] setBackgroundImage:[UIImage imageNamed:@"dilan@2x.png"]];
    [[tbarController tabBar] selectionIndicatorImage];
    [self.window addSubview:tbarController.view];
    [[tbarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"touming@2x.png"]];
    [tbarController setSelectedIndex:1];
    
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"xiaoxi321@2x.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"xiaoxi123@2x.png"];
    
    UITabBar *tabBar0 = tbarController.tabBar;
    UITabBarItem *item0 = [tabBar0.items objectAtIndex:0];
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    UIImage *selectedImage1 = [UIImage imageNamed:@"paidui123@2x.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"paidui321@2x.png"];
    UITabBar *tabBar1 = tbarController.tabBar;
    UITabBarItem *item1 = [tabBar1.items objectAtIndex:1];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    UIImage *selectedImage2 = [UIImage imageNamed:@"huodong123@2x.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"huodong321@2x.png"];
    UITabBar *tabBar2 = tbarController.tabBar;
    UITabBarItem *item2 = [tabBar2.items objectAtIndex:2];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    UIImage *selectedImage3 = [UIImage imageNamed:@"shezhi321@2x.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"shezhi123@2x.png"];
    UITabBar *tabBar3 = tbarController.tabBar;
    UITabBarItem *item3 = [tabBar3.items objectAtIndex:3];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"Guo.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSLog(@"ffffffffffffffffffffff%@",stringmutable);
    if (stringmutable==nil)
    {
        LogInViewController *login=[[LogInViewController alloc]init];
        [self.window addSubview:login.view];
    }
    [self.window makeKeyAndVisible];
    
    /** 注册推送通知功能, */
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    //判断程序是不是由推送服务完成的
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            [self alertNotice:@"" withMSG:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容" cancleButtonTitle:@"知道了" otherButtonTitle:nil];
        }
    }

    return YES;
    

}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
        [soundAlert release];
    }
}
-(void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers
{
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //点击提示框的打开
    application.applicationIconBadgeNumber = 0;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当程序还在后天运行
    application.applicationIconBadgeNumber = 0;
}

#pragma mark - 实现远程推送需要实现的监听接口
/** 接收从苹果服务器返回的唯一的设备token，该token需要发送回推送服务器*/
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
	NSLog(@"apns -> 生成的devToken:%@", token);
    //    [self alertNotice:@"" withMSG:[NSString stringWithFormat:@"从苹果推送服务器返回的设备标识:%@",deviceToken] cancleButtonTitle:@"Ok" otherButtonTitle:@""];
    DeviceSender* sender = [[DeviceSender alloc]initWithDelegate:self ];
    [sender sendDeviceToPushServer:token ];
    [sender release];
}


/** 接收注册推送通知功能时出现的错误，并做相关处理*/
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", err);
    //    [self alertNotice:@"注册推送功能时发生错误" withMSG:[err localizedDescription] cancleButtonTitle:@"Ok" otherButtonTitle:@""];
}

//程序处于启动状态，或者在后台运行时，会接收到推送消息，解析处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    //把icon上的标记数字设置为0,
    application.applicationIconBadgeNumber = 0;
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"**推送消息**"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"处理推送内容",nil];
        alert.tag = alert_tag_push;
        [alert show];
        [alert release];
    }
}

#pragma mark - 处理推送服务器push过来的数据
-(void) pushAlertButtonClicked:(NSInteger)buttonIndex
{
    NSLog(@"响应推送对话框");
    if (buttonIndex == 0) {
        NSLog(@"--->点了第一个按钮");
    } else {
        NSLog(@"--->点了第二个按钮");
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case alert_tag_push:
        {
            [self pushAlertButtonClicked:buttonIndex];
        }
            break;
        default:
            break;
    }
}

-(void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle
{
    UIAlertView *alert;
    if(!otherTitle || [otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    [alert show];
    [alert release];
}

#pragma mark - 实现代理接口：DeviceSenderDelegate
- (void)didSendDeviceFailed:(DeviceSender *)sender withError:(NSError *)error
{
    NSLog(@"apns -> 发送设备标识到服务器失败:%@", error);
    //    [self alertNotice:@"错误" withMSG:@"发送设备标识到服务器失败" cancleButtonTitle:@"确定" otherButtonTitle:nil ];
    [sender release ];
}

- (void)didSendDeviceSuccess:(DeviceSender *)sender
{
    NSLog(@"apns -> 设备标识已发送到服务器");
    //    [self alertNotice:@"" withMSG:@"设备标识已发送到服务器" cancleButtonTitle:@"确定" otherButtonTitle:nil ];
    [sender release];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进入后台时要进行的处理
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //进入前台时要进行的处理
}

@end
