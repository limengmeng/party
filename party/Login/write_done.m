//
//  write_done.m
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "write_done.h"

@implementation write_done
@synthesize field1,field2,button1,button2,button3,button4;
@synthesize imgView;
@synthesize labelName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //*****************************标题*************************************
        labelName=[[[UILabel alloc]initWithFrame:CGRectMake(118, 18, 84, 19)]autorelease];
        labelName.text=@"填写资料";
        labelName.textColor=[UIColor redColor];
        labelName.font=[UIFont systemFontOfSize:20];
        labelName.backgroundColor=[UIColor clearColor];
        [self addSubview:self.labelName];
        //*****************************标题 end*************************************
        
        //*****************************用户头像*************************************
        imgView=[[[UIImageView alloc]initWithFrame:CGRectMake(115, 53, 86, 86)]autorelease];
        imgView.image=[UIImage imageNamed:@"sina-userphoto@2x.png"];
        [self addSubview:self.imgView];
        
        //*****************************用户头像end*************************************
        
        
        
        //*****************************用户名*************************************
        field1=[[[UITextField alloc]initWithFrame:CGRectMake(48, 150, 246, 39)]autorelease];
        field1.placeholder=@"用户名";
        field1.font=[UIFont systemFontOfSize:14];
        field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field1.backgroundColor=[UIColor clearColor];
        //self.field1.background = [UIImage imageNamed:@"import@2x.png"];
        [field1 becomeFirstResponder];
        field1.delegate = self;
        
        UITextField *mailFiled1=[[UITextField alloc]initWithFrame:CGRectMake(28, 150, 266, 39)];
        mailFiled1.backgroundColor=[UIColor clearColor];
        mailFiled1.userInteractionEnabled=NO;
        mailFiled1.background = [UIImage imageNamed:@"import@2x.png"];
        [self addSubview:mailFiled1];
        [mailFiled1 release];
        [self addSubview:self.field1];
        //*****************************用户名 end*************************************
        
        //*****************************年龄*************************************
        field2=[[[UITextField alloc]initWithFrame:CGRectMake(48, 200, 246, 39)]autorelease];
        field2.placeholder=@"年龄";
        //self.field2.userInteractionEnabled=NO;
        field2.font=[UIFont systemFontOfSize:14];
        field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field2.backgroundColor=[UIColor clearColor];
        //self.field2.background = [UIImage imageNamed:@"import@2x.png"];
        field2.delegate = self;
        field2.returnKeyType = UIReturnKeyGo;
        
        UITextField *mailFiled2=[[UITextField alloc]initWithFrame:CGRectMake(28, 200, 266, 39)];
        mailFiled2.backgroundColor=[UIColor clearColor];
        mailFiled2.userInteractionEnabled=NO;
        mailFiled2.background = [UIImage imageNamed:@"import@2x.png"];
        [self addSubview:mailFiled2];
        [self addSubview:self.field2];
        
        [self addSubview:self.field2];
        [mailFiled2 release];
        //*****************************年龄 end*************************************
        
        //*****************************男按钮*************************************
        button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(28, 250, 59, 39);
        button1.backgroundColor=[UIColor clearColor];
        [button1 setBackgroundImage:[UIImage imageNamed:@"loginmale@2x.png"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"loginmaleing@2x.png"] forState:UIControlStateSelected];
        button1.tag=102;
        [button1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        button1.titleLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:self.button1];
        //*****************************男按钮 end*************************************
        
        //*****************************女按钮*************************************
        button2=[UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame=CGRectMake(96, 250, 59, 39);
        button2.backgroundColor=[UIColor clearColor];
        [button2 setBackgroundImage:[UIImage imageNamed:@"loginFemale.png"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"loginFemaleing.png"] forState:UIControlStateSelected];
        button2.tag=103;
        [button2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button2];
        //*****************************女按钮 end*************************************
        
        //*****************************确认按钮*************************************
        button3=[UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame=CGRectMake(168, 250, 125, 39);
        button3.backgroundColor=[UIColor clearColor];
        [button3 setBackgroundImage:[UIImage imageNamed:@"loginyes@2x.png"] forState:UIControlStateNormal];
        [button3 setBackgroundImage:[UIImage imageNamed:@"loginyesing.png"] forState:UIControlStateSelected];
        [self addSubview:self.button3];
        //*****************************确认按钮 end*************************************
        
        //*****************************返回按钮*************************************
        button4=[UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame=CGRectMake(20, 13, 25.5, 26.5);
        self.button4.backgroundColor=[UIColor clearColor];
        [self.button4 setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        [self.button4 setBackgroundImage:[UIImage imageNamed:@"backanxia@2x.png"] forState:UIControlStateSelected];
        [self addSubview:self.button4];
        //*****************************返回按钮 end*************************************
    }
    return self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 102)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self viewWithTag:103];
        otherButton.selected = NO;
    }
    if (btn.tag == 103)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self viewWithTag:102];
        otherButton.selected = NO;
    }
}
-(void)dealloc
{
    [super dealloc];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
