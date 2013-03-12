//
//  write_infor.h
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface write_infor : UIView<UITextFieldDelegate>{
    UITextField *field1;//用户名
    UITextField *field2;//年龄
    UIButton *button1; //男
    UIButton *button2; //女
    UIButton *button3; //确认
    UIButton *button4; //返回
    
    UILabel *labelName;//填写资料
    
    NSString *nick;
    NSString *age;
    NSString *sex;
}

@property (nonatomic,retain) UIButton *button4; //返回
@property (nonatomic,retain) UITextField *field1;//用户名
@property (nonatomic,retain) UITextField *field2;//年龄
@property (nonatomic,retain) UIButton *button1; //男
@property (nonatomic,retain) UIButton *button2; //女
@property (nonatomic,retain) UIButton *button3; //确认
@property (nonatomic,retain) UILabel *labelName;//填写资料

@property (nonatomic,retain) NSString *nick;
@property (nonatomic,retain) NSString *age;
@property (nonatomic,retain) NSString *sex;
@end
