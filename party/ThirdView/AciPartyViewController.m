//
//  AciPartyViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-18.
//
//

#import "AciPartyViewController.h"
#import "SDImageView+SDWebCache.h"
@interface AciPartyViewController ()

@end

@implementation AciPartyViewController
@synthesize tableview;
@synthesize sumArray;
@synthesize stringPartyName;
@synthesize stringNamePID;
@synthesize userUUid;
@synthesize P_label;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSMutableArray* array=[[NSMutableArray alloc]init];
    self.sumArray=array;
    [array release];
    flag=0;
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self getUUidForthis];

    NSString *stringName=[[NSString alloc] initWithFormat:@"http://www.ycombo.com/che/mac/party/IF00006?uuid=%@&&c_id=%@",userUUid,stringNamePID];
    NSLog(@"活动中的party:接口6：网址:%@",stringName);
    NSURL* url=[NSURL URLWithString:stringName];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    [stringName release];

	// Do any additional setup after loading the view.
    tableview=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundColor=[UIColor clearColor];
    tableview.backgroundView=nil;
    self.title=@"派对浏览";
    
    [self.view addSubview:tableview];
}
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"wang luo bu gei li");
//    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力，没有获取到数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [soundAlert show];
//    [soundAlert release];
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
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    total=[[bizDic objectForKey:@"c_pnum"]intValue];
    NSLog(@"%@",bizDic);
    NSArray *array=[bizDic objectForKey:@"partys"];
   
    if (flag==0) {
        [self.sumArray removeAllObjects];
    }
    [self.sumArray addObjectsFromArray:array];
    flag++;
    //stringNameArray=[sumArray o]
    [tableview reloadData];
}

-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sumArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.sumArray.count-1) {
        return 130;
    }
    return 11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=[indexPath section];
    static NSString *cellIndentify=@"BaseCell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify]autorelease];
    }
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    UIImageView *imagePICView0;//类型
    UIImageView *imagePICView1;//其他创建人
    UIImageView *imagePICView2;
    UIImageView *imagePICView3;
    UIImageView *imagePICView4;//主创建人
    UIImageView *imagePICView5;//性别
    
    UILabel *lable1;//联合创建人
    UILabel *lable2;//地点
    UILabel *lable3;//时间
    UILabel *lable4;//主创建人的名字
    UILabel *lable5;//活动类型
    UILabel *lable6;//人数
    UILabel *lable7;//活动名称
    imagePICView0=[[UIImageView alloc]initWithFrame:CGRectMake(3, -7, 40, 27)];
    imagePICView1=[[UIImageView alloc]initWithFrame:CGRectMake(157, 13, 41, 41)];
    imagePICView2=[[UIImageView alloc]initWithFrame:CGRectMake(180, 11, 43, 43)];
    imagePICView3=[[UIImageView alloc]initWithFrame:CGRectMake(208, 9, 45, 45)];
    imagePICView4=[[UIImageView alloc]initWithFrame:CGRectMake(243, 7, 47, 47)];
    imagePICView5=[[UIImageView alloc]initWithFrame:CGRectMake(223, 55, 13, 15)];
    UIImageView* prImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 300, 28)];
    prImage.image=[UIImage imageNamed:@"PRpartyportrait@2x.png"];
    UIImageView* addrImage=[[UIImageView alloc]initWithFrame:CGRectMake(6, 94, 10, 12)];
    UIImageView* peoImage=[[UIImageView alloc]initWithFrame:CGRectMake(6, 77, 10, 10)];
    UIImageView* timeImage=[[UIImageView alloc]initWithFrame:CGRectMake(6, 115, 10, 10)];
    peoImage.image=[UIImage imageNamed:@"PRuser@2x.png"];
    addrImage.image=[UIImage imageNamed:@"PRlocation@2x.png"];
    timeImage.image=[UIImage imageNamed:@"PRtime@2x.png"];
    [cell.contentView addSubview:peoImage];
    [cell.contentView addSubview:addrImage];
    [cell.contentView addSubview:timeImage];
    [peoImage release];
    [addrImage release];
    [timeImage release];
    
    [cell.contentView addSubview:imagePICView0];
    [cell.contentView addSubview:imagePICView1];
    [cell.contentView addSubview:imagePICView2];
    [cell.contentView addSubview:imagePICView3];
    [cell.contentView addSubview:prImage];
    [cell.contentView addSubview:imagePICView4];
    [cell.contentView addSubview:imagePICView5];
    [imagePICView0 release];
    [imagePICView1 release];
    [imagePICView2 release];
    [imagePICView3 release];
    [imagePICView4 release];
    [imagePICView5 release];
    [prImage release];
    
    lable1=[[UILabel alloc]initWithFrame:CGRectMake(106, 68, 190, 27)];
    lable1.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable1.font=[UIFont systemFontOfSize:14.0];
    lable2=[[UILabel alloc]initWithFrame:CGRectMake(60, 80, 253, 43)];
    lable2.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable2.font=[UIFont systemFontOfSize:14.0];
    lable3=[[UILabel alloc]initWithFrame:CGRectMake(64, 102, 244, 35)];
    lable3.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable3.font=[UIFont systemFontOfSize:14.0];
    lable6=[[UILabel alloc]initWithFrame:CGRectMake(89, 68, 46, 27)];
    lable6.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    lable6.font=[UIFont systemFontOfSize:14.0];
    lable4=[[UILabel alloc]initWithFrame:CGRectMake(245, 50, 50, 27)];
    lable4.font=[UIFont systemFontOfSize:10.0];
    lable4.textColor=[UIColor colorWithRed:107.0/255 green:116.0/255 blue:128.0/255 alpha:1];
    lable5=[[UILabel alloc]initWithFrame:CGRectMake(3, -15, 40, 37)];
    lable5.textAlignment=NSTextAlignmentCenter;
    lable5.textColor=[UIColor whiteColor];
    lable5.font=[UIFont systemFontOfSize:10.0];
    lable7=[[UILabel alloc]initWithFrame:CGRectMake(6, 41, 176, 35)];
    lable7.font=[UIFont systemFontOfSize:15.0];
    lable7.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
    lable1.backgroundColor=[UIColor clearColor];
    lable2.backgroundColor=[UIColor clearColor];
    lable3.backgroundColor=[UIColor clearColor];
    lable4.backgroundColor=[UIColor clearColor];
    lable5.backgroundColor=[UIColor clearColor];
    lable6.backgroundColor=[UIColor clearColor];
    lable7.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:lable1];
    [cell.contentView addSubview:lable2];
    [cell.contentView addSubview:lable3];
    [cell.contentView addSubview:lable4];
    [cell.contentView addSubview:lable5];
    [cell.contentView addSubview:lable6];
    [cell.contentView addSubview:lable7];
    [lable1 release];
    [lable2 release];
    [lable3 release];
    [lable4 release];
    [lable5 release];
    [lable6 release];
    [lable7 release];
    
    UILabel* peoLabel=[[UILabel alloc]initWithFrame:CGRectMake(24, 71, 60, 21)];
    peoLabel.textColor=[UIColor lightGrayColor];
    peoLabel.backgroundColor=[UIColor clearColor];
    peoLabel.font=[UIFont systemFontOfSize:14.0];
    peoLabel.text=@"联合创建:";
    [cell.contentView addSubview:peoLabel];
    [peoLabel release];
    UILabel* addrLabel=[[UILabel alloc]initWithFrame:CGRectMake(24, 91, 42, 21)];
    addrLabel.textColor=[UIColor lightGrayColor];
    addrLabel.backgroundColor=[UIColor clearColor];
    addrLabel.font=[UIFont systemFontOfSize:14.0];
    addrLabel.text=@"地点:";
    [cell.contentView addSubview:addrLabel];
    [addrLabel release];
    UILabel* timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(24, 111, 42, 21)];
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont systemFontOfSize:14.0];
    timeLabel.text=@"时间:";
    [cell.contentView addSubview:timeLabel];
    [timeLabel release];

    NSDictionary *dict=[self.sumArray objectAtIndex:section];
    cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PRframe@2x.png"]]autorelease];
    lable5.text=self.P_label;
    imagePICView0.image=[UIImage imageNamed:@"PRTag@2x.png"];

    
    
    NSMutableString *mutableStringLocal=[[NSMutableString alloc] initWithFormat:@"%@",[dict objectForKey:@"P_LOCAL"]];
    
    lable2.text=mutableStringLocal;
    [mutableStringLocal release];
    NSMutableString *mutableStringTime=[[NSMutableString alloc] initWithFormat:@"%@",[dict objectForKey:@"P_STIME"]];
    lable3.text=mutableStringTime;
    [mutableStringTime release];
    lable7.text=[dict objectForKey:@"P_TITLE"];
    lable6.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"puni_num"]];
    NSDictionary *creater=[dict objectForKey:@"ps_creater"];
    if ([[[creater objectForKey:@"PS_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
        imagePICView5.image=[UIImage imageNamed:@"PRmale1@2x.png"];
    }
    if ([[[creater objectForKey:@"PS_SEX"]substringToIndex:1] isEqualToString:@"F"]) {
        imagePICView5.image=[UIImage imageNamed:@"PRfemale1.png"];
    }
    lable4.text= [creater objectForKey:@"PS_NAME"];
    NSURL *url=[NSURL URLWithString:[creater objectForKey:@"PS_IMAGE"]];
    [imagePICView4 setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    imagePICView4.layer.borderColor=[[UIColor whiteColor] CGColor];
    imagePICView4.layer.borderWidth=2;
    imagePICView4.layer.shadowOffset = CGSizeMake(2, 2);
    imagePICView4.layer.shadowOpacity = 0.5;
    imagePICView4.layer.shadowRadius = 2.0;

    //===============联合创建人名字和照片======================================
    
    NSDictionary *mutableArrayDic=[dict objectForKey:@"puni_creaters"];
    NSMutableString *stringNameAll=[[NSMutableString alloc]init];
    int i=0;
    for (NSDictionary *dic in mutableArrayDic) {
        
        NSString *stringNameUin=[dic objectForKey:@"PUNI_NICK"];
        [stringNameAll appendFormat:@"%@,",stringNameUin];
        NSString *stringPic=[dic objectForKey:@"PUNI_IMAGE"];
        NSURL *urlImage=[NSURL URLWithString:stringPic];
        NSLog(@"22222222222222222222222222222%@",stringPic);
        if (i==0) {
            [imagePICView3 setImageWithURL: urlImage refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            imagePICView3.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView3.layer.borderWidth=2;
            imagePICView3.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView3.layer.shadowOpacity = 0.5;
            imagePICView3.layer.shadowRadius = 2.0;
        }
        if (i==1) {
            [imagePICView2 setImageWithURL:urlImage refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            imagePICView2.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView2.layer.borderWidth=2;
            imagePICView2.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView2.layer.shadowOpacity = 0.5;
            imagePICView2.layer.shadowRadius = 2.0;
        }
        if (i==2) {
            [imagePICView1 setImageWithURL:urlImage refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            imagePICView1.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView1.layer.borderWidth=2;
            imagePICView1.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView1.layer.shadowOpacity = 0.5;
            imagePICView1.layer.shadowRadius = 2.0;
            
        }
        i++;
        NSLog(@"11111111111111%@",imagePICView3.image);
    }
    NSMutableString *mutableStringPerson=[[NSMutableString alloc] initWithFormat:@"%@",stringNameAll];
    lable1.text=mutableStringPerson;
    [mutableStringPerson release];
    [stringNameAll release];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==[self.sumArray count]-1) {
        UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
        footerview.backgroundColor=[UIColor clearColor];
        UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        morebutton.frame=CGRectMake(57, 20, 206, 32);
        [morebutton setImage:[UIImage imageNamed:@"PsearchMore@2x.png"] forState:UIControlStateNormal];
        [morebutton addTarget:self action:@selector(PartyClickMore) forControlEvents:UIControlEventTouchDown];
        [footerview addSubview:morebutton];
        UIImageView* shadowview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PRviewShadow@2x.png"]];
        shadowview.backgroundColor=[UIColor clearColor];
        shadowview.frame=CGRectMake(0, 0, 320, 11);
        [footerview addSubview:shadowview];
        [shadowview release];
        return footerview;
    }
    
    else
    {
        UIImageView* shadowview=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PRviewShadow@2x.png"]]autorelease];
        shadowview.backgroundColor=[UIColor clearColor];
        shadowview.frame=CGRectMake(0, 0, 320, 11);
        return shadowview;
    }
    return nil;
}
//加载更多
-(void)PartyClickMore
{
    NSLog(@"本次返回的数量:%d",total);
    if (total<mytotal) {
        //返回的结果已经是所有的了，不需要在加载
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"全部加载完毕" message:@"所有的信息已全部返回" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        //加载更多，所有
        flag++;
        NSString *stringUrl=[[NSString alloc] initWithFormat:@"http://www.ycombo.com/che/mac/party/IF00006?uuid=%@&&c_id=%@&&from=%d",userUUid,stringNamePID,[self.sumArray count]];
        NSLog(@"接口6:%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
        [stringUrl release];
        
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    partyDetail=[[FiveViewController alloc]init];
    NSDictionary *dict=[sumArray objectAtIndex:indexPath.section];
    partyDetail.p_id=[dict objectForKey:@"P_ID"];
    partyDetail.title=[dict objectForKey:@"P_TITLE"];
    [self.navigationController pushViewController:partyDetail animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
    [partyDetail release];
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

@end
