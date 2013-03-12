//
//  friendinfoViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-23.
//
//


#import "ASIHTTPRequest.h"
@interface friendinfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITableView* tableview;
    UIImageView* picimage;
    NSString* user_id;
    NSInteger flag;
    NSDictionary* dict;
    NSString *userUUid;
    UIImageView* changePicview;

}
@property (strong,nonatomic) NSDictionary* dict;
@property (nonatomic,retain) NSString *userUUid;
@property (strong,nonatomic) NSString* user_id;
@property NSInteger flag;
@property (strong,nonatomic) UIImageView* picimage;

@end
