//
//  forthViewController.h
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "ASIFormDataRequest.h"
#import "CheckOneViewController.h"
#import "MyDetailViewController.h"
#import "IDViewController.h"
#import "PrivacyViewController.h"
#import "AboutViewController.h"
#define kAppKey             @"2629119497"
#define kAppSecret          @"b940891aad16ae7627de8eaa7322e8c6"
#define kAppRedirectURI     @"http://weibo.com/ch7e"
@interface forthViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>{
    CheckOneViewController *friend;
    MyDetailViewController *person;
    IDViewController *idViewController;
    PrivacyViewController *PrivacyVC;
    AboutViewController *aboutVC;
    UITableView *tableV;
    NSDictionary *words;
    NSArray *keys;
    UIButton *button;
    
    NSString *name;//获取用户名
    BOOL Sina;//新浪绑定
    BOOL renren;//人人绑定
    BOOL bean;//豆瓣绑定
    
    NSString *userUUid;
    
    NSDictionary *dictory;
    int sinaFlag;
    int temp;
    SinaWeibo *sinaWeibo;
    SinaWeiboRequest *sinawoboRequest;
}

@property (nonatomic,retain) NSDictionary *dictory;
@property (nonatomic,retain) NSString *userUUid;
@property(nonatomic,retain)UITableView *tableV;
@property(nonatomic,retain)NSDictionary *words;
@property(nonatomic,retain)NSArray *keys;

@end


