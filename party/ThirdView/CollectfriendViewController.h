//
//  CollectfriendViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-23.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "friendinfoViewController.h"


@class friendinfoViewController;
@interface CollectfriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    friendinfoViewController* frindeview;
    UITableView* tableview;
    NSInteger Imagerow;
    NSMutableArray* friendlist;

    NSString* C_id;
    NSString *userUUid;
    int flag;
    int total;
    UILabel* message;
    
    int selectRow;
    
}
@property (nonatomic,retain) NSString *userUUid;
@property (strong,nonatomic) NSString* C_id;
@property (strong,nonatomic) NSMutableArray* friendlist;
@end
