//
//  LogInViewController.h
//  party
//
//  Created by yilinlin on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "ASIHTTPRequest.h"
//#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "FriendViewView.h"


#define kAppKey             @"2629119497"
#define kAppSecret          @"b940891aad16ae7627de8eaa7322e8c6"
#define kAppRedirectURI     @"http://weibo.com/ch7e"
@class login,resign,write_infor,write_done,takePhoto,SinaWeibo,FireView;
@interface LogInViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>{
    login *loginView;
    resign *resignView;
    write_done* infodoneView;
    write_infor *infowriteView;
    takePhoto *photoView;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView;
    
    UIDatePicker* datepicker;
    UIToolbar *dateToolbar;
    
    NSString *mail;
    NSString *mail_pass;
    UIImage *user_pic;
    NSString *user_nick;
    NSString *user_age;
    NSString *user_sex;
    
    //====================
    SinaWeibo *sinaWeibo;
    SinaWeiboRequest *sinawoboRequest;
    UILabel *currentAuthNameLabel;     //微博当前账号昵称
    UIButton *changeWeiboUserButton;   //更改微博账号button
    
    NSMutableArray *mutableArray;
    UITableView *tableviewFriend;
    NSNumber *number;
    int numberSum;
    int flogFriend;
    int spot;
    
    NSDictionary *dictory;
    
    NSTimer *timer;
    int move;
    
    NSTimer *timer1;
    int move1;
    
    
}
@property (nonatomic,retain) NSDictionary *dictory;
@property (nonatomic,retain) NSString *mail;
@property (nonatomic,retain) NSString *mail_pass;
@property (nonatomic,retain) UIImage *user_pic;
@property (nonatomic,retain) NSString *user_nick;
@property (nonatomic,retain) NSString *user_age;
@property (nonatomic,retain) NSString *user_sex;

@property (nonatomic,retain) UIToolbar *dateToolbar;

@property (nonatomic,retain) SinaWeibo *sinaweibo;

@property (nonatomic,retain) login *loginView;;
@property (nonatomic,retain) resign *resignView;
@property (nonatomic,retain) write_done* infodoneView;
@property (nonatomic,retain) write_infor *infowriteView;

@property (nonatomic,retain) takePhoto *photoView;

@property (nonatomic,retain) UIImageView *imageView1;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIImageView *imageView2;

@end
