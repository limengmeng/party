//
//  login.h
//  resign
//
//  Created by mac bookpro on 1/26/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface login : UIView<UITextFieldDelegate>{
    UITextField *field1;//注册，登陆
    UITextField *field2;//密码
    UIButton *button1; //已有账号转换
    UIButton *button2; //新浪
    UIButton *button;//忘了
    
    NSString *mail;
    NSString *pass;
}

@property (nonatomic,retain) NSString *mail;
@property (nonatomic,retain) NSString *pass;

@property (nonatomic,retain) UITextField *field1;//注册，登陆
@property (nonatomic,retain) UITextField *field2;//密码
@property (nonatomic,retain) UIButton *button1; //已有账号转换
@property (nonatomic,retain) UIButton *button2; //新浪
@property (nonatomic,retain) UIButton *button;//忘了

@end
