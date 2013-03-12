//
//  InvitViewController.m
//  Invit
//
//  Created by mac bookpro on 1/20/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "InvitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ModalAlert.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface InvitViewController ()

@end

@implementation InvitViewController
@synthesize lat,lng;
@synthesize map_city,map_local;
@synthesize from_time;
@synthesize from_p_id;
@synthesize invite;
@synthesize temp;
@synthesize txtView;
@synthesize examineText;
@synthesize stitle,info,local,time,friendId,phone;
@synthesize from_Creat_C_id,from_Creat_p_type;
@synthesize userUUid;

-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:YES];
    
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"POBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    
    [super viewWillAppear:animated];
    [goback release];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self getUUidForthis];
    //self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];

    //******************************确定按钮************************************
    if(temp==1){
        UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
        donebutton.frame=CGRectMake(0.0, 0.0, 50, 31);
        [donebutton setImage:[UIImage imageNamed:@"Editdone@2x.png"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
        self.navigationItem.rightBarButtonItem=Makedone;
        [Makedone release];
    }
    else if(temp==2){
        UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
        donebutton.frame=CGRectMake(0.0, 0.0, 50, 31);
        [donebutton setImage:[UIImage imageNamed:@"goahead@2x.png"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
        self.navigationItem.rightBarButtonItem=Makedone;
        [Makedone release];
        
    }
    //******************************确定按钮 end************************************
    
    UITextView *textView1=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 145)];
    textView1.userInteractionEnabled=NO;
    textView1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:textView1];
    [textView1 release];
    //******************************textView 邀请函************************************
    txtView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300*mainwith, 135*mainhight)];
    self.txtView.delegate=self;
    self.txtView.backgroundColor=[UIColor whiteColor];
    self.txtView.scrollEnabled = YES;//是否可以拖动
    [self.txtView becomeFirstResponder];
    self.txtView.tag=100;
    [self.txtView setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.txtView];
    
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    uilabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 6, 100*mainwith, 20*mainhight)];
    if(temp==1){
        uilabel.text = @"碰头地点？";
        uilabel.font=[UIFont systemFontOfSize:14];
        UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock@2x.png"]];//129
        imgView.frame=CGRectMake(0, 135*mainhight, 320, 36*mainhight);
        [self.view addSubview:imgView];
        [imgView release];
    }
    else if(temp==2){
        uilabel.text=@"申请理由...";
        uilabel.font=[UIFont systemFontOfSize:14];
    }
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    [self.txtView addSubview:uilabel];
    
    if(self.temp==1){
        label=[[UILabel alloc]initWithFrame:CGRectMake(20*mainwith, 95*mainhight, 60*mainwith, 40*mainhight)];
    }else{
        label=[[UILabel alloc]initWithFrame:CGRectMake(20*mainwith, 131*mainhight, 60*mainwith, 40*mainhight)];
    }
    label.text=@"40";
    label.font=[UIFont systemFontOfSize:14];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor grayColor];
    label.tag=101;
    [self.view addSubview:label];
    //******************************textView 邀请函************************************
    
    //******************************填写联系方式************************************
    if (self.temp==1) {
        button =[[UIButton alloc]initWithFrame:CGRectMake(218*mainwith, 108*mainhight, 85*mainwith, 17*mainhight)];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor clearColor];
         [button setBackgroundImage:[UIImage imageNamed:@"mobilenuber@2x.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"你的联系方式" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 10];
        
        [self.view addSubview:button];
        //******************************填写联系方式 end************************************
    }
}
-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *stringUUID=[stringmutable objectAtIndex:0];
    NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
    self.userUUid=stringUUID;
}
//*****************************textViewdelegate*****************************
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag=100) {
        self.examineText =  textView.text;
        if (textView.text.length == 0) {
            if(temp==1)
                uilabel.text = @"碰头地点？";
            else if(temp==2)
                uilabel.text=@"申请理由...";
        }else{
            uilabel.text = @"";
        }
    }
    NSString *num=[NSString stringWithFormat:@"%d",40-[self.examineText length]];
    UILabel *numLabel=(UILabel *)[self.view viewWithTag:101];
    numLabel.text=num;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.tag=100){
        self.examineText=textView.text;
    };
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=40)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}
//*****************************textViewdelegate end*****************************

//*****************************给服务器上传申请理由************************************
-(void)sendAction{
    NSLog(@"send======%@",self.from_p_id);
    NSLog(@"申请理由========%@",self.examineText);
    if (self.examineText==nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不填写任何申请理由？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        [alert show];
        [alert release];
    }
    else{
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00052"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.from_p_id forKey:@"p_id"];
        [rrequest setPostValue:self.examineText forKey: @"m_msg"];
        
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00052"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.from_p_id forKey:@"p_id"];
        [rrequest setPostValue:self.examineText forKey: @"m_msg"];
        
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//******************************给服务器上传申请理由 end************************************

//******************************上传派对详细信息************************************
-(void)rightAction{
    NSLog(@"确定");
    
    if (self.examineText==nil||self.phone==nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写完整信息" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    else
        [self sendData];
}

-(void)sendData{
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00051"];
                       ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
                       
                       NSLog(@"%@",self.friendId);
                       
                       NSMutableString *stringFriId=[[NSMutableString alloc]init];
                       
                       for (int i=0; i<[self.friendId count]; i++) {
                           if(i==0)
                               [stringFriId appendFormat:@"%@",[[self.friendId objectAtIndex:i] objectForKey:@"USER_ID"]];
                           else
                               [stringFriId appendFormat:@",%@",[[self.friendId objectAtIndex:i] objectForKey:@"USER_ID"]];
                       }
                       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                       [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                       self.from_time=[formatter stringFromDate:self.time];
                       [formatter release];
                       //*********************判断普通派对*****************************
                       [rrequest setPostValue:userUUid forKey: @"uuid"];
                       if (self.from_Creat_C_id) {
                           [rrequest setPostValue:self.from_Creat_C_id forKey:@"c_id"];
                           NSLog(@"self.from_Creat_C_id=======%@",self.from_Creat_C_id);
                       }
                       [rrequest setPostValue:self.from_Creat_p_type forKey:@"p_type"];
                       [rrequest setPostValue:self.stitle forKey: @"p_title"];
                       [rrequest setPostValue:self.from_time forKey:@"p_stime"];
                       [rrequest setPostValue:self.map_local forKey: @"p_local"];
                       [rrequest setPostValue:self.info forKey: @"p_info"];
                       [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lng] forKey:@"lng"];
                       [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lat] forKey:@"lat"];
                       [rrequest setPostValue:self.map_city forKey: @"p_city"];
                       [rrequest setPostValue:stringFriId forKey: @"users"];
                       [rrequest setPostValue:self.examineText forKey: @"p_invite"];
                       [rrequest setPostValue:self.phone forKey: @"p_phone"];
                       
                       NSLog(@"userUUid=======%@",userUUid);
                       NSLog(@"self.from_Creat_p_type=======%@",self.from_Creat_p_type);
                       NSLog(@"self.stitle=======%@",self.stitle);
                       NSLog(@"self.from_time=======%@",self.from_time);
                       NSLog(@"self.map_local=======%@",self.map_local);
                       NSLog(@"self.info=======%@",self.info);
                       NSLog(@"self.lng=======%@",[NSString stringWithFormat:@"%f",self.lng]);
                       NSLog(@"useself.lat=======%@",[NSString stringWithFormat:@"%f",self.lat]);
                       NSLog(@"self.map_city=======%@",self.map_city);
                       NSLog(@"stringFriId=======%@",stringFriId);
                       NSLog(@"self.examineText=======%@",self.examineText);
                       NSLog(@"self.phone=======%@",self.phone);
                       
                       //rrequest.delegate=self;
                       [rrequest startSynchronous];

                        dispatch_async(dispatch_get_main_queue(), ^{
                           NSData* response=[rrequest responseData];
                           NSLog(@"%@",response);
                           NSError* error;
                           
                           
                           if (response!=nil) {
                               
                               NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                               NSLog(@"%@",bizDic);
                           }
                        });
                   });
        
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//******************************上传派对详细信息 end************************************

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"guojiangwei %@",bizDic);
}
//*****************************给服务器上传数据end************************************

//******************************填写联系信息************************************
-(void)buttonAction{
    NSString *answer = [ModalAlert ask:@"你的联系方式?" withTextPrompt:@"telePhone"];
    if (answer==nil)
        [button setTitle:@"你的联系方式" forState:UIControlStateNormal];
    else{
        [button setTitle:answer forState:UIControlStateNormal];
        self.phone=answer;
    }
}
//******************************填写联系信息 end************************************
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideTabBar:(BOOL) hidden {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, mainscreenhight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, (mainscreenhight-36), view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, mainscreenhight)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,mainscreenhight-36)];//(mainscreenhight-49)*mainscreenhight/460.0)
            }
        }
    }
    
    [UIView commitAnimations];
}



-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
