//
//  AciPartyViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-18.
//
//

#import <UIKit/UIKit.h>
@class PartyDetailViewController;
#import "QuartzCore/QuartzCore.h"
#import "ASIHTTPRequest.h"
#import "FiveViewController.h"
@class PartyDetailViewController;

@interface AciPartyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    FiveViewController* partyDetail;
    int flag;
    int total;//本次接口返回的party数量
    
    UITableView *tableview;
    NSMutableArray* sumArray;//活动里面总的信息
    NSString *stringLable;//活动标签
    //NSNumber * number;
    NSString *stringPartyName;//传递数值上个界面来的值
    NSString *stringNamePID;//传值传入下个界面

    NSString *userUUid;
    NSString* P_label;
}
@property (strong,nonatomic) NSString* P_label;
@property (nonatomic,retain) NSString *userUUid;
@property (strong,nonatomic) UITableView* tableview;
@property (strong,nonatomic) NSMutableArray* sumArray;
@property (retain,nonatomic) NSString *stringPartyName;
@property (retain,nonatomic) NSString *stringNamePID;
@end
