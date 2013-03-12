//
//  TwoViewController.m
//  party
//
//  Created by li on 13-1-17.
//
//

#import "TwoViewController.h"
#import "SDImageView+SDWebCache.h"
@interface TwoViewController ()

@end

@implementation TwoViewController

@synthesize tableview;
@synthesize items;
@synthesize p_id;
@synthesize party;
@synthesize userUUid;
@synthesize numberUUID;
@synthesize creatUser,joinUser;
@synthesize FlowView;
-(void)applicationDidEnterBackground:(UIApplication *)application
{
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
            }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
           }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    numFlogLogout=0;
    [self hideTabBar:YES];
    [self getUUidForthis];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    mark=0;
    //[UIApplication sharedApplication].delegate=self;
    //self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    [table release];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
  //======================================
    stringA=[[NSMutableString alloc]initWithCapacity:100];
    
    //==================请求数据========================================
    NSString *stringP=[[NSString alloc]initWithFormat:@"http://www.ycombo.com/che/mac/party/IF00002?party_id=%@&&uuid=%@",p_id,userUUid];
    NSLog(@"shuchuwangzhi::::::::::::::::%@",stringP);
    NSURL* url=[NSURL URLWithString:stringP];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    [stringP release];
    //==============================
    label = [[UILabel alloc] initWithFrame:CGRectMake(70,100,180,100)];
    label.numberOfLines =0;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    
    //=======================================
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"POtop@2x.png"] forBarMetrics:UIBarMetricsDefault];
    // NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1] forKey:UITextAttributeTextColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:239.0/255.0 green:105.0/255.0 blue:87.0/255.0 alpha:1.0],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:18],
                          UITextAttributeFont,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"POBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    [goback release];
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
    if (userUUid==nil) {
        userUUid=@"10002";
    }
    self.numberUUID=[NSNumber numberWithInt:[stringUUID intValue]];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (numFlogLogout==0) {
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    self.party =[bizDic objectForKey:@"party"];
    NSLog(@"hhhhhhhhhhhhhhhhhhhhhh%@",party);
    self.creatUser=[party objectForKey:@"creaters"];
    self.joinUser=[party objectForKey:@"participants"];
    NSDictionary* userdict=[self.creatUser objectAtIndex:0];
    label.text=[userdict objectForKey:@"USER_NICK"];
    NSString *stringButton=[[party objectForKey:@"P_STATUS"]substringToIndex:1];
    back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[stringButton substringToIndex:1] isEqualToString:@"N"]) {
        UIButton *buttonGoParty=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonGoParty setImage:[UIImage imageNamed:@"POgo@2x.png"] forState:UIControlStateNormal];
        buttonGoParty.titleLabel.text=@"加入派对";
        [buttonGoParty addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonGoParty setFrame:CGRectMake(0,mainscreenhight-107, 160, 44)];
        [self.view addSubview:buttonGoParty];
    }
    if ([[stringButton substringToIndex:1]isEqualToString:@"Y"]) {
        [back setImage:[UIImage imageNamed:@"POwontgo@2x.png"] forState:UIControlStateNormal];
        back.titleLabel.text=@"我不去了";
        [back addTarget:self action:@selector(buttonNojoin:) forControlEvents:UIControlEventTouchUpInside];
        [back setFrame:CGRectMake(0,mainscreenhight-107, 160, 44)];
        [self.view addSubview:back];
     
        
    }
    if ([[stringButton substringToIndex:1]isEqualToString:@"W"]) {
        back.titleLabel.text=@"等待";
        [back setImage:[UIImage imageNamed:@"POgo@2x.png"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(buttonNojoinWaite) forControlEvents:UIControlEventTouchUpInside];
        [back setFrame:CGRectMake(0,mainscreenhight-107, 160, 44)];
        [self.view addSubview:back];
    }
   
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(158, mainscreenhight-100, 2, 30)];
    imageView.image=[UIImage imageNamed:@"CutOffRule.png"];
    
    [self.view addSubview:imageView];
    [imageView release];
    //==========邀请按钮===============================
    join =[UIButton buttonWithType:UIButtonTypeCustom];
    [join setImage:[UIImage imageNamed:@"POinvite@2x.png"] forState:UIControlStateNormal];
    [join addTarget:self action:@selector(showFriendView:) forControlEvents:UIControlEventTouchUpInside];
    [join setFrame:CGRectMake(160,mainscreenhight-107, 160, 44)];
    [self.view addSubview:join];
    FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
	FlowView.delegate = self;
    FlowView.dataSource = self;
    FlowView.minimumPageAlpha = 0.7;
    FlowView.minimumPageScale = 0.6;
    [tableview reloadData];
    }

}
-(void)buttonNojoinWaite
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在等待创建者同意" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)buttonNojoin:(UIButton *)btn
{
    NSString *stringPid=[party objectForKey:@"P_ID"];
    for (NSDictionary *dicJion in [party objectForKey:@"creaters"])
    {
        if ([[dicJion objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID]) {
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你是联合创建人，不能退出活动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
    }
    
    for ( NSDictionary *dicParty in [party objectForKey:@"participants"])
    {
        numFlogLogout=1;
        NSLog(@"qqqqqqqqqqqqqqqqqqq%@",[dicParty objectForKey:@"USER_ID"]);
        NSLog(@"wwwwwwwwwwwwwwwwwww%@",self.userUUid);
        if ([[dicParty objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID])
        {
           
        NSURL *url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00041"];
        NSLog(@"pidssssssssssss%@",stringPid);
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
            [rrequest setPostValue:self.userUUid forKey: @"uuid"];
            [rrequest setPostValue:stringPid forKey: @"p_id"];
            [rrequest setDelegate:self];
            [rrequest startAsynchronous];
            
        }

    }
}
-(void)ButtonClick:(UIButton *)btn
{
    NSLog(@"wwwwwwwwwww");
    //btn.selected=!btn.selected;
    invit=[[InvitViewController alloc]init];
    invit.temp=2;
    invit.from_p_id=[party objectForKey:@"P_ID"];
    NSLog(@"输出pid%@",invit.from_p_id);
    [self.navigationController pushViewController:invit animated:YES];
}
-(void)showFriendView:(UIButton *)btF
{
    btF.selected=!btF.selected;
    NSLog(@"join");
    if ([[party objectForKey:@"P_TYPE"]intValue]==1) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=1;
        friend.from_p_id=[party objectForKey:@"P_ID"];
        [self.navigationController pushViewController:friend animated:YES];
        
    }
    else if ([[party objectForKey:@"P_TYPE"]intValue]==2) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=2;
        friend.from_p_id=[party objectForKey:@"P_ID"];
        friend.from_c_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:friend animated:YES];
    }
    else if([[party objectForKey:@"P_TYPE"]intValue]==3){
        friend=[[CheckOneViewController alloc]init];
        friend.spot=2;
        friend.from_p_id=[party objectForKey:@"P_ID"];
        friend.from_c_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:friend animated:YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top22@2x.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:20],
                          UITextAttributeFont,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;

}
//========================== 分组个数============================================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
        return 3;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 230;
    }
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //不需要界面适配
    if (section==3) {
        return 60;
    }
    else
        return 5.0f;
}
//=====================行的间距======================================================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            return 25;
        }
        if (indexPath.row==1) {
            UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
            
        }
        if (indexPath.row==2) {
            return 15;
        }
    }
    return 28;
}
//==================cell的内容=====================================================
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellAccessoryNone;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.backgroundColor=[UIColor clearColor];
    if (indexPath.section==0) {
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOmessage@2x.png"]]autorelease];
        UIImageView* labelImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"POlabel@2x.png"]];
        labelImage.frame=CGRectMake(6, 8, 8, 12);
        [cell.contentView addSubview:labelImage];
        [labelImage release];
        cell.textLabel.text=@"  所属活动:";
        
        UILabel* ctitle=[[UILabel alloc]initWithFrame:CGRectMake(80, 4, 200, 20)];
        ctitle.font=[UIFont systemFontOfSize:14];
        ctitle.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:ctitle];
        [ctitle release];
        //不属于任何活动
        if ([[party objectForKey:@"P_TYPE"]intValue]==1)
        {
            ctitle.text=@"[无]";
        }
        else{
            UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 8, 10)];
            takeimage.image=[UIImage imageNamed:@"AOgo@2x.png"];
            [cell.contentView addSubview:takeimage];
            [takeimage release];
            ctitle.text=[party objectForKey:@"C_TITLE"];
        }
    }
    
    
    if (indexPath.section==1) {
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOmessage@2x.png"]]autorelease];
        UIImageView* labelImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"POtime@2x.png"]];
        labelImage.frame=CGRectMake(4, 8, 12, 12);
        [cell.contentView addSubview:labelImage];
        [labelImage release];
        cell.textLabel.text=@"   时间:";
         cell.textLabel.backgroundColor=[UIColor clearColor];
    
        UILabel* timelabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 4, 200, 20)];
        timelabel.font=[UIFont systemFontOfSize:14];
        timelabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd  HH:mm"];
        NSInteger time=[[party objectForKey:@"P_TIME"]integerValue];
        NSLog(@"%d",time);
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timelabel.text=confromTimespStr;
        [cell.contentView addSubview:timelabel];
        [timelabel release];
        [formatter release];
    }
    if (indexPath.section==2) {
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOmessage@2x.png"]]autorelease];
        UIImageView* labelImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"POlocation@2x.png"]];
        labelImage.frame=CGRectMake(6, 8, 10, 12);
        [cell.contentView addSubview:labelImage];
        [labelImage release];
        cell.textLabel.text=@"   地点:";
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 8, 10)];
        takeimage.image=[UIImage imageNamed:@"AOgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];
         cell.textLabel.backgroundColor=[UIColor clearColor];
        UILabel* addrlabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 4, 200, 20)];
        addrlabel.font=[UIFont systemFontOfSize:14];
        addrlabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        addrlabel.text=[party objectForKey:@"P_LOCAL"];
        [cell.contentView addSubview:addrlabel];
        [addrlabel release];
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOInformation1@2x.png"]]autorelease];
            UIImageView *labelimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"POinfo@2x.png"]];
            labelimage.frame=CGRectMake(6, 9, 9, 12);
            [cell.contentView addSubview:labelimage];
            [labelimage release];
            UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(23, 9, 200, 15)];
            infolabel.text=@"活动介绍:";
            infolabel.font=[UIFont systemFontOfSize:14];
            infolabel.textColor=[UIColor lightGrayColor];
            infolabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:infolabel];
            [infolabel release];
        }
        if (indexPath.row==1) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOInformation2@2x.png"]]autorelease];
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            labelName.numberOfLines = 0;
            labelName.font=[UIFont systemFontOfSize:14];
            labelName.backgroundColor=[UIColor clearColor];
            labelName.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            [cell.contentView addSubview:labelName];
            
            
            CGRect cellFrame = CGRectMake(12, 10.0, 280, 30);
            labelName.text=[party objectForKey:@"P_INFO"];
            CGRect rect = cellFrame;
            labelName.frame = rect;
            [labelName sizeToFit];
            cellFrame.size.height = labelName.frame.size.height+10;
            [cell setFrame:cellFrame];
            [labelName release];
        }
        if (indexPath.row==2) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOInformation3@2x.png"]]autorelease];
        }
        
        return cell;
    }
    return cell;
}
//=========================界面跳转=======================================
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    twoViewController.title=@"活动";
    //    [self.navigationController pushViewController:twoViewController animated:YES];
    
    if (indexPath.section==0) {
        if ([[party objectForKey:@"P_TYPE"]intValue]==2) {
            acdetail=[[DetailViewController alloc]init];
            acdetail.C_id=[party objectForKey:@"C_ID"];
            [self.navigationController pushViewController:acdetail animated:YES];
            
        }
        else
            if ([[party objectForKey:@"P_TYPE"]intValue]==3) {
                addrdetail=[[AddrDetailViewController alloc]init];
                addrdetail.C_id=[party objectForKey:@"C_ID"];
                [self.navigationController pushViewController:addrdetail animated:YES];
            }
        
    }
    if (indexPath.section==2) {
        mapViewController=[[MyMapViewController alloc] init];
        //[mapViewController initData:self.party];
        //转换出现问题，待解决
        
        float lat=[[self.party objectForKey:@"LAT"]floatValue];
        float lng=[[self.party objectForKey:@"LNG"]floatValue];
        NSLog(@"2++++++%f %f",lat,lng);
        [mapViewController initData:lat and:lng];
        [mapViewController initTitle:[self.party objectForKey:@"P_TITLE"]];
        [self.navigationController pushViewController:mapViewController animated:YES];
        
    }
}
//==================头部放置动画效果===============================================
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIButton* personButton=[UIButton buttonWithType:UIButtonTypeCustom];
    personButton.frame=CGRectMake(0, 170, 160, 44);
    
    NSString *stringPerson=[NSString stringWithFormat:@"%d 创建者",self.creatUser.count];
    personButton.titleLabel.text=stringPerson;
    personButton.tag=501;
    UIButton* personButtonUnin=[UIButton buttonWithType:UIButtonTypeCustom];
    personButtonUnin.frame=CGRectMake(160, 170, 160, 44);
    NSString *stringPersonUnin=[NSString stringWithFormat:@"%d创建者",self.joinUser.count];
    personButtonUnin.titleLabel.text=stringPersonUnin;
    personButtonUnin.tag=502;
    if (mark==0) {
        [personButton setBackgroundImage:[UIImage imageNamed:@"PARmaker@2x.png"] forState:UIControlStateNormal];
        personButton.userInteractionEnabled=NO;
        [personButtonUnin setBackgroundImage:[UIImage imageNamed:@"joinerin@2x.png"] forState:UIControlStateNormal];
        [personButtonUnin addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lableNumc=[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 50, 50)];
        lableNumc.textColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumc.backgroundColor=[UIColor clearColor];
        lableNumc.shadowColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumc.font=[UIFont systemFontOfSize:25];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumc.text=[NSString stringWithFormat:@"%d",self.creatUser.count];
        //lableNumc.layer.shadowOpacity=0.5;
        [personButton addSubview:lableNumc];
        [lableNumc release];
        UILabel *lableNumJ=[[UILabel alloc]initWithFrame:CGRectMake(-5, -2, 50, 50)];
        lableNumJ.textColor=[UIColor colorWithRed:123/255.0f green:140/255.0f blue:155/255.0f alpha:1];
        lableNumJ.backgroundColor=[UIColor clearColor];
        lableNumJ.font=[UIFont systemFontOfSize:25];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumJ.text=[NSString stringWithFormat:@"%d",self.joinUser.count];
        lableNumJ.shadowColor=[UIColor darkGrayColor];
        lableNumJ.textAlignment = UITextAlignmentRight;
        [personButtonUnin addSubview:lableNumJ];
        [lableNumJ release];
    }
    if (mark==1) {
        [personButton setBackgroundImage:[UIImage imageNamed:@"PARmakerin@2x.png"] forState:UIControlStateNormal];
        [personButton addTarget:self action:@selector(segmentClickJion:) forControlEvents:UIControlEventTouchUpInside];
        [personButtonUnin setBackgroundImage:[UIImage imageNamed:@"jiner@2x.png"] forState:UIControlStateNormal];
        personButtonUnin.userInteractionEnabled=NO;
        UILabel *lableNumc=[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 50, 50)];
        lableNumc.textColor=[UIColor colorWithRed:123/255.0f green:140/255.0f blue:155/255.0f alpha:1];
        lableNumc.backgroundColor=[UIColor clearColor];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumc.shadowColor=[UIColor darkGrayColor];
        lableNumc.font=[UIFont systemFontOfSize:25];
        lableNumc.text=[NSString stringWithFormat:@"%d",self.creatUser.count];
        [personButton addSubview:lableNumc];
        [lableNumc release];
        UILabel *lableNumJ=[[UILabel alloc]initWithFrame:CGRectMake(-5, -2, 50, 50)];
        lableNumJ.textColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumJ.backgroundColor=[UIColor clearColor];
        lableNumJ.shadowColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumJ.font=[UIFont systemFontOfSize:25];
        lableNumJ.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumJ.text=[NSString stringWithFormat:@"%d",self.joinUser.count];
        lableNumJ.textAlignment = UITextAlignmentRight;
        [personButtonUnin addSubview:lableNumJ];
        [lableNumJ release];

    }
    
   
    
    if (section==0) {
        UIView* view=[[[UIView alloc]initWithFrame:CGRectMake(0,100, 320, 100)]autorelease];
        view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"beijingbai@2x.png"]];
        [view addSubview:FlowView];
        [view addSubview:label];
        [view addSubview:personButton];
        [view addSubview:personButtonUnin];
        return view;
    }
    return nil;

}
//=================选择哪个Segment改变图片的位置======================================
- (void)segmentClick:(UIButton *)btn
{
    
    mark=1;
    if ([self.joinUser count]!=0) {
        NSDictionary* userdict=[self.joinUser objectAtIndex:0];
        label.text=[userdict objectForKey:@"USER_NICK"];
        [FlowView removeFromSuperview];
        [FlowView release];
        FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
        FlowView.delegate = self;
        FlowView.dataSource = self;
        FlowView.minimumPageAlpha = 0.7;
        FlowView.minimumPageScale = 0.6;
        [tableview reloadData];

    }
}
-(void)segmentClickJion:(UIButton *)btn
{
    mark=0;
    NSDictionary* userdict=[self.creatUser objectAtIndex:0];
    label.text=[userdict objectForKey:@"USER_NICK"];
    [FlowView removeFromSuperview];
    [FlowView release];
    FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
	FlowView.delegate = self;
    FlowView.dataSource = self;
    FlowView.minimumPageAlpha = 0.7;
    FlowView.minimumPageScale = 0.6;
    [tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(120,120);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView
{
    NSLog(@"Scrolled to page # %d", pageNumber);
    
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:pageNumber];
        label.text=[userdict objectForKey:@"USER_NICK"];
        
        
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:pageNumber];
            label.text=[userdict objectForKey:@"USER_NICK"];

        }
    }

    
    if (OldPage < pageNumber)
    {
        label.center = CGPointMake(320+75,label.center.y);
    }else if(OldPage > pageNumber)
    {
        label.center = CGPointMake(-75,label.center.y);
    }
    
    label.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         label.center = CGPointMake(160,label.center.y);
         
     }completion:^(BOOL finished)
     {
         
     }];
    
    OldPage = pageNumber;
}

-(void)scrollViewdidend
{
    label.alpha = 1.0;
}

- (void)didScroll:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView point:(CGPoint)thePoint
{
  

    float point_x = (label.center.x - 1*(thePoint.x - oldPoint.x));
    
    label.center = CGPointMake(point_x,label.center.y);
    
    NSLog(@"000000   %f",point_x);
    if (label.center.x - (thePoint.x - oldPoint.x) -160 > 0)
    {
        label.alpha = fabs((double)((320-point_x)/160));
    }else
    {
        label.alpha = fabs((double)point_x/160);
    }
    oldPoint = thePoint;
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:pageNumber];
        label.text=[userdict objectForKey:@"USER_NICK"];
        
        
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:pageNumber];
            label.text=[userdict objectForKey:@"USER_NICK"];
            
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (mark==0) {
        return [self.creatUser count];
        
    }
    else{
        
        return [self.joinUser count];
        
    }
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    NSLog(@"index = %d",index);
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    
    NSURL *urlPic;
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:index];
        urlPic=[NSURL URLWithString:[userdict objectForKey:@"USER_PIC"]];
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:index];
            urlPic=[NSURL URLWithString:[userdict objectForKey:@"U_PIC"]];
        }
    }

    if (!imageView)
    {
        imageView = [[UIImageView alloc] init];
        //imageView.layer.cornerRadius = 70;
        imageView.tag = index+1000;
        imageView.layer.masksToBounds = YES;
        
        imageView.userInteractionEnabled = YES;
        
        [imageView setImageWithURL:urlPic refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];//[UIImage imageNamed:@"13.jpg"];
        imageView.layer.borderWidth=5;
        imageView.layer.shadowColor= [UIColor blackColor].CGColor;
        imageView.layer.shadowOpacity=20;
        imageView.layer.shadowOffset = CGSizeMake(0, 3);
        imageView.layer.borderColor=[[UIColor whiteColor] CGColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
        [tap release];

        
    }
//    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    [imageView setImageWithURL:urlPic refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    return imageView;
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"-----%d",sender.view.tag);
    NSString *string_userId;
    if (mark==0) {
        
        NSDictionary* userdict=[self.creatUser objectAtIndex:sender.view.tag-1000];
        string_userId=[userdict objectForKey:@"USER_ID"];
    }
    if (mark==1) {
        NSDictionary* userdict=[self.joinUser objectAtIndex:sender.view.tag-1000];
        string_userId =[userdict objectForKey:@"USER_ID"];
    }
    friendsViewController=[[friendinfoViewController alloc] init];
    friendsViewController.user_id=string_userId;
    NSLog(@"wqqqqqqqqqqqqqqqqq%@",friendsViewController.user_id);
    [self.navigationController pushViewController:friendsViewController animated:YES];
    
}

//================================设置隐藏tableBar====================================
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

-(void)dealloc
{
    [super dealloc];
    [mapViewController release];
    [friendsViewController release];
    [acdetail release];
    [addrdetail release];
    [friend release];
    [invit release];
}
-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
