//
//  DetailViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-18.
//
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "AciPartyViewController.h"
#import "CollectfriendViewController.h"
#import "CreatPartyViewController.h"
@class AciPartyViewController;
#import "ASIHTTPRequest.h"
@class CollectfriendViewController;
@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    AciPartyViewController* actParty;
    CollectfriendViewController* friends;
    CreatPartyViewController* creatParty;
    NSString* C_title;
    NSString* C_id;
    UITableView *tableview;
    UIImageView* imageview;
    UILabel* Actitle;
    UILabel* Aclabel;
    UILabel* Achost;
    UITextView* Acaddr;
    UIImageView* image1;
    UIImageView* image2;
    UIImageView* image3;
    UIImageView* image4;
    UIImageView* image5;
    UIImageView* image6;
    UIImageView* image7;
    UIImageView* changePicview;
    NSMutableDictionary* dict;
    NSString *userUUid;
    UIButton *joinParty;
}
@property (nonatomic,retain) NSString *userUUid;
@property (strong,nonatomic) NSString* C_title;
@property (strong,nonatomic) NSMutableDictionary* dict;
@property (nonatomic,strong) NSString* C_id;
@property (nonatomic,retain) UITableView *tableview;

@end
