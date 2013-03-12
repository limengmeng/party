//
//  MyDetailViewController.h
//  Mydetail
//
//  Created by 李 萌萌 on 13-1-20.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeMyInfoViewController.h"
#import "ASIHTTPRequest.h"
@class ZoominViewController;

@class areaPicker;
@class sexPicker;
@interface MyDetailViewController : UIViewController<PassValueDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate>
{
   
    int ChangePic;//判断用户是否更改自己的图片
    int Changeinfo;//判断用户是否更改了信息
    UITextView* detail;
    UIImage* picture;
    UITableView* tableview;
    NSArray* mylist;
    UIImageView* imageview;
    UIImageView* changePicview;
    UITextField* namefield;
    UITextField* sexfield;
    UITextField* localfield;
    UITextField* agefield;
    areaPicker* areapic;
    sexPicker* sexpic;
    UIToolbar *areaboardToolbar;
    NSDictionary* dict;
    UIDatePicker* datepicker;
    
    NSString *userUUid; 
    
    NSString* mycity;
    NSString* mylocal;

}
@property int ChangePic,Changeinfo;
@property (strong,nonatomic) NSString* mycity;
@property (strong,nonatomic) NSString* mylocal;
@property (strong,nonatomic) NSString *userUUid;
@property (strong,nonatomic) NSDictionary* dict;

@property (strong,nonatomic) NSMutableString* mydetailstring;
@property (strong,nonatomic) UITableView* tableview;
@property (strong,nonatomic) NSArray* mylist;
@end
