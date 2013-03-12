//
//  MakefriendViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@protocol FriChangeDataSourceDelegate
-(void)Frichangedatasource;
@end
@interface MakefriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    id<FriChangeDataSourceDelegate> delegate;
    UITableView* tableview;
    UIImageView* picimage;
    NSString* user_id;
    NSDictionary* dict;
    NSString* userUUid;
    UIImageView* changePicview;
}
@property (assign,nonatomic) id<FriChangeDataSourceDelegate> delegate;
@property (strong,nonatomic) NSString* userUUid;

@property (strong,nonatomic) NSDictionary* dict;

@property (strong,nonatomic) NSString* user_id;

@property (strong,nonatomic) UIImageView* picimage;

@end
