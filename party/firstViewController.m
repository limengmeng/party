//
//  firstViewController.m
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "firstViewController.h"
#import "infoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
#import "AddrDetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "TwoViewController.h"
#import "MakefriendViewController.h"
#import "ASIFormDataRequest.h"
@implementation firstViewController
@synthesize creaters;
@synthesize P_time;
@synthesize partyId;
@synthesize uuid;
@synthesize message;

@synthesize senderDic;
@synthesize user;
@synthesize imgView;
@synthesize tbView,dic;
@synthesize systemArray;
@synthesize friendlist;
@synthesize userUUid;
int MessFlag=0;//判断是否需要重新加载消息页面
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"消息";
        choiceNumber=0;
        [self getUUidForthis];
        //************************添加三个button
        friendbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        friendbutton.frame=CGRectMake(0, 0, 107, 35);
        friendbutton.titleLabel.text=@"好友";
        friendbutton.tag=101;
        [friendbutton setSelected:YES];
        [friendbutton setBackgroundImage:[UIImage imageNamed:@"firendsdone@2x.png"] forState:UIControlStateNormal];
        [friendbutton setBackgroundImage:[UIImage imageNamed:@"firends1@2x.png"] forState:UIControlStateSelected];
        [friendbutton addTarget:self action:@selector(mesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        partybutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        partybutton.frame=CGRectMake(107, 0, 106, 35);
        partybutton.titleLabel.text=@"派对";
        partybutton.tag=102;
        [partybutton setBackgroundImage:[UIImage imageNamed:@"mesparty@2x.png"] forState:UIControlStateNormal];
        [partybutton setBackgroundImage:[UIImage imageNamed:@"mesparty1@2x.png"] forState:UIControlStateSelected];
        [partybutton addTarget:self action:@selector(mesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        systembutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        systembutton.frame=CGRectMake(213, 0, 107, 35);
        systembutton.titleLabel.text=@"系统";
        systembutton.tag=103;
        [systembutton setBackgroundImage:[UIImage imageNamed:@"xitong@2x.png"] forState:UIControlStateNormal];
        [systembutton setBackgroundImage:[UIImage imageNamed:@"xitong1@2x.png"] forState:UIControlStateSelected];
        [systembutton addTarget:self action:@selector(mesAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:friendbutton];
        [self.view addSubview:partybutton];
        [self.view addSubview:systembutton];
        
        [friendbutton addTarget:self action:@selector(buttonFriend) forControlEvents:UIControlEventTouchDown];
        [partybutton addTarget:self action:@selector(buttonParty) forControlEvents:UIControlEventTouchDown];
        [systembutton addTarget:self action:@selector(buttonSystem) forControlEvents:UIControlEventTouchDown];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

-(void)timerFired
{
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/msg/IF00060?uuid=%@",userUUid];
                       NSURL* url=[NSURL URLWithString:stringUrl];
                       ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                       request.shouldAttemptPersistentConnection = NO;
                       [request setValidatesSecureCertificate:NO];
                       [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                       [request setDidFailSelector:@selector(requestDidFailed:)];
                       [request startSynchronous];
                       //[friBtn removeFromSuperview];
                       //[sysBtn removeFromSuperview];
                       //[mesBtn removeFromSuperview];
            
                       

                       //更新界面时用到
                       dispatch_async(dispatch_get_main_queue(), ^{
                           NSData* response=[request responseData];
                           NSLog(@"%@",response);
                           NSError* error;
                           
                           
                           if (response!=nil) {
                               
                               NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                               NSLog(@"%@",bizDic);
                               NSLog(@"wo de nei rong ding shi qi huo de shu ju");
                               friend_count=[[bizDic objectForKey:@"friend_count"]intValue];
                               if(friend_count){
                                   if (friBtn==nil) {
                                       friBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                                       friBtn.frame=CGRectMake(71, 7, 6, 5);
                                       [friBtn setBackgroundImage:[UIImage imageNamed:@"point@2x.png"] forState:UIControlStateNormal];
                                       [self.view addSubview:friBtn];
                                   }
                                   
                               }
                               party_count=[[bizDic objectForKey:@"party_count"]intValue];
                               if (party_count) {
                                   if (mesBtn==nil) {
                                       mesBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                                       mesBtn.frame=CGRectMake(179, 7, 6, 5);
                                       [mesBtn setBackgroundImage:[UIImage imageNamed:@"point@2x.png"] forState:UIControlStateNormal];
                                       [self.view addSubview:mesBtn];
                                   }
                                   
                               }
                               system_count=[[bizDic objectForKey:@"system_count"]intValue];
                               if(system_count){
                                   if (sysBtn==nil) {
                                       sysBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                                       sysBtn.frame=CGRectMake(280, 7, 6, 5);
                                       [sysBtn setBackgroundImage:[UIImage imageNamed:@"point@2x.png"] forState:UIControlStateNormal];
                                       [self.view addSubview:sysBtn];
                                   }
                                   
                               }
                           }
                           
                           UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:0];
                           
                           int badgeValue = friend_count+party_count+system_count;
                           NSLog(@"新消息的数量:%d",badgeValue);
                           if (badgeValue>0) {
                               tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",badgeValue];
                           }
                           else
                           {
                               tController.tabBarItem.badgeValue=nil;
                           }
                       });
                   });

}
#pragma mark-
#pragma mark Table Data Source Methods

-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [self getUUidForthis];
    if (MessFlag==0) {
        //重新加载消息
        NSLog(@"重新加载消息");
        [friendbutton setSelected:YES];
        [partybutton setSelected:NO];
        [systembutton setSelected:NO];
        choiceNumber=0;
        total=0;
        flag=0;
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00016?uuid=%@&&type=friend",userUUid];
        NSURL* url=[NSURL URLWithString:stringUrl];
        NSLog(@"好友消息：%@",url);
        NSLog(@"%@",stringUrl);
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];    
    }
    MessFlag=0;
    
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self getUUidForthis];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
            //UITableView
    tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 35, 320, mainscreenhight-50) style:UITableViewStyleGrouped];
    self.tbView.dataSource=self;
    self.tbView.delegate=self;
    [self.view addSubview:self.tbView];
    self.tbView.backgroundView=nil;
    self.tbView.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    lableTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
      
    //=============system数据========================================================
    NSMutableArray* party=[[NSMutableArray alloc]init];
    self.message=party;
    [party release];
    NSMutableArray* system=[[NSMutableArray alloc]init];
    self.systemArray=system;
    [system release];

    mutablePid  =[[NSMutableArray alloc]init];
    mutableCid  =[[NSMutableArray alloc]init];
    mutableCtype  =[[NSMutableArray alloc]init];
    
    //****************friend的数据
    NSMutableArray* list=[[NSMutableArray alloc]init];
    self.friendlist=list;
    [list release];
    
}

-(void)mesAction:(UIButton *)btn
{
    if (btn.tag == 101)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self.view viewWithTag:102];
        UIButton * otherButton1 = (UIButton *)[self.view viewWithTag:103];
        otherButton.selected = NO;
        otherButton1.selected=NO;
    }
    if (btn.tag == 102)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self.view viewWithTag:101];
        UIButton * otherButton1 = (UIButton *)[self.view viewWithTag:103];
        otherButton.selected = NO;
        otherButton1.selected=NO;
    }
    if (btn.tag == 103)
    {
        btn.selected = YES;
        UIButton * otherButton = (UIButton *)[self.view viewWithTag:101];
        UIButton * otherButton1 = (UIButton *)[self.view viewWithTag:102];
        otherButton.selected = NO;
        otherButton1.selected=NO;
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
    self.uuid=[NSNumber numberWithInt:[stringUUID intValue]];
    //self.userUUid=@"10001";
    self.userUUid=stringUUID;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //尹林林
    if (choiceNumber==0) {
        NSLog(@"接口16:好友消息");
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",bizDic);
        NSArray* messarr=[bizDic objectForKey:@"Messages"];
        total=[messarr count];
        NSLog(@"好友消息当前返回的数量%d",total);
        if (flag==0) {
            [self.friendlist removeAllObjects];
        }
        [self.friendlist addObjectsFromArray:messarr];
    }
    
    //郭江伟
    if (choiceNumber==1) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",bizDic);
        self.dic=bizDic;
        NSLog(@"派对消息。。。。。self.dic===%@",self.dic);
        NSArray* array=[self.dic objectForKey:@"Message"];
        total=array.count;
        if (flag==0) {
            [self.message removeAllObjects];
        }
        [self.message addObjectsFromArray:array];
        
        //[tbView reloadData];
    }
    
    //李萌萌
    if (choiceNumber==2) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"输出字典里面的所有数据%@",bizDic);
        NSArray* array=[bizDic objectForKey:@"Messages"];
        total=array.count;
        if (flag==0) {
            [self.systemArray removeAllObjects];
        }
        [self.systemArray addObjectsFromArray:array];
        NSLog(@"输出数组里面的所有数据%@",mutablePid);
    }
   
    int sum=self.message.count+systemArray.count+self.friendlist.count;
    if (sum) {
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",sum];
    }
    //所有的消息界面更新完之后都需要重新加载
    [tbView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //尹林林
    if (choiceNumber==0) {
        NSDictionary* dict=[self.friendlist objectAtIndex:indexPath.section];
        NSLog(@"%d:%@",indexPath.section, dict);
        NSDictionary* sender=[dict objectForKey:@"sender"];
        NSLog(@"sender:%@",sender);
        NSString* type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_id"]];
        NSLog(@"type:%@",type);
        //添加好友的请求，点击进入好友资料
        if ([type isEqualToString:@"0"])
        {
            MakefriendViewController* makefriend=[[MakefriendViewController alloc]init];
            makefriend.user_id=[sender objectForKey:@"SENDER_ID"];
            makefriend.delegate=self;
            friendselect=[indexPath section];
            NSLog(@"makefriend:user_id::::%@",makefriend.user_id);
            MessFlag=1;
            [self.navigationController pushViewController:makefriend animated:YES];
            
            [makefriend release];
        }
        
        //邀请加入派对，点击进入派对主页
        else
        {
            MessFlag=1;
            TwoViewController* party=[[TwoViewController alloc]init];
            party.title=[dict objectForKey:@"p_title"];
            NSLog(@"%@",party.title);

            party.p_id=[dict objectForKey:@"p_id"];
            [self.navigationController pushViewController:party animated:YES];
            [party release];
            
        }

    }
    
    
    //郭江伟
    if (choiceNumber==1) {
        //***********************************比较发送者以及接受者数据**********************************
        self.senderDic=[[self.message objectAtIndex:indexPath.section] objectForKey:@"sender"];
        self.user=[[self.message objectAtIndex:indexPath.section] objectForKey:@"user"];
        self.partyId=[[self.message objectAtIndex:indexPath.section]objectForKey:@"p_id"];
        self.creaters=[[self.message objectAtIndex:indexPath.section] objectForKey:@"creats"];

        //***********************************比较发送者以及接受者数据 end**********************************
        if([[self.partyId objectForKey:@"P_UUID"] isEqualToNumber:self.uuid]){//如果派对的创建者的id等于uuid
            if([[self.user objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]){//如果信息接收者的id等于uuid
                
                infoViewController* makefriend=[[infoViewController alloc]init];
                makefriend.flag=10;
                makefriend.user_id=[self.senderDic objectForKey:@"SENDER_ID"];
                NSLog(@"makefriend:user_id::::%@",makefriend.user_id);
               
                MessFlag=1;
                [self.navigationController pushViewController:makefriend animated:YES];
                
                [makefriend release];
            }
            else{//我邀请别人联合创建
                if ([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    
                    TwoViewController *party=[[TwoViewController alloc]init];
                    //[self.navigationController pushViewController:party animated:YES];
                    party.p_id=[self.partyId objectForKey:@"P_ID"];
                    party.title=[self.partyId objectForKey:@"P_TITLE"];
                    MessFlag=1;
                    [self.navigationController pushViewController:party animated:YES];
                    [party release];
                    
                }
            }
        }
        else if ([[self.senderDic objectForKey:@"SENDER_ID"] isEqualToNumber:self.uuid]){//我申请假如别人的派对
            TwoViewController *party=[[TwoViewController alloc]init];
            //[self.navigationController pushViewController:party animated:YES];
            party.p_id=[self.partyId objectForKey:@"P_ID"];
            party.title=[self.partyId objectForKey:@"P_TITLE"];
            MessFlag=1;
            [self.navigationController pushViewController:party animated:YES];
            [party release];
        }
        else{//如果联合创建人的id等于uuid
            BOOL isdone=NO;
            if (self.creaters.count==0) {
                isdone=NO;
            }
            for (int i=0; i<[self.creaters count]; i++) {
                if ([[[self.creaters objectAtIndex:i] objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]) {
                    isdone=YES;
                }
            }
            if(isdone){
                if ([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    FiveViewController *party=[[FiveViewController alloc]init];
                    //[self.navigationController pushViewController:party animated:YES];
                    party.p_id=[self.partyId objectForKey:@"P_ID"];
                    party.title=[self.partyId objectForKey:@"P_TITLE"];
                    MessFlag=1;
                    [self.navigationController pushViewController:party animated:YES];
                    [party release];
                }
                else{
                    infoViewController* makefriend=[[infoViewController alloc]init];
                    makefriend.flag=10;
                    makefriend.user_id=[self.senderDic objectForKey:@"SENDER_ID"];
                    NSLog(@"makefriend:user_id::::%@",makefriend.user_id);
                    MessFlag=1;
                    [self.navigationController pushViewController:makefriend animated:YES];
                    
                    [makefriend release];
                }
            }
        }
    }
    
    //李萌萌
    if (choiceNumber==2) {
        NSDictionary *dict =[systemArray objectAtIndex:indexPath.section];
        NSString *stringPid=[dict objectForKey:@"p_id"];
        if ([stringPid intValue]!=0) {
            
            NSLog(@"sssssssssssssssssssssssssssssss%@",stringPid);
            FiveViewController *party=[[FiveViewController alloc]init];
            //[self.navigationController pushViewController:party animated:YES];
            party.p_id=[dict objectForKey:@"p_id"];
            party.title=[dict objectForKey:@"p_title"];
            MessFlag=1;
            [self.navigationController pushViewController:party animated:YES];
            [party release];
        }
        else
        {
            NSDictionary*dictC=[systemArray objectAtIndex:indexPath.section];
            NSString *stringCtype=[dictC objectForKey:@"c_type"];
            if ([stringCtype intValue]==1) {
                DetailViewController *placeView=[[DetailViewController alloc]init];
                placeView.C_id=[dict objectForKey:@"C_ID"];
                 NSLog(@"ssssssssssssssssssssssssssss%@",placeView.C_id);
                MessFlag=1;
                [self.navigationController pushViewController:placeView animated:YES];
                [placeView release];
            }
            else if([stringCtype intValue]==2)
            {
                AddrDetailViewController *addrView=[[AddrDetailViewController alloc]init];
                addrView.C_id=[dict objectForKey:@"C_ID"];
                NSLog(@"ssssssssssssssssssssssssssss%@",addrView.C_id);
                MessFlag=1;
                [self.navigationController pushViewController:addrView animated:YES];
                [addrView release];
            }
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView



//每个分组的header的view，添加时间------已经改好
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //header已经修改好，不需要再动
    UIView* view=[tableView dequeueReusableCellWithIdentifier:@"header"];
    if (!view) {
        view=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
        view.backgroundColor=[UIColor clearColor];
    }
    UILabel* timelabel=nil;
    if (section==0) {
        timelabel=[[UILabel alloc]initWithFrame:CGRectMake(74, 6, 155, 18)];
    }
    else
         timelabel= [[UILabel alloc]initWithFrame:CGRectMake(74, 0, 155, 18)];
    timelabel.layer.cornerRadius=6;
    timelabel.clipsToBounds=YES;
    timelabel.layer.masksToBounds=YES;
    timelabel.font=[UIFont systemFontOfSize:13];
    timelabel.textColor=[UIColor whiteColor];
    timelabel.backgroundColor=[UIColor grayColor];
    timelabel.textAlignment = UITextAlignmentCenter;
    [view addSubview:timelabel];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    //HH与hh的区别是24小时制和12小时制

    if (choiceNumber==0) {
        NSDictionary* dict=[self.friendlist objectAtIndex:section];
        NSLog(@"header---%d:%@",section, dict);
        NSInteger time=[[dict objectForKey:@"M_STIME"]integerValue];
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timelabel.text=confromTimespStr;
    }
    else if(choiceNumber==1){
        NSDictionary* dict=[self.message objectAtIndex:section];
        NSLog(@"header---%d:%@",section, dict);
        NSInteger time=[[dict objectForKey:@"M_STIME"]integerValue];
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timelabel.text=confromTimespStr;
        
    }
    if (choiceNumber==2) {
        NSDictionary* dict=[self.systemArray objectAtIndex:section];
        NSLog(@"header---%d:%@",section, dict);
        NSInteger time=[[dict objectForKey:@"M_STIME"]integerValue];
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timelabel.text=confromTimespStr;
    }
    [timelabel release];
    [formatter release];
    return view;
}


//分组个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (choiceNumber==2) {
        return [systemArray count];
    }
    if (choiceNumber==1) {
        return [self.message count];
    }
    if (choiceNumber==0) {
        return self.friendlist.count;
    }
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //尹林林
    if (choiceNumber==0) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        NSDictionary* dict=[self.friendlist objectAtIndex:indexPath.section];
        NSLog(@"%d:%@",indexPath.section, dict);
        NSDictionary* sender=[dict objectForKey:@"sender"];
        NSLog(@"sender:%@",sender);
        NSString* type=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_id"]];
        NSLog(@"type:%@",type);
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messagefriends@2x.png"]]autorelease];
        //申请添加好友的消息
        if ([type isEqualToString:@"0"])
        {
            //NSLog(@"申请添加好友");
            
            UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(27, 1, 50, 48)];
            
            [imageview setImageWithURL:[NSURL URLWithString:[sender objectForKey:@"SENDER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            [cell.contentView addSubview:imageview];
            [imageview release];
            UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(87, 21, 11, 14)];
            if ([[[sender objectForKey:@"SENDER_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
                NSLog(@"男");
                seximage.image=[UIImage imageNamed:@"MaleMessage@2x.png"];
            }
            else
            {
                seximage.image=[UIImage imageNamed:@"FemaleMessage@2x.png"];
            }

            [cell.contentView addSubview:seximage];
            [seximage release];
            UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(104, 16, 100, 25)];
            namelabel.text=[sender objectForKey:@"SENDER_NICK"];
            namelabel.font=[UIFont systemFontOfSize:15];
            namelabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
            namelabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:namelabel];
            [namelabel release];
            UILabel* messinfo=[[UILabel alloc]initWithFrame:CGRectMake(87, 36, 170, 25)];
            messinfo.backgroundColor=[UIColor clearColor];
            messinfo.font=[UIFont systemFontOfSize:13];
            messinfo.text=@"对方想添加你为好友";
            messinfo.textColor=[UIColor colorWithRed:123.0/255 green:140.0/255 blue:155.0/255 alpha:1];
            [cell.contentView addSubview:messinfo];
            [messinfo release];
            if (![[[sender objectForKey:@"SENDER_STATUS"] substringToIndex:1] isEqualToString:@"Y"]) {
                //对方还不是好友
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(195, 77, 70 , 16)];
                imageview.image=[UIImage imageNamed:@"takefriends@2x.png"];
                [cell.contentView addSubview:imageview];
                [imageview release];
            }
            else
            {
                //已经是好友
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(195, 77, 70, 16)];
                imageview.image=[UIImage imageNamed:@"takedfriends@2x.png"];
                [cell.contentView addSubview:imageview];
                [imageview release];
                
            }
            
        }
        
        //邀请参加派对的消息
        else
        {
            NSLog(@"邀请加入派对");
            UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(27, 1, 50, 48)];
            [imageview setImageWithURL:[NSURL URLWithString:[sender objectForKey:@"SENDER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            [cell.contentView addSubview:imageview];
            [imageview release];
            UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(87, 21, 11, 13)];
            if ([[[sender objectForKey:@"SENDER_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
                NSLog(@"男");
                seximage.image=[UIImage imageNamed:@"MaleMessage@2x.png"];
            }
            else
            {
                seximage.image=[UIImage imageNamed:@"FemaleMessage@2x.png"];
            }
            [cell.contentView addSubview:seximage];
            [seximage release];
            UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(104, 16, 100, 25)];
            namelabel.text=[sender objectForKey:@"SENDER_NICK"];
            namelabel.font=[UIFont systemFontOfSize:15];
            namelabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
            namelabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:namelabel];
            [namelabel release];
            UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(87, 36, 170, 25)];
            wantlabel.text=@"想和你一起去:";
            wantlabel.font=[UIFont systemFontOfSize:13];
            wantlabel.backgroundColor=[UIColor clearColor];
            wantlabel.textColor=[UIColor lightGrayColor];
            [cell.contentView addSubview:wantlabel];
            [wantlabel release];
            UITextView* infolabel=[[UITextView alloc]initWithFrame:CGRectMake(90, 31, 199, 50)];
            infolabel.userInteractionEnabled=NO;
            infolabel.multipleTouchEnabled=NO;
            infolabel.font=[UIFont systemFontOfSize:13];
            infolabel.backgroundColor=[UIColor clearColor];
            infolabel.textColor=[UIColor colorWithRed:123.0/255 green:140.0/255 blue:155.0/255 alpha:1];
            infolabel.text=[NSString stringWithFormat:@"                     %@",[dict objectForKey:@"p_title"]];
            [cell.contentView addSubview:infolabel];
            [infolabel release];
            
            //已经加入派对
            if ([[[dict objectForKey:@"p_status"]substringToIndex:1]isEqualToString:@"Y"])
            {
                //NSLog(@"已加入派对");
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(195, 77, 70,16)];
                imageview.image=[UIImage imageNamed:@"joined@2x.png"];
                [cell.contentView addSubview:imageview];
                [imageview release];
                
            }
            //还没有加入派对
            else
            {
                //还未加入派对
                UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(195, 77, 70, 16)];
                imageview.image=[UIImage imageNamed:@"joinparty@2x.png"];
                [cell.contentView addSubview:imageview];
                [imageview release];
                
            }
            
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    }
    
    //郭江伟
    if (choiceNumber==1) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        //***************************************显示头像*********************************************
        
        //***********************************比较发送者以及接受者数据**********************************
        self.senderDic=[[self.message objectAtIndex:indexPath.section] objectForKey:@"sender"];
        self.user=[[self.message objectAtIndex:indexPath.section] objectForKey:@"user"];
        self.partyId=[[self.message objectAtIndex:indexPath.section]objectForKey:@"p_id"];
        self.creaters=[[self.message objectAtIndex:indexPath.section] objectForKey:@"creats"];
        //***********************************比较发送者以及接受者数据 end**********************************
        
        //************************************派对创建时间******************************************
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        
        NSInteger time1=[[self.partyId objectForKey:@"P_STIME"]integerValue];
        NSDate* date1=[NSDate dateWithTimeIntervalSince1970:time1];
        self.P_time = [formatter stringFromDate:date1];
        NSLog(@"self.P_time======%@",self.P_time);
        [formatter release];
        
        //************************************派对创建时间 end*****************************************

        if([[self.partyId objectForKey:@"P_UUID"] isEqualToNumber:self.uuid]){//如果派对的创建者的id等于uuid
            if([[self.user objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]){//如果信息接收者的id等于uuid
                //***************************************图片后面的背景*********************************************
                cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MASSAGEjoinup@2x.png"]]autorelease];
                //***************************************图片后面的背景  end*********************************************
                UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(27, 0, 52, 48)];
                NSURL* imageurl=[NSURL URLWithString:[self.senderDic objectForKey:@"SENDER_PIC"]];
                [imgView2 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
                imgView2.layer.cornerRadius=5;
                imgView2.clipsToBounds=YES;
                imgView2.layer.masksToBounds=YES;
                
                //***************************************信息显示*********************************************
                UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(105, 16, 138, 15)];
                mylabel.text=[self.senderDic objectForKey:@"SENDER_NICK"];
                mylabel.font=[UIFont systemFontOfSize:14];
                mylabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
                mylabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:mylabel];
                [mylabel release];
                
                UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(90, 16, 11, 13)];
                NSString* sexstr=[self.senderDic objectForKey:@"SENDER_SEX"];
                if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
                    seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
                }
                else
                {
                    seximage.image=[UIImage imageNamed:@"PRfemale1.png"];
                }
                [cell.contentView addSubview:seximage];
                [seximage release];
                
                UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(87, 35, 163, 15)];
                NSMutableString *mutableSyting=[[NSMutableString alloc]init];
                [mutableSyting appendFormat:@"申请加入你的的派对:"];
                wantlabel.text=mutableSyting;
                wantlabel.font=[UIFont systemFontOfSize:11];
                wantlabel.textColor=[UIColor lightGrayColor];
                wantlabel.backgroundColor=[UIColor clearColor];
                
                [cell.contentView addSubview:wantlabel];
                [wantlabel release];
                [mutableSyting release];
                UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(88, 52, 161, 15)];
                infolabel.font=[UIFont systemFontOfSize:11];
                infolabel.backgroundColor=[UIColor clearColor];
                infolabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
                infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
                [cell.contentView addSubview:infolabel];
                [infolabel release];
                
                UITextView *introView=[[UITextView alloc]initWithFrame:CGRectMake(78, 62, 200, 40)];
                introView.userInteractionEnabled=NO;
                introView.multipleTouchEnabled=NO;
                introView.font=[UIFont systemFontOfSize:11];
                introView.backgroundColor=[UIColor clearColor];
                introView.textColor=[UIColor lightGrayColor];
                if ([[self.message objectAtIndex:indexPath.section] objectForKey:@"M_CONTENT"]) {
                    introView.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_CONTENT"]];
                }
                else{
                    introView.text=@"";
                }
                [cell.contentView addSubview:introView];
                [introView release];
                //        //***************************************信息显示 end*********************************************
                
                [cell.contentView addSubview:imgView2];
                [imgView2 release];
                
                //***************************************决定时间*********************************************
                if ([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                    //***************************************添加yes按钮*********************************************
                    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
                    button1.frame= CGRectMake(27, 115, 60, 15);
                    button1.backgroundColor=[UIColor clearColor];
                    button1.tag=104;
                    [button1 setImage:[UIImage imageNamed:@"partyMesyes@2x.png"] forState:UIControlStateNormal];
                    
                    [button1 addTarget:self action:@selector(requestButton:event:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button1];
                    //***************************************添加yes按钮 end*********************************************
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(169, 117, 52, 12)];
                    timeLabel.text=@"决定时间:";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    timeLabel.font=[UIFont systemFontOfSize:12];
                    [cell.contentView addSubview:timeLabel];
                    [timeLabel release];
                    //倒计时
                    auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(220, 115, 30, 12)];
                    auctionTime.backgroundColor=[UIColor clearColor];
                    auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    auctionTime.userInteractionEnabled=NO;
                    auctionTime.tag=106;
                    auctionTime.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    auctionTime.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"]];
                    //[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"];
                    auctionTime.font=[UIFont systemFontOfSize:15];
                    [cell.contentView addSubview:auctionTime];
                    [auctionTime release];
                    
                    UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(243, 117, 30, 12)];
                    minLabel.backgroundColor=[UIColor clearColor];
                    minLabel.text=@"mins";
                    minLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    minLabel.font=[UIFont systemFontOfSize:12];
                    [cell.contentView addSubview:minLabel];
                    [minLabel release];
                    
                }
                else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(192, 110, 54, 21)];
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"YGQL@2x.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button1];
                    [button1 release];
                }
                else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(27, 112, 58, 15)];
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"partyMesjoined@2x.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button1];
                    [button1 release];
                }
                //***************************************决定时间 end*********************************************
            }
            
            else{//如果信息的接收者的id不等于uuid
                //***************************************图片后面的背景*********************************************
                cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MASSAGEME@2x.png"]]autorelease];
                //***************************************图片后面的背景  end*********************************************
                
                //*********************************
                UIImageView* imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(217, 0, 52, 48)];
                NSURL* imageurl=[NSURL URLWithString:[[self.partyId objectForKey:@"p_user_id"] objectForKey:@"USER_PIC"]];
                [imgView1 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
                imgView1.layer.cornerRadius=5;
                imgView1.clipsToBounds=YES;
                imgView1.layer.masksToBounds=YES;
                //                imgView1.layer.borderWidth=2;
                //                imgView1.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                //***************************************信息显示*******************************************
                UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 12, 100, 20)];
                mylabel.text=@"我";
                mylabel.font=[UIFont systemFontOfSize:14];
                mylabel.backgroundColor=[UIColor clearColor];
                mylabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
                [cell.contentView addSubview:mylabel];
                [mylabel release];
                
                UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 34, 190, 15)];
                NSMutableString *mutableSyting=[[NSMutableString alloc]init];
                [mutableSyting appendString:@"邀请"];
                
                for (int i=0; i<[creaters count]; i++) {
                    if (i==0) {
                        [mutableSyting appendFormat:@"%@",[[creaters objectAtIndex:i] objectForKey:@"CREAT_NICK"]];
                    }
                    else
                        [mutableSyting appendFormat:@",%@",[[creaters objectAtIndex:i] objectForKey:@"CREAT_NICK"]];
                    NSLog(@"mutableSyting=========%@",mutableSyting);
                }
                
                [mutableSyting appendString:@"联合创建:"];
                //        [mutableSyting appendFormat:@"%@",[self.partyId objectForKey:@"P_TITLE"]];
                wantlabel.textColor=[UIColor lightGrayColor];
                wantlabel.font=[UIFont systemFontOfSize:12];
                wantlabel.backgroundColor=[UIColor clearColor];
                wantlabel.text=mutableSyting;
                
                [cell.contentView addSubview:wantlabel];
                [wantlabel release];
                [mutableSyting release];
                
                UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 51, 200, 15)];
                infolabel.font=[UIFont systemFontOfSize:11];
                infolabel.backgroundColor=[UIColor clearColor];
                infolabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
                infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
                [cell.contentView addSubview:infolabel];
                [infolabel release];
                
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 68, 200, 15)];
                timeLabel.text=[NSString stringWithFormat:@"时间：%@",self.P_time];//[self.partyId objectForKey:@"P_STIME"]];
                timeLabel.textColor=[UIColor lightGrayColor];
                timeLabel.font=[UIFont systemFontOfSize:11];
                timeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:timeLabel];
                [timeLabel release];
                UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 86, 200, 15)];
                placeLabel.text=[NSString stringWithFormat:@"地点：%@",[self.partyId objectForKey:@"P_LOCAL"]];
                placeLabel.textColor=[UIColor lightGrayColor];
                placeLabel.font=[UIFont systemFontOfSize:11];
                placeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:placeLabel];
                [placeLabel release];
                //***************************************信息显示 end*********************************************
                
                //***************************************决定时间*********************************************
                if ([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(164, 117, 52, 12)];
                    timeLabel.text=@"等待决定:";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.font=[UIFont systemFontOfSize:12];
                    timeLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    [cell.contentView addSubview:timeLabel];
                    [timeLabel release];
                    //倒计时
                    auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(220, 117, 30, 12)];
                    auctionTime.backgroundColor=[UIColor clearColor];
                    auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    auctionTime.userInteractionEnabled=NO;
                    auctionTime.tag=106;
                    auctionTime.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    auctionTime.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"]];
                    //[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"];
                    auctionTime.font=[UIFont systemFontOfSize:15];
                    [cell.contentView addSubview:auctionTime];
                    [auctionTime release];
                    
                    UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(243, 117, 30, 12)];
                    minLabel.backgroundColor=[UIColor clearColor];
                    minLabel.text=@"mins";
                    minLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    minLabel.font=[UIFont systemFontOfSize:12];
                    [cell.contentView addSubview:minLabel];
                    [minLabel release];
                    
                }
                else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(192, 110, 54, 21)];
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"YGQL@2x.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button1];
                    [button1 release];
                }
                else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(27, 110, 54, 21)];
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"YCJ@2x.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button1];
                    [button1 release];
                }
                //***************************************决定时间 end*********************************************
                
                [cell.contentView addSubview:imgView1];
                [imgView1 release];
            }
        }
        else if ([[self.senderDic objectForKey:@"SENDER_ID"] isEqualToNumber:self.uuid]) {//如果信息接收者的id等于uuid
            //***************************************图片后面的背景*********************************************
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MASSAGEME@2x.png"]]autorelease];
            //***************************************图片后面的背景  end*********************************************
            UIImageView* imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(217, 0, 52, 48)];
            imgView1.frame=CGRectMake(217, 0, 52, 48);
            NSURL* imageurl=[NSURL URLWithString:[self.senderDic objectForKey:@"SENDER_PIC"]];
            [imgView1 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            imgView1.layer.cornerRadius=5;
            imgView1.clipsToBounds=YES;
            imgView1.layer.masksToBounds=YES;
            //    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFriendPic)];
            //    [self.imgView addGestureRecognizer:singleTap];
            //***************************************信息显示*******************************************
            //***************************************信息显示*******************************************
            UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 12, 100, 20)];
            mylabel.text=@"我";
            mylabel.font=[UIFont systemFontOfSize:14];
            mylabel.backgroundColor=[UIColor clearColor];
            mylabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
            [cell.contentView addSubview:mylabel];
            [mylabel release];
            
            
            UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 34, 190, 15)];
            NSMutableString *mutableSyting=[[NSMutableString alloc]init];
            [mutableSyting appendString:@"申请加入"];
            [mutableSyting appendFormat:@"%@的派对:",[self.user objectForKey:@"USER_NICK"]];
            wantlabel.textColor=[UIColor lightGrayColor];
            wantlabel.font=[UIFont systemFontOfSize:12];
            wantlabel.backgroundColor=[UIColor clearColor];
            wantlabel.text=mutableSyting;
            
            [cell.contentView addSubview:wantlabel];
            [wantlabel release];
            [mutableSyting release];
            
            UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(34, 51, 200, 15)];
            infolabel.font=[UIFont systemFontOfSize:11];
            infolabel.backgroundColor=[UIColor clearColor];
            infolabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
            infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
            [cell.contentView addSubview:infolabel];
            [infolabel release];
            
            UITextView *introView=[[UITextView alloc]initWithFrame:CGRectMake(30, 60, 200, 40)];
            introView.userInteractionEnabled=NO;
            introView.multipleTouchEnabled=NO;
            introView.font=[UIFont systemFontOfSize:11];
            introView.backgroundColor=[UIColor clearColor];
            introView.textColor=[UIColor lightGrayColor];
            if ([[self.message objectAtIndex:indexPath.section] objectForKey:@"M_CONTENT"]) {
                introView.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_CONTENT"]];
            }
            else{
                introView.text=@"";
            }

            [cell.contentView addSubview:introView];
            [introView release];
            //***************************************信息显示 end*********************************************
            
            [cell.contentView addSubview:imgView1];
            
            //***************************************决定时间*********************************************
            if ([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(164, 117, 52, 12)];
                timeLabel.text=@"等待决定:";
                timeLabel.backgroundColor=[UIColor clearColor];
                timeLabel.tag=105;
                timeLabel.font=[UIFont systemFontOfSize:12];
                timeLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                [cell.contentView addSubview:timeLabel];
                [timeLabel release];
                
                //倒计时
                auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(220, 117, 30, 12)];
                auctionTime.backgroundColor=[UIColor clearColor];
                auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                auctionTime.userInteractionEnabled=NO;
                auctionTime.tag=106;
                auctionTime.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                auctionTime.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"]];
                //[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"];
                auctionTime.font=[UIFont systemFontOfSize:15];
                [cell.contentView addSubview:auctionTime];
                [auctionTime release];
                
                UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(243, 117, 30, 12)];
                minLabel.backgroundColor=[UIColor clearColor];
                minLabel.text=@"mins";
                minLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                minLabel.font=[UIFont systemFontOfSize:12];
                [cell.contentView addSubview:minLabel];
                [minLabel release];
                
            }
            else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(192, 110, 54, 21)];
                button1.backgroundColor=[UIColor clearColor];
                [button1 setImage:[UIImage imageNamed:@"YGQL@2x.png"] forState:UIControlStateNormal];
                [cell.contentView addSubview:button1];
                [button1 release];
            }
            else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(27, 112, 58, 15)];
                button1.backgroundColor=[UIColor clearColor];
                [button1 setImage:[UIImage imageNamed:@"partyMesjoined@2x.png"] forState:UIControlStateNormal];
                [cell.contentView addSubview:button1];
                [button1 release];
            }
            //***************************************决定时间 end*********************************************
            [imgView1 release];
        }
        else{//如果联合创建人的id等于uuid
            BOOL isdone=NO;
            if (self.creaters.count==0) {
                isdone=NO;
            }
            for (int i=0; i<[self.creaters count]; i++) {
                if ([[[self.creaters objectAtIndex:i] objectForKey:@"USER_ID"] isEqualToNumber:self.uuid]) {
                    isdone=YES;
                }
            }
            if(isdone){
                //***************************************图片后面的背景*********************************************
                cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MASSAGEjoinup@2x.png"]]autorelease];
                //***************************************图片后面的背景  end*********************************************
                UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(27, 0, 52, 48)];
                NSURL* imageurl=[NSURL URLWithString:[[self.partyId objectForKey:@"p_user_id"] objectForKey:@"USER_PIC"]];
                [imgView2 setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
                //***************************************信息显示*********************************************
                
                UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(90, 16, 11, 13)];
                NSString* sexstr=[self.senderDic objectForKey:@"SENDER_SEX"];
                if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
                    seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
                }
                else
                {
                    seximage.image=[UIImage imageNamed:@"PRfemale1.png"];
                }
                [cell.contentView addSubview:seximage];
                [seximage release];

                UILabel *mylabel=[[UILabel alloc]initWithFrame:CGRectMake(105, 16, 138, 15)];              mylabel.text=[[self.partyId objectForKey:@"p_user_id"] objectForKey:@"USER_NICK"];
                mylabel.font=[UIFont systemFontOfSize:14];
                mylabel.backgroundColor=[UIColor clearColor];
                mylabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
                [cell.contentView addSubview:mylabel];
                [mylabel release];
                
                UILabel* wantlabel=[[UILabel alloc]initWithFrame:CGRectMake(87, 35, 163, 15)];
                NSMutableString *mutableSyting=[[NSMutableString alloc]init];
                [mutableSyting appendFormat:@"邀请你联合创建:"];
                //        [mutableSyting appendFormat:@"%@",[self.partyId objectForKey:@"P_TITLE"]];
                wantlabel.text=mutableSyting;
                wantlabel.textColor=[UIColor lightGrayColor];
                wantlabel.font=[UIFont systemFontOfSize:11];
                wantlabel.backgroundColor=[UIColor clearColor];
                
                [cell.contentView addSubview:wantlabel];
                [wantlabel release];
                [mutableSyting release];
                UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(88, 52, 161, 15)];
                //infolabel.userInteractionEnabled=NO;
                //infolabel.multipleTouchEnabled=NO;
                infolabel.font=[UIFont systemFontOfSize:11];
                infolabel.backgroundColor=[UIColor clearColor];
                infolabel.textColor=[UIColor colorWithRed:101.0/255 green:115.0/255 blue:127.0/255 alpha:1];
                
                infolabel.text=[self.partyId objectForKey:@"P_TITLE"];
                [cell.contentView addSubview:infolabel];
                [infolabel release];
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(88, 68, 200, 15)];
                timeLabel.text=[NSString stringWithFormat:@"时间：%@",self.P_time];//[self.partyId objectForKey:@"P_STIME"]];
                timeLabel.textColor=[UIColor lightGrayColor];
                timeLabel.font=[UIFont systemFontOfSize:11];
                timeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:timeLabel];
                [timeLabel release];
                
                UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(88, 86, 200, 15)];
                placeLabel.text=[NSString stringWithFormat:@"地点：%@",[self.partyId objectForKey:@"P_LOCAL"]];
                placeLabel.textColor=[UIColor lightGrayColor];
                placeLabel.font=[UIFont systemFontOfSize:11];
                placeLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:placeLabel];
                [placeLabel release];
                //***************************************信息显示 end*********************************************
                [cell.contentView addSubview:imgView2];
                [imgView2 release];
                
                
                //***************************************决定时间*********************************************
                if ([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"W"]) {
                    //***************************************添加yes按钮*********************************************
                    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
                    button1.frame=CGRectMake(27, 115, 60, 15);
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"partyMesyes@2x.png"] forState:UIControlStateNormal];
                    
                    [button1 addTarget:self action:@selector(ButtonClick:event:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button1];
                    //***************************************添加yes按钮 end*********************************************
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(164, 117, 52, 12)];
                    timeLabel.text=@"决定时间:";
                    timeLabel.backgroundColor=[UIColor clearColor];
                    timeLabel.tag=105;
                    timeLabel.font=[UIFont systemFontOfSize:12];
                    timeLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    [cell.contentView addSubview:timeLabel];
                    [timeLabel release];
                    //倒计时
                    auctionTime=[[UITextField alloc]initWithFrame:CGRectMake(220, 115, 30, 12)];
                    auctionTime.backgroundColor=[UIColor clearColor];
                    auctionTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    auctionTime.userInteractionEnabled=NO;
                    auctionTime.tag=106;
                    auctionTime.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    auctionTime.text=[NSString stringWithFormat:@"%@",[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"]];
                    //[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_DTIME"];
                    auctionTime.font=[UIFont systemFontOfSize:15];
                    [cell.contentView addSubview:auctionTime];
                    [auctionTime release];
                    
                    UILabel *minLabel=[[UILabel alloc]initWithFrame:CGRectMake(243, 117, 30, 12)];
                    minLabel.backgroundColor=[UIColor clearColor];
                    minLabel.text=@"mins";
                    minLabel.textColor=[UIColor colorWithRed:89.0/255 green:97.0/255 blue:104.0/255 alpha:1];
                    minLabel.font=[UIFont systemFontOfSize:12];
                    [cell.contentView addSubview:minLabel];
                    [minLabel release];
                    
                }
                else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"N"]){
                    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(192, 110, 54, 21)];
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"YGQL@2x.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button1];
                    [button1 release];
                    
                }
                else if([[[[self.message objectAtIndex:indexPath.section] objectForKey:@"M_STATUS"]substringToIndex:1] isEqualToString:@"Y"]){
                    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(27, 112, 54, 21)];
                    button1.backgroundColor=[UIColor clearColor];
                    [button1 setImage:[UIImage imageNamed:@"YCJ@2x.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button1];
                    [button1 release];
                    
                }
                //***************************************决定时间 end*********************************************
                isdone=NO;
            }
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    }
    
    //李萌萌
    if (choiceNumber==2) {
        static NSString *cellSystem=@"systemCell";
        UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellSystem];
        if (!cell) {
            cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSystem] autorelease];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }

        NSDictionary* dict=[self.systemArray objectAtIndex:indexPath.section];
         NSString *stringP_ID=[dict objectForKey:@"p_id"];
        
         if ([stringP_ID intValue] !=0) {
             //排队入场券
             cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PRtick@2x.png"]]autorelease];
             UILabel* titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 6, 100, 20)];
             titlelabel.backgroundColor=[UIColor clearColor];
             titlelabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
             titlelabel.font=[UIFont systemFontOfSize:15];
             titlelabel.text=[dict objectForKey:@"p_title"];
             [cell.contentView addSubview:titlelabel];
             [titlelabel release];
             UILabel* addr=[[UILabel alloc]initWithFrame:CGRectMake(120, 26, 60, 20)];
             addr.text=@"碰头地点:";
             addr.textColor=[UIColor lightGrayColor];
             addr.font=[UIFont systemFontOfSize:13];
             addr.backgroundColor=[UIColor clearColor];
             [cell.contentView addSubview:addr];
             [addr release];
             UITextView* addrView=[[UITextView alloc]initWithFrame:CGRectMake(113, 37, 150, 50)];
             addrView.textColor=[UIColor colorWithRed:123.0/255 green:140.0/255 blue:155.0/255 alpha:1];
             addrView.font=[UIFont systemFontOfSize:10];
             addrView.backgroundColor=[UIColor clearColor];
             addrView.text=[dict objectForKey:@"p_local"];
             addrView.userInteractionEnabled=NO;
             addrView.multipleTouchEnabled=NO;
             [cell.contentView addSubview:addrView];
             [addrView release];
             UILabel* phonel=[[UILabel alloc]initWithFrame:CGRectMake(120, 70, 70, 20)];
             phonel.text=@"联系方式:";
             phonel.font=[UIFont systemFontOfSize:13];
             phonel.textColor=[UIColor lightGrayColor];
             [cell.contentView addSubview:phonel];
             [phonel release];
             UILabel* phone=[[UILabel alloc]initWithFrame:CGRectMake(175, 70, 100, 20)];
             phone.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"p_phone"]];
             phone.textColor=[UIColor colorWithRed:123.0/255 green:140.0/255 blue:155.0/255 alpha:1];
             phone.font=[UIFont systemFontOfSize:13];
             [cell.contentView addSubview:phone];
             [phone release];
             
        }
         else//活动入场券
         {
             cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ACTytick@2x.png"]]autorelease];
             UILabel* titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 20)];
             titlelabel.backgroundColor=[UIColor clearColor];
             titlelabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
             titlelabel.font=[UIFont systemFontOfSize:15];
             titlelabel.text=[dict objectForKey:@"c_title"];
             [cell.contentView addSubview:titlelabel];
             [titlelabel release];
             UILabel* messinfo=[[UILabel alloc]initWithFrame:CGRectMake(120, 32, 170, 25)];
             messinfo.backgroundColor=[UIColor clearColor];
             messinfo.font=[UIFont systemFontOfSize:13];
             messinfo.text=@"有新的派对邀请你参加";
             messinfo.textColor=[UIColor colorWithRed:123.0/255 green:140.0/255 blue:155.0/255 alpha:1];
             [cell.contentView addSubview:messinfo];
             [messinfo release];
         
         }

       return cell;
    }
    return nil;

}

-(void)showFriendPic
{
    NSLog(@"xianshi hao you");
    
}

-(void)requestButton:(id)sender event:(id)event{
    sendDate=1;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbView];
    NSIndexPath *indexPath = [tbView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        [self tableView:tbView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}
- (void)ButtonClick:(id)sender event:(id)event
{
    sendDate=2;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbView];
    NSIndexPath *indexPath = [tbView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"selectRow==============%@",indexPath);
    
    if(indexPath != nil)
    {
        [self tableView:tbView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
}

//yes按钮的快捷键
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    selectRow=indexPath.section;
    NSLog(@"selectRow==============%d",selectRow);
    
    //这里加入自己的逻辑
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认发送消息?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSLog(@"确认");
        NSDictionary* dict=[self.message objectAtIndex:selectRow];
        NSString* party_id=[dict objectForKey:@"P_ID"];
        NSString *senderTo=[dict objectForKey:@"SENDER_ID"];
        
        if (sendDate==1) {
            
            NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00054"];
            ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
            [request setPostValue:senderTo forKey: @"user_id"];
            
            NSLog(@"self.senderTo======%@",senderTo);
            
             [request setPostValue:party_id forKey:@"p_id"];            //[request setDelegate:self];
            [request startSynchronous];
        }
        else if(sendDate==2){
            
            NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00053"];
            ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
            [request setPostValue:self.userUUid forKey: @"uuid"];
            [request setPostValue:party_id forKey:@"p_id"];
            //[request setDelegate:self];
            [request startSynchronous];
        }
    }
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00050?uuid=%@&&m_type=party&&from=%d&&to=%d",userUUid,1,[self.message count]];
    flag=0;
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"获取已经修改的派对消息：%@",url);
    NSLog(@"%@",stringUrl);
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];

}

//改变head的高度------已经修改好
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //header高度已经修改好，不需要再动
    if (section==0) {
        return 26;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (choiceNumber==0) {
        if (section==[self.friendlist count]-1) {
            return 140;
        }
        else
            return 1.0f;
    }
    if (choiceNumber==1) {
        if (section==[self.message count]-1) {
            return 140;
        }
        
    }
    
    if (choiceNumber==2) {
        if (section==[self.systemArray count]-1) {
            return 140;
        }
    }
    return 1.0f;
}
//改变行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (choiceNumber==0) {
        return 126;
    }
    else if(choiceNumber==1)
        return 144;
    return 106;
}



//************************点击按钮触发事件*********************


//尹林林
-(IBAction)buttonFriend
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    choiceNumber=0;
    flag=0;
    self.tbView.contentOffset=CGPointMake(0.0, 0.0);
    [self.tbView reloadData];
    if (friBtn!=nil)
    {
        [friBtn removeFromSuperview];
        friBtn=nil;
        NSString *cleanUrlStr=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/msg/IF00061?uuid=%@&m_type=1",userUUid];
        NSLog(@"清空friend消息:%@",cleanUrlStr);
        NSURL* cleanurl=[NSURL URLWithString:cleanUrlStr];
        
        ASIHTTPRequest* cleanrequest=[ASIHTTPRequest requestWithURL:cleanurl];
        [cleanrequest startSynchronous];
    }
    
    
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00016?uuid=%@&&type=friend",userUUid];
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"好友消息：%@",url);
    NSLog(@"%@",stringUrl);
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


//郭江伟
-(IBAction)buttonParty
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    flag=0;
    self.tbView.contentOffset=CGPointMake(0.0, 0.0);
    choiceNumber=1;
    [self.tbView reloadData];
    if (mesBtn!=nil) {
        [mesBtn removeFromSuperview];
        mesBtn=nil;
        NSString *cleanUrlStr=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/msg/IF00061?uuid=%@&m_type=2",userUUid];
        NSLog(@"清空party消息:%@",cleanUrlStr);
        NSURL* cleanurl=[NSURL URLWithString:cleanUrlStr];
        
        ASIHTTPRequest* cleanrequest=[ASIHTTPRequest requestWithURL:cleanurl];
        [cleanrequest startSynchronous];
    }
   
    //测试from有问题,已经解决
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00050?uuid=%@&&m_type=party",userUUid];
    NSLog(@"派对消息：：：%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}


//李萌萌
-(IBAction)buttonSystem
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    choiceNumber=2;
    flag=0;
    self.tbView.contentOffset=CGPointMake(0.0, 0.0);
    [self.tbView reloadData];
    if (sysBtn!=nil) {
        [sysBtn removeFromSuperview];
        sysBtn=nil;
        NSString *cleanUrlStr=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/msg/IF00061?uuid=%@&m_type=3",userUUid];
        NSLog(@"清空system消息:%@",cleanUrlStr);
        NSURL* cleanurl=[NSURL URLWithString:cleanUrlStr];
        
        ASIHTTPRequest* cleanrequest=[ASIHTTPRequest requestWithURL:cleanurl];
        [cleanrequest startSynchronous];
    }
       //from有问题，已经解决
    
  
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00018?uuid=%@&&m_type=system",userUUid];
    NSLog(@"系统消息:::%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (choiceNumber==0) {
        if (section==[self.friendlist count]-1) {
            UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)]autorelease];
            footerview.backgroundColor=[UIColor clearColor];
            UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            morebutton.frame=CGRectMake(57, 20, 206, 32);
            [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
            [morebutton addTarget:self action:@selector(friendMessageclickmore) forControlEvents:UIControlEventTouchDown];
            [footerview addSubview:morebutton];
            return footerview;
        }
    }
    if (choiceNumber==1) {
        if (section==[self.message count]-1) {
            UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)]autorelease];
            footerview.backgroundColor=[UIColor clearColor];
            UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            morebutton.frame=CGRectMake(57, 20, 206, 32);
            [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
            [morebutton addTarget:self action:@selector(partyMessageclickmore) forControlEvents:UIControlEventTouchDown];
            [footerview addSubview:morebutton];
            return footerview;
            
        }
    }
    if (choiceNumber==2) {
        if (section==[self.systemArray count]-1) {
            UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)]autorelease];
            footerview.backgroundColor=[UIColor clearColor];
            UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            morebutton.frame=CGRectMake(57, 20, 206, 32);
            [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
            [morebutton addTarget:self action:@selector(systemMessageclickmore) forControlEvents:UIControlEventTouchDown];
            [footerview addSubview:morebutton];
            return footerview;
            
        }
    }
    return nil;
}


//好友消息加载更多
-(void)friendMessageclickmore
{
    flag=1;
     NSLog(@"好友消息当前返回的数量%d",total);
    if (total<mytotal) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00016?uuid=%@&&type=friend&&from=%d",userUUid,[self.friendlist count]+1];
        NSURL* url=[NSURL URLWithString:stringUrl];
        NSLog(@"加载更多:::好友消息：%@",url);
        NSLog(@"%@",stringUrl);
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}
//派对消息加载更多
-(void)partyMessageclickmore
{
    flag=1;
    if (total<mytotal) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00050?uuid=%@&&m_type=party&&from=%d",userUUid,[self.message count]+1];
        NSLog(@"派对消息加载更多:::%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }

}

//系统消息加载更多
-(void)systemMessageclickmore
{
    flag=1;
    if (total<mytotal) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00018?uuid=%@&&m_type=system&&from=%d",userUUid,[self.systemArray count]+1];
        NSLog(@"系统加载更多：：：%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }

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

-(void)Frichangedatasource
{
    //NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00016?uuid=%@&&type=friend&&from=%d&&to=%d",userUUid,friendselect+1,friendselect+1];
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00016?uuid=%@&&type=friend&&from=%d&&to=%d",userUUid,1,[self.friendlist count]];
    choiceNumber=0;
    flag=0;
    NSURL* url=[NSURL URLWithString:stringUrl];
    NSLog(@"获取已经修改的好友消息：%@",url);
    NSLog(@"%@",stringUrl);
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
//    NSData* response=[request responseData];
//    //NSLog(@"%@",response);
//    NSError* error;
//    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"%@",bizDic);
//    NSArray* messarr=[bizDic objectForKey:@"Messages"];
//    NSLog(@"%@",[self.friendlist objectAtIndex:friendselect]);
//    [self.friendlist replaceObjectAtIndex:friendselect withObject:[messarr objectAtIndex:0]];
//    [self.tbView reloadData];
}
-(void)dealloc
{
    [tbView release];
    [super dealloc];
}
@end
