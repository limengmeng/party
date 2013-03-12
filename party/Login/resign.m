//
//  resign.m
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "resign.h"

@implementation resign
@synthesize field1,field2,button1,button2;
@synthesize mail,pass;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //*****************************注册或登录*************************************
        field1=[[[UITextField alloc]initWithFrame:CGRectMake(51, 32, 223, 40.5)]autorelease];
        field1.placeholder=@"注册邮箱";
        field1.font=[UIFont systemFontOfSize:14];
        field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //self.field1.backgroundColor=[UIColor redColor];
        [field1 becomeFirstResponder];
        field1.delegate = self;
        
        UITextField *mailFiled=[[UITextField alloc]initWithFrame:CGRectMake(7, 32, 267, 40.5)];
        mailFiled.backgroundColor=[UIColor clearColor];
        mailFiled.userInteractionEnabled=NO;
        mailFiled.background = [UIImage imageNamed:@"ycombouser@2x.png"];
        [self addSubview:mailFiled];
        [mailFiled release];
        
        [self addSubview:self.field1];
        //*****************************注册或登录 end*************************************
        
        //*****************************密码*************************************
        field2=[[[UITextField alloc]initWithFrame:CGRectMake(51, 78, 267, 40.5)]autorelease];
        field2.placeholder=@"填写密码";
        field2.font=[UIFont systemFontOfSize:14];
        field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field2.secureTextEntry = YES;
        //self.field2.backgroundColor=[UIColor redColor];
        field2.delegate = self;
        self.field2.returnKeyType = UIReturnKeyGo;
        
        UITextField *mailFiled1=[[UITextField alloc]initWithFrame:CGRectMake(7, 78, 267, 40.5)];
        mailFiled1.backgroundColor=[UIColor clearColor];
        mailFiled1.userInteractionEnabled=NO;
        mailFiled1.background = [UIImage imageNamed:@"ycombopass@2x.png"];
        [self addSubview:mailFiled1];
        [mailFiled1 release];
        
        [self addSubview:self.field2];
        
        //*****************************密码 end*************************************
        
        //*****************************账号转换按钮*************************************
        button1=[UIButton buttonWithType:UIButtonTypeCustom];
        self.button1.frame=CGRectMake(178, 0, 93, 29);//整个View的y=78；
        button1.backgroundColor=[UIColor clearColor];
        [button1 setBackgroundImage:[UIImage imageNamed:@"denglu@2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.button1];
        //*****************************账号转换按钮 end*************************************
        //*****************************新浪图标*************************************
        button2=[UIButton buttonWithType:UIButtonTypeCustom];
        self.button2.frame=CGRectMake(22, 128, 235, 36);
        [button2 setBackgroundImage:[UIImage imageNamed:@"ycombosina@2x.png"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"ycombosinaing@2x.png"] forState:UIControlStateSelected];
        [self addSubview:self.button2];
        //*****************************新浪图标 end*************************************
    }
    return self;
}


//#pragma textField delegate
//
//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    self.mail=self.field1.text;
//    self.pass=self.field2.text;
//}

-(void)dealloc{
    [super dealloc];
}
@end
