//
//  write_done.h
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface write_done :  UIView<UITextFieldDelegate>{
    UILabel *labelName;
    UITextField *field1;//用户名
    UITextField *field2;//年龄
    UIButton *button1; //男
    UIButton *button2; //女
    UIButton *button3; //确认
    UIButton *button4;
    
    UIImageView *imgView;
}

@property (nonatomic,retain) UILabel *labelName;
@property (nonatomic,retain) UIImageView *imgView;
@property (nonatomic,retain) UITextField *field1;//
@property (nonatomic,retain) UITextField *field2;//
@property (nonatomic,retain) UIButton *button1; //男
@property (nonatomic,retain) UIButton *button2; //女
@property (nonatomic,retain) UIButton *button3; //确认
@property (nonatomic,retain) UIButton *button4;

@end
