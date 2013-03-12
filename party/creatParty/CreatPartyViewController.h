//
//  CreatPartyViewController.h
//  party
//
//  Created by yilinlin on 13-1-19.
//
//

#import <UIKit/UIKit.h>
#import "CheckOneViewController.h"
#import "MapViewController.h"
@interface CreatPartyViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ContactCtrlDelegate,UIAlertViewDelegate,passValueDelegate,UITextViewDelegate>{
    UITextField *activityName;
    UITextField *activityTime;
    UITextField *activityPlace;
    
    UITextField *creat;
    UITextView *introduce;
    
    UIToolbar *keyboardToolbar;
    UIDatePicker *DatePicker;
    
    NSDate *time;
    UITableView *tableviewF;
    NSMutableArray *friengArr;
    
    UIButton *btn;//创建按钮
    
    NSString *P_title;
    NSString *P_time;
    NSString *P_info;
    NSString *P_local;
    
    NSString *from_C_title;
    NSString *from_C_id;
    NSString *from_P_type;
    
    //需要从地图页面传过来的数据
    NSString* map_city;
    NSString* map_local;
    float lat;
    float lng;
    
    UITextField *textField1;
    
}
//地图传值用，已释放

@property (strong,nonatomic) NSString * map_city,*map_local;
@property float lat,lng;
//*******************************

@property (nonatomic,retain) NSString *P_title;

@property (nonatomic,retain) NSString *P_time;

@property (nonatomic,retain) NSString *P_info;

@property (nonatomic,retain) NSString *P_local;

@property (nonatomic,retain) NSString *from_C_title;

@property (nonatomic,retain) NSString *from_C_id;

@property (nonatomic,retain) NSString *from_P_type;

@property (nonatomic, retain) UITextField *activityName;

@property (nonatomic, retain) UITextField *activityTime;

@property (nonatomic, retain) UITextField *activityPlace;

@property (nonatomic, retain) UITextField *creat;

@property (nonatomic, retain) UITextView *introduce;

@property (nonatomic, retain) UIToolbar *keyboardToolbar;

@property (nonatomic, retain) UIDatePicker *DatePicker;

@property (nonatomic, retain) NSDate *time;


@end
