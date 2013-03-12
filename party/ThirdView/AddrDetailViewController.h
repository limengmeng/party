//
//  AddrDetailViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-19.
//
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "AciPartyViewController.h"
#import "CollectfriendViewController.h"
#import "CreatPartyViewController.h"
#import "ASIHTTPRequest.h"
@interface AddrDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    AciPartyViewController* actParty;
    CollectfriendViewController* friends;
    CreatPartyViewController* creatParty;
    UIImageView* changePicview;
    NSString* C_id;
    NSDictionary* dict;
    UITableView *tableview;
    UIImageView* imageview;
    UILabel* Actitle;
    UILabel* Acfnum;
    UITextView* Acaddr;
    UIImageView* image1;
    UIImageView* image2;
    UIImageView* image3;
    UIImageView* image4;
    UIImageView* image5;
    UIImageView* image6;
    UIImageView* image7;
    NSString *userUUid;
    NSString* C_title;

    UIButton *joinParty;
}
@property (strong,nonatomic) NSString* C_title;
@property (strong,nonatomic) NSDictionary* dict;
@property (nonatomic,retain) NSString *userUUid;
@property (strong,nonatomic) NSString* C_id;
@property (nonatomic,retain) UITableView *tableview;



@end
