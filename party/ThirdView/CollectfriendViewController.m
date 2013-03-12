//
//  CollectfriendViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-23.
//
//

#import "CollectfriendViewController.h"
#import "SDImageView+SDWebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface CollectfriendViewController ()

@end

@implementation CollectfriendViewController
@synthesize C_id;
@synthesize friendlist;
@synthesize userUUid;

-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:YES];
    [self getUUidForthis];
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"Back1@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=back;
    [back release];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"查看好友";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    flag=0;
    total=0;
    	// Do any additional setup after loading the view.
    NSMutableArray* list=[[NSMutableArray alloc]init];
    self.friendlist=list;
    [list release];
    tableview=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    message=[[UILabel alloc]initWithFrame:CGRectMake(50, 100, 220, 20)];
    message.backgroundColor=[UIColor clearColor];
    message.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:message];
    [message release];

    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00007?uuid=%@&&c_id=%@",userUUid,self.C_id];
    NSLog(@"活动中的玩伴;接口7 网址:%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
}
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"wang luo bu gei li");
//    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力，没有获取到数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [soundAlert show];
//    [soundAlert release];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"活动集合中的玩伴，接口7");
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",bizDic);
    if (flag==0) {
        [self.friendlist removeAllObjects];
    }
    total=[[bizDic objectForKey:@"users"] count];
    [self.friendlist addObjectsFromArray:[bizDic objectForKey:@"users"]];
    flag++;
    NSLog(@"%@",self.friendlist);
    [tableview reloadData];
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
    
    UIImageView* picimage=[[UIImageView alloc] initWithFrame:CGRectMake(9, 8, 39, 39)];
   
    UIImageView* seximage;
    
    UILabel* namelabel;
    UILabel* citylabel;
    UILabel* agelabel;
    UILabel* locallabel;
    picimage.tag=1001;
    NSDictionary* dict=[self.friendlist objectAtIndex:indexPath.row];
    NSLog(@"%d++++++++++++%@",indexPath.row,dict);
    
    [picimage setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    
    seximage=[[UIImageView alloc]initWithFrame:CGRectMake(58, 12, 11, 13)];
    NSString* sexstr=[dict objectForKey:@"USER_SEX"];
    if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
        seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
    }
    else
    {
        seximage.image=[UIImage imageNamed:@"PRfemale1.png"];
    }
    
    namelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 9, 100, 20)];
    namelabel.font=[UIFont systemFontOfSize:14];
    namelabel.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
    namelabel.backgroundColor=[UIColor clearColor];
    namelabel.text=[dict objectForKey:@"USER_NICK"];
    
    agelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25 , 25, 30)];
    agelabel.font=[UIFont systemFontOfSize:13];
    agelabel.textColor=[UIColor lightGrayColor];
    agelabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"USER_AGE"]];
    agelabel.backgroundColor=[UIColor clearColor];
    
    citylabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 25, 40, 30)];
    citylabel.font=[UIFont systemFontOfSize:13];
    citylabel.textColor=[UIColor lightGrayColor];
    locallabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 25, 40, 30)];
    locallabel.font=[UIFont systemFontOfSize:13];
    locallabel.textColor=[UIColor lightGrayColor];
    if (([[dict objectForKey:@"USER_CITY"] isEqualToString:@"(null)"])||([[dict objectForKey:@"USERE_LOCAL"] isEqualToString:@"(null)"])) {
        citylabel.text=@"";
        locallabel.text=@"";
    }
    else
    {
        citylabel.text=[dict objectForKey:@"USER_CITY"];
        locallabel.text=[dict objectForKey:@"USER_LOCAL"];
    }

    [cell.contentView addSubview:picimage];
    [cell.contentView addSubview:seximage];
    [cell.contentView addSubview:namelabel];
    [cell.contentView addSubview:agelabel];
    [cell.contentView addSubview:citylabel];
    [cell.contentView addSubview:locallabel];
    seximage.tag=1002;
    namelabel.tag=1003;
    agelabel.tag=1004;
    citylabel.tag=1005;
    locallabel.tag=1006;
    [picimage release];
    [seximage release];
    [namelabel release];
    [agelabel release];
    [citylabel release];
    [locallabel release];
    NSLog(@"%@",[dict objectForKey:@"USER_STATUS"]);
    NSString* userid=[dict objectForKey:@"USER_ID"];
    if ([userid intValue]==[userUUid intValue]) {
        NSLog(@"自己");
    }
    else
    {
        if ([[[dict objectForKey:@"USER_STATUS"] substringToIndex:1] isEqualToString:@"Y"]) {
            NSLog(@"已经是好友");
        }
        else
        {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(280,17,21,21);
            button.frame = frame;
            [button setBackgroundImage:[UIImage imageNamed:@"add@2x.png"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            
            [button addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
        }
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)btnClicked:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableview];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        [self tableView:tableview accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}


//申请添加好友的快捷键
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    int  idx = indexPath.row;
    selectRow=indexPath.row;
    //这里加入自己的逻辑
    NSLog(@"%d",idx);
    NSLog(@"快捷键，申请添加好友");
    NSLog(@"申请添加好友,接口IF00012");
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认添加好友?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSLog(@"确认");
        NSDictionary* dict=[self.friendlist objectAtIndex:selectRow];
        NSLog(@"%@",dict);
        NSString* userid=[dict objectForKey:@"USER_ID"];
        NSLog(@"添加好友，接口12+++自己id:%@好友id:%@",self.userUUid,userid);
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00012"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:userid forKey:@"user_id"];
        [rrequest startSynchronous];

    }
}
-(void)ontime
{
    message.text=@"";
    message.backgroundColor=[UIColor clearColor];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
        footerview.backgroundColor=[UIColor clearColor];
        UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        morebutton.frame=CGRectMake(57, 10, 206, 32);
        [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
        [morebutton addTarget:self action:@selector(Friendlistclickmore) forControlEvents:UIControlEventTouchDown];
        [footerview addSubview:morebutton];
        return footerview;

    }
    return nil;
}

-(void)Friendlistclickmore
{
    if (total<mytotal) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"已经返回所有消息" message:@"已经返回所有消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00007?uuid=%@&&c_id=%@&&from=%d",userUUid,self.C_id,self.friendlist.count+1];
        NSLog(@"加载更多++++++活动中的玩伴;接口7 网址:%@",stringUrl);
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict=[friendlist objectAtIndex:indexPath.row];
  
    frindeview=[[friendinfoViewController alloc]init];
    frindeview.user_id=[dict objectForKey:@"USER_ID"];
    if ([[[dict objectForKey:@"USER_STATUS"] substringToIndex:1] isEqualToString:@"Y"])
    {
        frindeview.flag=1;
    }
    else
    {
        frindeview.flag=0;
    }
    NSString* userid=[dict objectForKey:@"USER_ID"];
    if ([userid intValue]==[userUUid intValue]) {
        NSLog(@"自己");
        frindeview.title=[NSString stringWithFormat:@"我的资料"];
    }

    else
    {
       frindeview.title=[NSString stringWithFormat:@"好友信息"];
    }
    [self.navigationController pushViewController:frindeview animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendlist count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;//不需要适应
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 100;
    }
    return 1.0f;
}
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
-(void)dealloc
{
    [super dealloc];
     [frindeview release];
}
-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
