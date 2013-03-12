//
//  CheckOneViewController.m
//  NavaddTab
//
//  Created by ldci 尹 on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckOneViewController.h"
//#import "CreatPartyViewController.h"
#import "infoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SDImageView+SDWebCache.h"
NSInteger prerow=-1;
@interface CheckOneViewController ()

@end

@implementation CheckOneViewController
@synthesize userUUid;
@synthesize from_c_id;
@synthesize from_p_id;
@synthesize playList;
@synthesize choiceFriends;
@synthesize spot;

@synthesize list;
@synthesize lastIndexPath;
//@synthesize Cell;
@synthesize delegateFriend;


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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    self.tableView.backgroundView=nil;
    //self.tableView=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.title=@"好友列表";
    //******************************右侧确认按钮************************************
    //确定
    if(self.spot!=3){
        UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
        donebutton.frame=CGRectMake(0.0, 0.0, 50, 31);
        [donebutton setImage:[UIImage imageNamed:@"Editdone@2x.png"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
        self.navigationItem.rightBarButtonItem=Makedone;
        [Makedone release];
    }
    
    choiceFriends=[[NSMutableArray alloc]init];
    if(self.spot==2)
        [self loadPartydetail];
    else
        [self loadFridetail];

    //******************************右侧确认按钮 end************************************
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

//从服务器获取好友数据
-(void)loadFridetail{
    dataFlag=1;
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00009?uuid=%@",userUUid];
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

//从服务器获取玩伴数据

-(void)loadPartydetail{
    dataFlag=2;
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00007?uuid=%@&&c_id=%@",userUUid,self.from_c_id];
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
//******************************ASIHttp 代理方法************************************
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (dataFlag==2) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        playList=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        [self loadFridetail];
    }else if(dataFlag==1){
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        list=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        NSLog(@"好友列表finish=============%@",self.list);
    }
    NSLog(@"好友列表finish=============%@",self.list);
    [self.tableView reloadData];
}

//请求失败
- ( void )requestFailed:( ASIHTTPRequest *)request
{
    NSError *error = [request error ];
    NSLog ( @"%@" ,error. userInfo );
}
//******************************ASIHttp 代理方法 end************************************

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.spot==2) {
        return 2;
    }
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回好友数据
    if(section==0)
        return [self.list count];
    else
        return [self.playList count];//返回玩伴数据
}

//******************************section标题************************************
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)] autorelease];
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    //headerLabel.textColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0];
    headerLabel.textColor=[UIColor lightGrayColor];
    //headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    if(section==0){
        if(self.spot==1||self.spot==3)
            headerLabel.text =  @"";
        else
            headerLabel.text =  @"好友列表";
    }
    else
        headerLabel.text = @"玩伴列表";
    [customView addSubview:headerLabel];
    return customView;
}
//******************************section标题 end************************************

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        if(self.spot==1||self.spot==3)
            return 0;
        else
            return 40;
    }
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"]autorelease];
        //*****************************头像**************************************
        UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(9, 8, 39, 39)];
       
        imgView.tag=100;
        [cell.contentView addSubview:imgView];
        [imgView release];
        //*****************************头像 end**************************************
        
        //*****************************性别***********************************
        UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(58, 12, 11, 13)];
        seximage.tag=101;
        [cell.contentView addSubview:seximage];
        [seximage release];
        //*****************************性别 end***********************************
        
        //*****************************姓名***********************************
        UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 9, 100, 20)];
        namelabel.font=[UIFont systemFontOfSize:14];
        namelabel.tag=102;
        namelabel.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
        namelabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:namelabel];
        [namelabel release];
        //*****************************姓名 end***********************************
        
        //*****************************年龄***********************************
        UILabel* agelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25 , 25, 30)];
        agelabel.font=[UIFont systemFontOfSize:13];
        agelabel.backgroundColor=[UIColor clearColor];
        agelabel.textColor=[UIColor grayColor];
        agelabel.tag=103;
        [cell.contentView addSubview:agelabel];
        [agelabel release];
        //*****************************年龄 end***********************************
        
        //*****************************城市 地区***********************************
        UILabel* citylabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 25, 40, 30)];
        citylabel.font=[UIFont systemFontOfSize:13];
        citylabel.backgroundColor=[UIColor clearColor];
        citylabel.textColor=[UIColor grayColor];
        citylabel.tag=104;
        UILabel* locallabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 25, 40, 30)];
        locallabel.font=[UIFont systemFontOfSize:13];
        locallabel.backgroundColor=[UIColor clearColor];
        locallabel.textColor=[UIColor grayColor];
        locallabel.tag=105;
        [cell.contentView addSubview:citylabel];
        [cell.contentView addSubview:locallabel];
        [citylabel release];
        [locallabel release];
        //*****************************城市 地区 end**********************************
    }
    NSUInteger row=[indexPath row];
    NSDictionary *dic=[NSDictionary dictionary];
    if(indexPath.section==0){
        dic=[self.list objectAtIndex:row];
        NSLog(@"好友列表=============%@",self.list);
    }
    else if(indexPath.section==1){
        dic=[self.playList objectAtIndex:row];
        NSLog(@"玩伴列表=============%@",self.playList);
    }
    
    UILabel* nameLabel=(UILabel *)[cell viewWithTag:102];
    nameLabel.text=[dic objectForKey:@"USER_NICK"];
    
    NSURL* imageurl=[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]];
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:100];
    [imgView setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    
    UIImageView *seximage=(UIImageView *)[cell viewWithTag:101];
    if([[[dic objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"M"])
        seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
    else
        seximage.image=[UIImage imageNamed:@"PRfemale1@2x.png"];
    
    UILabel *ageLabel=(UILabel *)[cell viewWithTag:103];
    ageLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"USER_AGE"]];
    
    UILabel *cityLabel=(UILabel *)[cell viewWithTag:104];
    if (![[dic objectForKey:@"USER_CITY"] isEqualToString:@"(null)"]) {
        cityLabel.text=[dic objectForKey:@"USER_CITY"];
    }
    
    UILabel *locabel=(UILabel *)[cell viewWithTag:105];
    if (![[dic objectForKey:@"USER_LOCAL"] isEqualToString:@"(null)"]) {
        locabel.text=[dic objectForKey:@"USER_LOCAL"];
    }

    if (self.spot!=3) {
        UIImageView *imagView=[[UIImageView alloc]initWithFrame:CGRectMake(289,19,21,21)];
        imagView.image=[UIImage imageNamed:@"check1@2x.png"];
        imagView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:imagView];
        [imagView release];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* newcell=[tableView cellForRowAtIndexPath:indexPath];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    //******************************查看好友详细信息************************************
    if (spot==3) {
        newcell.accessoryType=UITableViewCellAccessoryNone;
        self.hidesBottomBarWhenPushed=YES;
        infoViewController *info=[[infoViewController alloc]init];
        info.user_id=[[self.list objectAtIndex:indexPath.row] objectForKey:@"USER_ID"];
        [self.navigationController pushViewController:info animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        [info release];
    }
    //******************************查看好友详细信息 end************************************
    else{
        if(newcell.accessoryType==UITableViewCellAccessoryNone){
            if (temp<5) {
                if(newcell.accessoryType=UITableViewCellAccessoryCheckmark){
                    //************************添加对勾************************************
                    UIImage *image= [UIImage   imageNamed:@"checkcell@2x.png"];
                    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
                    button.frame = frame;
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                    button.backgroundColor = [UIColor clearColor];
                    newcell.accessoryView=button;
                    //[newcell.contentView addSubview:button];
                    //************************添加对勾 end************************************
                    if(indexPath.section==0)
                        [self.choiceFriends addObject:[self.list objectAtIndex:indexPath.row]];
                    else
                        [self.choiceFriends addObject:[self.playList objectAtIndex:indexPath.row]];
                    if(self.spot==1) temp++;
                }
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"人数不能超过5人" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
        else{
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor= [UIColor clearColor];
            newcell.accessoryView= button;
            newcell.accessoryType=UITableViewCellAccessoryNone;
            if(indexPath.section==0)
                [self.choiceFriends removeObject:[self.list objectAtIndex:indexPath.row]];
            if(self.spot==1) temp--;
        }
        lastIndexPath=indexPath;
    }
}

//******************************上传邀请好友信息************************************
-(void)rightAction{
    
    if (self.from_p_id!=0) {
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00023"];
        for (int i=0; i<[self.choiceFriends count]; i++) {
            ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
            [request setPostValue:self.userUUid forKey: @"uuid"];
            [request setPostValue:[[self.choiceFriends objectAtIndex:i] objectForKey:@"USER_ID"] forKey:@"user_id"];
            [request setPostValue:self.from_p_id forKey:@"p_id"];
            //[request setDelegate:self];
            [request startSynchronous];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"self.choiceFriends=======%@",self.choiceFriends);
    if(self.spot==1){
        if (self.from_p_id==0)
            [delegateFriend CallBack:self.choiceFriends];
        //[self.choiceFriends removeAllObjects];
    }
}
//******************************上传邀请好友信息 end************************************

//******************************删除好友************************************


- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.spot==3) {
        return UITableViewCellEditingStyleDelete;
    }else
        return UITableViewCellEditingStyleNone;
	//不能是UITableViewCellEditingStyleNone
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.spot==3) {
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00022"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey:@"uuid"];
        [rrequest setPostValue:[[self.list objectAtIndex:indexPath.row] objectForKey:@"USER_ID"] forKey:@"user_id"];
        NSLog(@"user_id====%@",[self.list objectAtIndex:indexPath.row]);
        [rrequest startSynchronous];
        
        [self.list removeObjectAtIndex:indexPath.row];
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        [self.tableView reloadData];
    }
}
//******************************删除好友 end************************************


-(void)dealloc{
    [super dealloc];
}

-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}


@end
