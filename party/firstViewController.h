//
//  firstViewController.h
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHeader.h"
#import "MakefriendViewController.h"
@interface firstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, FriChangeDataSourceDelegate>{
    
    
    UIButton* friendbutton;
    UIButton* partybutton;
    UIButton* systembutton;
    int friend_count;//好友消息数量
    int party_count;//派对消息数量
    int system_count;//系统消息数量
    UIButton* friBtn;
    UIButton* mesBtn;
    UIButton* sysBtn;
    //判断是否是第一次加载，三个消息界面通用
    int flag;
    int total;//判断本次返回数量
    //****************
    
    UITableView *tbView;
    int friendselect;//点击选中的好友消息
    int year;
    int month;
    int day;
    int hour;
    int min;
    int sec;
    UITextField *auctionTime;//倒计时
    int choiceNumber;
    UILabel *lableTime;
    NSString *userUUid;//用户的uuid
    
    NSDictionary *dic;
    //======party用的数据==================
    NSMutableArray *message;
    
    NSDictionary *senderDic;
    NSDictionary *user;
    NSDictionary *partyId;
    NSArray *creaters;
    
    NSNumber *uuid;
 
    UIImageView *imgView;
    //======system用的数据==================
    NSMutableArray* systemArray;
    NSMutableArray *mutablePid;
    NSMutableArray *mutableCid;
    NSMutableArray *mutableCtype;
    
    
    //*************friend用到的数据
    NSMutableArray* friendlist;
    NSString * P_time;
    
    int sendDate;
    int selectRow;
}
@property (nonatomic,retain) NSString *senderTo;
@property (nonatomic,retain) NSArray *creaters;
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSString * P_time;
@property (strong,nonatomic) NSMutableArray* friendlist;
@property (nonatomic,retain) NSDictionary *dic;
@property (nonatomic,retain) UITableView *tbView;
@property (nonatomic,retain) NSMutableArray *systemArray;

@property (nonatomic,retain) UIImageView *imgView;
@property (nonatomic,retain) NSNumber *uuid;
@property (strong,nonatomic) NSMutableArray* message;
@property (nonatomic,retain) NSDictionary *senderDic;
@property (nonatomic,retain) NSDictionary *user;
@property (nonatomic,retain) NSDictionary *partyId;

-(IBAction)buttonParty;
-(IBAction)buttonFriend;
-(IBAction)buttonSystem;
@end
