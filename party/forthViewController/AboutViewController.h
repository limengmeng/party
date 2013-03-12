//
//  AboutViewController.h
//  AboutView
//
//  Created by 李 萌萌 on 13-1-21.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FunctionViewController;
@class WelcomeViewController;
@interface AboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tableview;
    NSString* myVersions;
    NSArray* mylist;
}
@property (strong,nonatomic) NSArray* mylist;
@property (strong,nonatomic) NSString* myVersions;
@property (strong,nonatomic) UITableView* tableview;
-(void)initVersions:(NSString*)versions;
@end
