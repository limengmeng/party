//
//  forthViewController.m
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "forthViewController.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
@implementation forthViewController
@synthesize tableV;
@synthesize keys;
@synthesize words;
@synthesize userUUid;
@synthesize dictory;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"设置";
        UIImage *selectedImage = [UIImage imageNamed:@"shezhizi@2x.png"];
        UIImage *unselectedImage = [UIImage imageNamed:@"shezhi@2x.png"];
        
        UITabBar *tabBar = self.tabBarController.tabBar;
        UITabBarItem *item1 = [tabBar.items objectAtIndex:3];
        [item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        //self.tabBarItem.image=[UIImage imageNamed:@"settings@2x.png"];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getUUidForthis];
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    tableV=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    tableV.dataSource=self;
    tableV.delegate=self;
    tableV.backgroundView=nil;
    tableV.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self.view addSubview:tableV];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%f %f",self.view.frame.size.height,self.view.bounds.size.width);
     
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
    if (sinaFlag==10) {
        NSData* response=[request responseData];
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"1111111111111111guojiangwei %@",bizDic);
        if ([[bizDic objectForKey:@"status"] intValue]==300)  {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该新浪微博已经被绑定过" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            [tableV reloadData];
        }
    }
    else{
    NSData* response=[request responseData];
    NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"guojiangwei %@",bizDic);
    self.dictory=bizDic;
    name=[[NSString alloc] initWithFormat:@"%@",[[self.dictory objectForKey:@"root"] objectForKey:@"USER_NICK"]];
    [tableV reloadData];
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
    if (userUUid==nil) {
        self.userUUid=@"10002";
         NSLog(@"wwwwwwwwwwwwwwwwwwww%@",self.userUUid);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) 
        return 3;
    else 
        return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section=[indexPath section];
    NSUInteger row=[indexPath row];
    static NSString *simpleTableIdentifer=@"simpleTableIdentifer";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifer];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifer]
              autorelease];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    if (section==2) {
        if (row==2) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UPview3@2x.png"]]autorelease];
        }
        else
        {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UPview2@2x.png"]]autorelease];
        }
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UPview@2x.png.png"]]autorelease];
    if (section==0) {
        cell.textLabel.text=@"新浪微博";
        if (sinaFlag==10) {
            [button setBackgroundImage:[UIImage imageNamed:@"bundlinging@2x.png"] forState:UIControlStateSelected];
             [cell.contentView addSubview:button];
            button.userInteractionEnabled=NO;
        }
        else{
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        NSString *xinLang=[[self.dictory objectForKey:@"user_bounndid"] objectForKey:@"BOUND_XIN"];
        
        NSLog(@"%@",xinLang);
        if ([xinLang isEqualToString:@"0"]||[xinLang isEqualToString:@"1"]) {
            button.frame=CGRectMake(244, 10, 46, 28);
            [button setBackgroundImage:[UIImage imageNamed:@"bundling@2x.png"] forState:UIControlStateNormal];
//  [button setBackgroundImage:[UIImage imageNamed:@"bundlinging@2x.png"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            button.frame=CGRectMake(247, 10, 43, 28);
            [button setBackgroundImage:[UIImage imageNamed:@"bundlinging@2x.png"] forState:UIControlStateNormal];
        }
        [button setAlpha:1];
        
        [cell.contentView addSubview:button];
        }
    }
    if (section==1) {
        cell.textLabel.text=@"       我的好友";
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ArrowRightUser@2x.png"]];
        imageView.frame=CGRectMake(13, 15, 16, 13);
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(286, 18, 5, 8)];
        takeimage.image=[UIImage imageNamed:@"Sgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];
    }
    if (section==2){
        if(indexPath.row==0){
            cell.textLabel.text=name;
            UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(249, 8, 27, 27)];

            NSURL* imageurl=[NSURL URLWithString:[[self.dictory objectForKey:@"root"] objectForKey:@"USER_PIC"]];
            [imgView setImageWithURL:imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            [cell.contentView addSubview:imgView];
            [imgView release];
        }
        if(row==1){
            cell.textLabel.text=@"我的账号";
        }if(row==2){
            cell.textLabel.text=@"隐私设置";
        }
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(286, 18, 5, 8)];
        takeimage.image=[UIImage imageNamed:@"Sgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];
    }
    if(section==3){
        cell.textLabel.text=@"关于玩具";
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(286, 18, 5, 8)];
        takeimage.image=[UIImage imageNamed:@"Sgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];
    }if(section==4){
        cell.textLabel.text=@"支持我们投一票";
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(286, 18, 5, 8)];
        takeimage.image=[UIImage imageNamed:@"Sgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    sinaFlag=1;//新浪标志位
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)] autorelease];
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0];
    //headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    if (section == 0) {
        headerLabel.text =  @"授权设置";
    }else if (section == 2){
        headerLabel.text = @"账号设置";
    }
    [customView addSubview:headerLabel];
    return customView;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self getUUidForthis];
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00030?uuid=%@",self.userUUid];
    
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];

    [super viewDidAppear:animated];
    //[self.tableV reloadData];
}
//索引表
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return NULL;
}

-(void)ButtonClick:(UIButton *)btn
{
    if (btn.selected==NO) {
        btn.selected=YES;
        //button.userInteractionEnabled=NO;
        button.frame=CGRectMake(244, 10, 46, 28);
        sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        [sinaWeibo logIn];
        sinaWeibo.delegate=self;
        
    }
    else{
        btn.selected=NO;
        button.frame=CGRectMake(247, 10, 43, 28);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==4) {
        return 140;
    }
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0||section==2)
        return 40;//*mainhight;
    return 19;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=3;
        [self.navigationController pushViewController:friend animated:YES];
    }
    else if (indexPath.section==2){
        if (indexPath.row==0) {
            person=[[MyDetailViewController alloc]init];
            [self.navigationController pushViewController:person animated:YES];
        }
        else if (indexPath.row==1) {
            idViewController=[[IDViewController alloc]init];
            [self.navigationController pushViewController:idViewController animated:YES];
            
        }
        else{
            PrivacyVC=[[PrivacyViewController alloc]init];
            [self.navigationController pushViewController:PrivacyVC animated:YES];
            
        }
    }
    else if(indexPath.section==3){
        aboutVC=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    sinaFlag=10;
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    NSLog(@"1111111111111111111111111111");
    //numberSum=[sinaWeibo.userID integerValue];
    NSURL *url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/sina/SIF00001"];
    ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
    [rrequest setPostValue:sinaWeibo.userID forKey: @"suid"];
    [rrequest setPostValue:self.userUUid forKey:@"uuid"];
    [rrequest setDelegate:self];
    [rrequest startAsynchronous];
    //=================新浪微博登陆成功进入下个界面=======================================
    //    SinaGetViewController *sinaGetView=[[SinaGetViewController alloc]init];
    //    //[self.navigationController pushViewController:sinaGetView animated:YES];
    //    [self.view addSubview:sinaGetView.view];
    
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    
    
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    [sinaweibo logOut];
    //====================新浪微博登陆不成功返回==================================================
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}
- (void)removeAuthData
{
    NSLog(@"removeAuthData");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}
#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    if([request.url hasSuffix:@"friendships/friends/bilateral.json"])
    {
        
    }
    if ([request.url hasSuffix:@"users/show.json"])
    {
       
       
        
    }
}
-(void)dealloc
{
    [tableV release];
    [name release];
    [friend release];
    [person release];
    [idViewController release];
    [PrivacyVC release];
    [aboutVC release];
    [super dealloc];
}

@end
