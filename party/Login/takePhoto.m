//
//  takePhoto.m
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "takePhoto.h"

@implementation takePhoto
@synthesize labelName,imgView,button1,button2,photoImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //*****************************标题*************************************
        self.labelName=[[[UILabel alloc]initWithFrame:CGRectMake(118, 9, 100, 44)]autorelease];
        labelName.text=@"上传照片";
        labelName.textColor=[UIColor redColor];
        labelName.font=[UIFont systemFontOfSize:20];
        self.labelName.backgroundColor=[UIColor clearColor];
        [self addSubview:self.labelName];
        //*****************************标题 end*************************************
        
        //*****************************照片*************************************
        self.imgView=[[[UIImageView alloc]initWithFrame:CGRectMake(28, 70, 268, 268)]autorelease];
        self.imgView.image=[UIImage imageNamed:@"photo@2x.png"];
        self.imgView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.imgView];
        
        //*****************************照片 end**********************************
        
        //*****************************返回按钮*************************************
        button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(28, 20, 25.5, 26.5);
        button1.backgroundColor=[UIColor clearColor];
        [button1 setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"backanxia@2x.png"] forState:UIControlStateSelected];
        [self addSubview:self.button1];
        //*****************************返回按钮 end*************************************
        
        //*****************************确定按钮*************************************
        button2=[UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame=CGRectMake(28, 356, 266.5, 39);
        button2.backgroundColor=[UIColor clearColor];
        [button2 setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.button2];
        //*****************************确定按钮 end*************************************
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)dealloc
{
    [super dealloc];
}

@end
