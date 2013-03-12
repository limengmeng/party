//
//  secondViewController.h
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class ASIHTTPRequest;
#import "SRRefreshView.h"
#import "SVSegmentedControl.h"
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import "TwoViewController.h"
#import "CreatPartyViewController.h"
@interface secondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,CLLocationManagerDelegate>
{
    UIBarButtonItem *segmentBar;
    SVSegmentedControl *grayRC;
    UITableView *tableViewParty;
    NSMutableArray* sumArray;
    SRRefreshView *_slimeView;//下拉刷新
    NSString *userUUid;
    int flag;
    CLLocationManager *locationMamager;
    CGFloat lat;//纬度
    CGFloat lng;//经度
    int segmentNum;//标志位，表示当前选择的按钮是附近还是所有，附近=0
    
    int total;//本次接口返回的数量
    TwoViewController *twoViewController;
    CreatPartyViewController *creatPartyViewController;
}



@property float lat,lng;
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) UITableView *tableViewParty;
@property (nonatomic,retain) NSMutableArray *sumArray;
@property (nonatomic) int count;


@end
