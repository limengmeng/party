//
//  InvitViewController.h
//  Invit
//
//  Created by mac bookpro on 1/20/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>{
    UITextView *txtView;
    UILabel *label;
    UIButton *button;
    
    NSString *invite;
    
    UILabel *uilabel;
    
    int temp;
    
    NSString *examineText;
    
    
    NSString *stitle;
    NSDate *time;
    NSString *info;
    NSString *local;
    
    NSString *from_Creat_C_id;
    NSString *from_Creat_p_type;
    
    NSMutableArray *friendId;
    NSString * phone;
    
    NSString *from_p_id;
    
    NSString *from_time;
    //需要从地图页面传过来的数据
    NSString* map_city;
    NSString* map_local;
    float lat;
    float lng;
    NSString *userUUid;
}
//地图传值用，已释放
@property (strong,nonatomic) NSString * map_city,*map_local;
@property float lat,lng;
//*******************************

@property (nonatomic,retain) NSString *from_time;
@property (nonatomic,retain) NSString *from_p_id;
@property (nonatomic,copy) NSString *from_Creat_C_id;
@property (nonatomic,copy) NSString *from_Creat_p_type;

@property (nonatomic,copy) NSString *stitle;
@property (nonatomic,copy) NSDate *time;
@property (nonatomic,copy) NSString *info;
@property (nonatomic,copy) NSString *local;
@property (nonatomic,copy) NSMutableArray *friendId;
@property (nonatomic,retain) NSString *phone;

@property (nonatomic,retain) NSString *examineText;
@property (nonatomic,retain) UITextView *txtView;
@property (nonatomic,retain) NSString *invite;
@property int temp;
@property (nonatomic,retain) NSString *userUUid;

@end
