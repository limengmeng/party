//
//  secondViewController.m
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "secondViewController.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
@implementation secondViewController
@synthesize tableViewParty;
@synthesize sumArray;
@synthesize userUUid;
@synthesize lat,lng;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title=@"活动";
        self.tabBarController.view.backgroundColor=[UIColor clearColor];
       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [self getUUidForthis];
    [self hideTabBar:NO];
    grayRC.backgroundImage=[UIImage imageNamed:@"segment@2x.png"];
    grayRC.height = 30;// 强制高度  一般可以用于全是图片的选项
    [super viewWillAppear:animated];
   
}
-(void)viewDidDisappear:(BOOL)animated
{
   
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    flag=0;
    sumArray =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    sumArray=[[NSMutableArray alloc]init];
    
//    //===================附近和所有选择==============================================
    grayRC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"附近",@"最新", nil]];
    grayRC.backgroundImage=[UIImage imageNamed:@"segment@2x.png"];
    [grayRC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    grayRC.textColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
    grayRC.textShadowOffset=CGSizeMake(0, 0);
	grayRC.font = [UIFont boldSystemFontOfSize:12];
	grayRC.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    
	grayRC.height = 30;// 强制高度  一般可以用于全是图片的选项
    //grayRC.LKWidth = 100;// 强制宽度
    //grayRC.thumb.tintColor=[UIColor colorWithRed:52.0/255 green:52.0/255 blue:52.0/255 alpha:1];
    grayRC.thumb.tintColor=[UIColor whiteColor];
    grayRC.thumb.textColor=[UIColor colorWithRed:210.0/255 green:100.0/255 blue:85.0/255 alpha:1];
    grayRC.thumb.textShadowOffset=CGSizeMake(0, 0);
    //grayRC.thumb.backgroundColor=[UIColor whiteColor];
    //grayRC.thumb.backgroundColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
    grayRC.center = CGPointMake(160, 270);
    grayRC.tag = 3;
    grayRC.selectedIndex=1;
    segmentBar=[[UIBarButtonItem alloc] initWithCustomView:grayRC];
    self.navigationItem.leftBarButtonItem=segmentBar;

    segmentNum=1;
    flag=0;
   
    //=====================创建=========================================================
    UIButton* creatButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [creatButton setImage:[UIImage imageNamed:@"Pfound@2x.png"] forState:UIControlStateNormal];
    creatButton.frame=CGRectMake(0.0, 0.0, 50, 31);
    [creatButton addTarget:self action:@selector(CreateNewAct) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:creatButton];
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableViewParty=table;
    [table release];
    [self.view addSubview:self.tableViewParty];
    tableViewParty.backgroundView=nil;
    tableViewParty.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    self.tableViewParty.delegate=self;
    self.tableViewParty.dataSource=self;
    _slimeView=[[SRRefreshView alloc] init];
    _slimeView.delegate=self;
    _slimeView.upInset=10;
    [tableViewParty addSubview:_slimeView];
    [self requestDate];
    //==========================
}
//===========多线程==============================================
-(void)requestDate
{
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{//NSURL *urlString =[NSURL URLWithString:PICURL];
//                       NSData *content=[NSData dataWithContentsOfURL:urlString];
//                       UIImage *image=[UIImage imageWithData:content];
                       NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00001?uuid=%@",userUUid];
                       NSLog(@"接口1：：：：%@",stringUrl);
                       NSURL* url=[NSURL URLWithString:stringUrl];
                       ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
                       request.delegate = self;
                       request.shouldAttemptPersistentConnection = NO;
                       [request setValidatesSecureCertificate:NO];
                       [request setDefaultResponseEncoding:NSUTF8StringEncoding];
                       [request setDidFailSelector:@selector(requestDidFailed:)];
                       [request startAsynchronous];
                       //更新界面时用到
                       dispatch_async(dispatch_get_main_queue(), ^{
                           //[self.imageView setImage:image];
                       });
                   });
}

//=============经纬度代理方法=========================================
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    log.text=[NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
//    lat.text=[NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    lng=newLocation.coordinate.longitude;
    lat=newLocation.coordinate.latitude;
    NSLog(@"获取你的经纬度：：：：：：：：经度:%g      纬度:%g",lng,lat);
    
   

}
//==============获取用户的UUId===================================================
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
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedIndex);
    flag=0;
    if (segmentedControl.selectedIndex==0) {
        segmentNum=0;
        [self.tableViewParty reloadData];
        self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
       
        flag=0;
        locationMamager=[[CLLocationManager alloc]init];
        //设置委托
        locationMamager.delegate=self;
        //设置精度为最优
        locationMamager.desiredAccuracy=kCLLocationAccuracyBest;
        //设置距离筛选器
        locationMamager.distanceFilter=100.0f;
        locationMamager.headingFilter=0.1;
        //开始更新数据
        [locationMamager startUpdatingLocation];
        [locationMamager startUpdatingHeading];

        NSLog(@"经纬度输出：%f,%f",self.lat,self.lng);
        NSLog(@"用户uuid%@",self.userUUid);
        NSURL *url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00001"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lat] forKey:@"lat"];
        [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lng] forKey:@"lng"];
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
       
    }
    if (segmentedControl.selectedIndex==1) {
        self.tableViewParty.contentOffset=CGPointMake(0.0, 0.0);
        segmentNum=1;
        [self.tableViewParty reloadData];
        flag=0;
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00001?uuid=%@",userUUid];
        NSLog(@"接口1：：：：%@",stringUrl);
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
-(void)requestDidFailed:(ASIHTTPRequest *)request
{
    NSLog(@"wang luo bu gei li");
//    UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力，没有获取到数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [soundAlert show];
//    [soundAlert release];
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"dataFile.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSData *data=[stringmutable objectAtIndex:0];
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"111111111111111111111111111111%@",bizDic);
    NSArray* array=[bizDic objectForKey:@"partys"];
    
    total=[[bizDic objectForKey:@"total"]intValue];
    NSLog(@"本次返回的数量:%d",total);
    if (flag==0) {
        [sumArray removeAllObjects];
    }
    [sumArray addObjectsFromArray:array];
    [self.tableViewParty reloadData];

}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"dataFile.txt"];

    //NSLog(@"wosds%@",content);
    NSMutableArray *dataMutablearray=[NSMutableArray arrayWithObject:response];
    //NSLog(@"sadafdasfas%@",uuidMutablearray);
    [dataMutablearray writeToFile:fileName atomically:YES];
    
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"111111111111111111111111111111%@",bizDic);
    NSArray* array=[bizDic objectForKey:@"partys"];
    
    total=[[bizDic objectForKey:@"total"]intValue];
    NSLog(@"本次返回的数量:%d",total);
    if (flag==0) {
        [sumArray removeAllObjects];
    }
    [sumArray addObjectsFromArray:array];
    //NSLog(@"%@",[array objectAtIndex:0]);
    NSLog(@"总共的数量::::::%d",sumArray.count);
    [self.tableViewParty reloadData];
}

-(void)CreateNewAct
{
    NSLog(@"创建");
    creatPartyViewController=[[CreatPartyViewController alloc] initWithNibName:@"CreatPartyViewController" bundle:nil];
    creatPartyViewController.title=@"创建派对";
    creatPartyViewController.from_P_type=@"1";
    [self.navigationController pushViewController:creatPartyViewController animated:YES];
    
    //[self.tabBarController.view addSubview:creatPartyViewController.view];
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
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[self.sumArray count]-1) {
        return 160;
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PRframe@2x.png"]]autorelease];

    NSDictionary* dict=[self.sumArray objectAtIndex:section];
    //NSLog(@"%@",dict);
    NSString *stringType=[dict objectForKey:@"P_TYPE"];
    if (![[stringType substringToIndex:1] isEqualToString:@"1"]) {
        lable5.text=[dict objectForKey:@"P_LABLE"];
        imagePICView0.image=[UIImage imageNamed:@"PRTag@2x.png"];
        //NSLog(@"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq%@",cell.lable5.text);
    }
       
    lable7.text=[dict objectForKey:@"P_TITLE"];
    NSMutableString *mutableStringLocal=[[NSMutableString alloc] initWithFormat:@"%@",[dict objectForKey:@"P_LOCAL"]];
    lable2.text=mutableStringLocal;
    [mutableStringLocal release];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd  HH:mm"];
    NSInteger time=[[dict objectForKey:@"P_STIME"]integerValue];
    NSLog(@"%d",time);
    NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",date);
    NSString *confromTimespStr = [formatter stringFromDate:date];
    lable3.text=confromTimespStr;
    [formatter release];
    NSDictionary* user=[dict objectForKey:@"user"];
    lable4.text=[user objectForKey:@"USER_NICK"];
    
    //================创建者图片=============================================
    NSString* picurl=[user objectForKey:@"USER_PIC"];
    //NSLog(@"创建者图片网址:::%@",picurl);
    [imagePICView4 setImageWithURL:[NSURL URLWithString:picurl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    //[imagePICView4 setImageWithURL:[NSURL URLWithString:[user objectForKey:@"USER_PIC"]]];
    imagePICView4.layer.borderColor=[[UIColor whiteColor] CGColor];
    imagePICView4.layer.borderWidth=2;
    imagePICView4.layer.shadowOffset = CGSizeMake(2, 2);
    imagePICView4.layer.shadowOpacity = 0.5;
    imagePICView4.layer.shadowRadius = 2.0;
    //NSLog(@"输出照片%@",[user objectForKey:@"USER_PIC"]);
    
    NSString* string=[NSString stringWithFormat:@"%@",[dict objectForKey:@"usernum"]];
    //NSLog(@"%@",string);
    if ([[[user objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"M"]) {
        imagePICView5.image=[UIImage imageNamed:@"PRmale1@2x.png"];
        //NSLog(@"wwwwwwwwwwwwww%@",cell.imagePICView5.image);
    }
    if ([[[user objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"F"]) {
        imagePICView5.image=[UIImage imageNamed:@"PRfemale1@2x.png"];
    }
    NSMutableArray *mutableArray=[[NSMutableArray alloc]init];
    //===============联合创建人名字和照片======================================
    NSDictionary * mutableArrayDic=[dict objectForKey:@"users"];
    NSMutableString *stringNameAll=[[NSMutableString alloc]init];
    int i=0;
    for (NSDictionary *dic in mutableArrayDic) {
        NSString *stringNameUin=[dic objectForKey:@"USER_NICK"];
        [stringNameAll appendFormat:@"%@,",stringNameUin];
       
        if (i==0) {
            [imagePICView3 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            
            imagePICView3.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView3.layer.borderWidth=2;
            imagePICView3.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView3.layer.shadowOpacity = 0.5;
            imagePICView3.layer.shadowRadius = 2.0;
            
        }
        if (i==1) {
            [imagePICView2 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            
            imagePICView2.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView2.layer.borderWidth=2;
            imagePICView2.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView2.layer.shadowOpacity = 0.5;
            imagePICView2.layer.shadowRadius = 2.0;
            //NSLog(@"11111111111111%@",imagePICView2.image);

        }
        if (i==2) {
            [imagePICView1 setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            
            imagePICView1.layer.borderColor=[[UIColor whiteColor] CGColor];
            imagePICView1.layer.borderWidth=2;
            imagePICView1.layer.shadowOffset = CGSizeMake(2, 2);
            imagePICView1.layer.shadowOpacity = 0.5;
            imagePICView1.layer.shadowRadius = 2.0;
            
        }
        //NSLog(@"11111111111111%@",cell.imagePICView3.image);
        i++;
    }
    NSMutableString *mutableStringPerson=[[NSMutableString alloc] initWithFormat:@"%@",stringNameAll];
    lable1.text=mutableStringPerson;
    [mutableStringPerson release];
    [stringNameAll release];
    [mutableArray release];
    lable6.text=string;

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
    flag=1;
    NSLog(@"本次返回的数量:%d",total);
    if (total<mytotal) {
        //返回的结果已经是所有的了，不需要在加载
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"加载完毕" message:@"所有数据已经加载完毕" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        if (segmentNum==0) {
            //加载更多,附近
            NSURL *url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00001"];
            ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
            [rrequest setPostValue:self.userUUid forKey: @"uuid"];
            [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lat] forKey:@"lat"];
            [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lng] forKey:@"lng"];
            [rrequest setPostValue:[NSString stringWithFormat:@"%d",[self.sumArray count]+1]  forKey:@"from"];
            [rrequest setDelegate:self];
            [rrequest startAsynchronous];
        }
        else
        {
            //加载更多，所有
            [self getUUidForthis];
            NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00001?uuid=%@&&from=%d",userUUid,[self.sumArray count]+1];
            NSLog(@"加载更多:%@",stringUrl);
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    twoViewController=[[TwoViewController alloc]initWithNibName:@"TwoViewController" bundle:nil];
    NSDictionary* dict=[sumArray objectAtIndex:indexPath.section];
    
    twoViewController.title=[dict objectForKey:@"P_TITLE"];
    twoViewController.p_id=[dict objectForKey:@"P_ID"];
    NSLog(@"pidqqqqqqqqqqqqqqqqqqqqqqq%@",twoViewController.p_id);
    [self.navigationController pushViewController:twoViewController animated:YES];
    //
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//============下拉刷新代理方法======================================================
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    flag=0;
    //====================获取数据================================
    if (segmentNum==1) {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00001?uuid=%@",userUUid];
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
        
    }
    if (segmentNum==0) {
        NSURL *url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00001"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lat] forKey:@"lat"];
        [rrequest setPostValue:[NSString stringWithFormat:@"%f",self.lng] forKey:@"lng"];
        [rrequest setDelegate:self];
        [rrequest startAsynchronous];
        
    }
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:3
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [twoViewController release];
    [creatPartyViewController release];
    //[grayRC release];
    //[segmentBar release];
}
@end
