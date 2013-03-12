//
//  infoViewController.h
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"

@interface infoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
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
