//
//  CheckOneViewController.h
//  NavaddTab
//
//  Created by ldci 尹 on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;

@protocol ContactCtrlDelegate

//回调关闭窗口
- (void)CallBack:(NSMutableArray *)muArr; //回调传值

@end
//#import "SecondLevelViewController.h"
@interface CheckOneViewController : UITableViewController
{
    NSMutableArray* list;//好友列表
    NSMutableArray* playList;//玩伴列表
    
    NSIndexPath* lastIndexPath;
    //UITableViewCell* Cell;
    NSMutableArray *choiceFriends;
    int temp;
    id <ContactCtrlDelegate>delegateFriend;
    int spot;//识别
    
    NSString *from_p_id;
    
    NSString *from_c_id;
    
    NSString *userUUid;
    
    int dataFlag;
    
}
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSString *from_c_id;
@property (nonatomic,retain) NSString *from_p_id;
@property int spot;
@property (strong,nonatomic) NSMutableArray* list;
@property (strong,nonatomic) NSMutableArray* playList;

@property (strong,nonatomic) NSIndexPath* lastIndexPath;
//@property (strong,nonatomic) IBOutlet UITableViewCell* Cell;
@property(nonatomic,retain)id <ContactCtrlDelegate>delegateFriend;
@property (nonatomic,retain) NSMutableArray *choiceFriends;
@end
