//
//  thirdViewController.m
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "thirdViewController.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
@implementation thirdViewController
@synthesize tableview;
@synthesize actsumarray;
@synthesize userUUid;
@synthesize addrarray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"事件";
        UIImage *selectedImage = [UIImage imageNamed:@"shijianzi@2x.png"];
        UIImage *unselectedImage = [UIImage imageNamed:@"ribbons@2x.png"];
        
        UITabBar *tabBar = self.tabBarController.tabBar;
        UITabBarItem *item1 = [tabBar.items objectAtIndex:2];
        [item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        //self.tabBarItem.image=[UIImage imageNamed:@"ribbons@2x.png"];
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
    //[self hideTabBar:NO];
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    total=0;
    // Do any additional setup after loading the view from its nib.
    [self getUUidForthis];
    segment=0;
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
   
    [self.view addSubview:self.tableview];
    NSMutableArray* list=[[NSMutableArray alloc]init];
    self.actsumarray=list;
    [list release];
    NSMutableArray* addrlist=[[NSMutableArray alloc]init];
    self.addrarray=addrlist;
    [addrlist release];
    [table release];

    
    //===================活动和地点选择按钮==============================================
    grayRC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"活动",@"地点", nil]];
    [grayRC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
	grayRC.textColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
    grayRC.textShadowOffset=CGSizeMake(0, 0);
	grayRC.font = [UIFont boldSystemFontOfSize:12];
	grayRC.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    grayRC.backgroundImage=[UIImage imageNamed:@"segment@2x.png"];
	grayRC.height = 30;// 强制高度  一般可以用于全是图片的选项
    grayRC.thumb.tintColor=[UIColor whiteColor];
    grayRC.thumb.textColor=[UIColor colorWithRed:210.0/255 green:100.0/255 blue:85.0/255 alpha:1];
    grayRC.thumb.textShadowOffset=CGSizeMake(0, 0);
    grayRC.selectedIndex=0;
    segment=0;
    flag=0;
    //接口IF00028
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00028?uuid=%@",userUUid];
    NSLog(@"获取活动列表,接口28:%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];

    UIBarButtonItem *segmentBar=[[UIBarButtonItem alloc] initWithCustomView:grayRC];
    self.navigationItem.leftBarButtonItem=segmentBar;
    grayRC.center = CGPointMake(160, 270);
    grayRC.tag = 3;
    [segmentBar release];
    [grayRC release];
    //==========================刷新===============================
    _slimeView=[[SRRefreshView alloc] init];
    _slimeView.delegate=self;
    _slimeView.upInset=20;
    [tableview addSubview:_slimeView];
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
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"接口28、29共用一个页面，根据segment判断是哪一个页面:segment:%d",segment );
    NSLog(@"%@",bizDic);
    total=[[bizDic objectForKey:@"total"]intValue];
    //选择的是活动列表，segment=0
    if (segment==0) {
            if (flag==0) {
                [self.actsumarray removeAllObjects];
        }
        [self.actsumarray addObjectsFromArray:[bizDic objectForKey:@"collects"]];
        NSLog(@"%@",self.actsumarray);
        }
    //选择的是地点列表，segment=1
    else
    {
        if (flag==0) {
            [self.addrarray removeAllObjects];
        }

        [self.addrarray addObjectsFromArray:[bizDic objectForKey:@"collects"]];
        NSLog(@"%@",self.addrarray);
    }
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
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
     [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedIndex);
    flag=0;
    self.tableview.contentOffset=CGPointMake(0.0, 0.0);
    if (segmentedControl.selectedIndex==1) {
        segment=1;
        flag=0;
        [self.tableview reloadData];
        
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00029?uuid=%@",userUUid];
        NSLog(@"获取热门地点列表,接口29:%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
        
    }
    if (segmentedControl.selectedIndex==0) {
        segment=0;
        [self.tableview reloadData];
        flag=0;
        //接口IF00028
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00028?uuid=%@",userUUid];
        NSLog(@"获取活动列表,接口28:%@",stringUrl);
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment==0){
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell){
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
       }
        for (UIView *views in cell.contentView.subviews)
       {
           [views removeFromSuperview];
       }
    
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huodongkuang@2x.png"]]autorelease];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UITextView* addr;
        UITextView* time;
        UILabel* title;
        UILabel* host;
        UIImageView* imageview;
        UILabel* fnum;
        UILabel* pnum;
        UILabel* label;
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 134, 192)];
        [cell.contentView addSubview:imageview];
        [imageview release];
        UIImageView* labelpic=[[UIImageView alloc]initWithFrame:CGRectMake(14, -4, 40, 27)];
        labelpic.image=[UIImage imageNamed:@"Tag@2x.png"];
        [cell.contentView addSubview:labelpic];
        [labelpic release];
        UIImageView* hostImage=[[UIImageView alloc]initWithFrame:CGRectMake(156, 58, 10, 10)];
        hostImage.image=[UIImage imageNamed:@"AOuser@2x.png"];
        [cell.contentView addSubview:hostImage];
        UILabel* hostLabel=[[UILabel alloc]initWithFrame:CGRectMake(172, 53, 68, 21)];
        hostLabel.font=[UIFont systemFontOfSize:14.0];
        hostLabel.textColor=[UIColor lightGrayColor];
        hostLabel.backgroundColor=[UIColor clearColor];
        hostLabel.text=@"主办方:";
        [cell.contentView addSubview:hostLabel];
        [hostLabel release];
        UILabel* addrLabel=[[UILabel alloc]initWithFrame:CGRectMake(172, 84, 64, 20)];
        addrLabel.backgroundColor=[UIColor clearColor];
        addrLabel.text=@"地点:";
        addrLabel.font=[UIFont systemFontOfSize:14.0];
        addrLabel.textColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:addrLabel];
        [addrLabel release];
        UILabel* timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(172, 117    , 65, 21)];
        timeLabel.textColor=[UIColor lightGrayColor];
        timeLabel.font=[UIFont systemFontOfSize:14.0];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.text=@"时间:";
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
        UILabel* pnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 178, 40, 21)];
        pnumLabel.text=@"人数:";
        pnumLabel.font=[UIFont systemFontOfSize:12.0];
        pnumLabel.backgroundColor=[UIColor clearColor];
        pnumLabel.textColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:pnumLabel];
        [pnumLabel release];
        UILabel* fnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(238, 178, 42, 21)];
        fnumLabel.backgroundColor=[UIColor clearColor];
        fnumLabel.textColor=[UIColor lightGrayColor];
        fnumLabel.font=[UIFont systemFontOfSize:12.0];
        fnumLabel.text=@"派对:";
        [cell.contentView addSubview:fnumLabel];
        [fnumLabel release];
        UIImageView* addrImage=[[UIImageView alloc]initWithFrame:CGRectMake(156, 88, 10, 12)];
        addrImage.image=[UIImage imageNamed:@"AOlocation@2x.png"];
        [cell.contentView addSubview:addrImage];
        UIImageView* timeImage=[[UIImageView alloc]initWithFrame:CGRectMake(156, 123, 10, 10)];
        timeImage.image=[UIImage imageNamed:@"AOtime@2x.png"];
        [cell.contentView addSubview:timeImage];
        [hostImage release];
        [addrImage release];
        [timeImage release];
        label=[[UILabel alloc]initWithFrame:CGRectMake(14, -13, 40, 37)];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:10.0];
        label.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:label];
        [label release];

        fnum=[[UILabel alloc]initWithFrame:CGRectMake(190, 177, 50, 21)];
        fnum.backgroundColor=[UIColor clearColor];
        fnum.font=[UIFont systemFontOfSize:17.0];
        fnum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        [cell.contentView addSubview:fnum];
        [fnum release];
        pnum=[[UILabel alloc]initWithFrame:CGRectMake(268, 177, 51, 21)];
        pnum.font=[UIFont systemFontOfSize:17.0];
        pnum.backgroundColor=[UIColor clearColor];
        pnum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        [cell.contentView addSubview:pnum];
        [pnum release];
        addr=[[UITextView alloc]initWithFrame:CGRectMake(201, 78, 100, 48)];
        addr.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        addr.font=[UIFont systemFontOfSize:14.0];
        addr.backgroundColor=[UIColor clearColor];
        addr.userInteractionEnabled=NO;
        addr.multipleTouchEnabled=NO;
        
        [cell.contentView addSubview:addr];
        [addr release];
        time=[[UITextView alloc]initWithFrame:CGRectMake(201, 112, 100, 60)];
        time.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        time.backgroundColor=[UIColor clearColor];
        time.font=[UIFont systemFontOfSize:14.0];
        time.multipleTouchEnabled=NO;
        time.userInteractionEnabled=NO;
        [cell.contentView addSubview:time];
        [time release];
        host=[[UILabel alloc]initWithFrame:CGRectMake(219, 53, 80, 21)];
        host.backgroundColor=[UIColor clearColor];
        host.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        host.font=[UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:host];
        [host release];        title=[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 144, 34)];
        title.textAlignment=NSTextAlignmentCenter;
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
        title.font=[UIFont systemFontOfSize:14.0];
        title.shadowColor=[UIColor colorWithRed:198.0/255 green:198.0/255 blue:198.0/255 alpha:1];
        title.shadowOffset=CGSizeMake(1.0, 1.0);
        [cell.contentView addSubview:title];
        [title release];
        
        
    NSDictionary* dict=[self.actsumarray objectAtIndex:indexPath.section];
    NSLog(@"%@",dict);
    pnum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_PNUM"]];
    title.text=[dict objectForKey:@"C_TITLE"];
    label.text=[dict objectForKey:@"C_LABEL"];
    host.text=[dict objectForKey:@"C_HOST"];
    addr.text=[dict objectForKey:@"C_LOCAL"];
    
    NSURL* url=[NSURL URLWithString:[dict objectForKey:@"C_PIC"]];
    
    //cell.imageview.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [imageview setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    time.text=[dict objectForKey:@"C_STIME"];
    fnum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_FNUM"]];
    return cell;

}
    else
    {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Lview@2x.png"]]autorelease];
        UIImageView* imageview;
        UILabel* addrlabel;
        UILabel* peoplenum;
        UILabel* partynum;
        UILabel* title;
        UILabel* label;
        UIImageView* addrImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 190, 10, 12)];
        addrImage.image=[UIImage imageNamed:@"AOlocation@2x.png"];
        [cell.contentView addSubview:addrImage];
        [addrImage release];
        UILabel* Location=[[UILabel alloc]initWithFrame:CGRectMake(38, 187, 45, 21)];
        Location.font=[UIFont systemFontOfSize:14.0];
        Location.textColor=[UIColor lightGrayColor];
        Location.backgroundColor=[UIColor clearColor];
        Location.text=@"地点:";
        [cell.contentView addSubview:Location];
        [Location release];
        addrlabel=[[UILabel alloc]initWithFrame:CGRectMake(78, 187, 247, 21)];
        addrlabel.backgroundColor=[UIColor clearColor];
        addrlabel.font=[UIFont systemFontOfSize:14.0];
        addrlabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:99.0/255];
        [cell.contentView addSubview:addrlabel];
        [addrlabel release];
        peoplenum=[[UILabel alloc]initWithFrame:CGRectMake(191, 214, 50, 21)];
        peoplenum.backgroundColor=[UIColor clearColor];
        peoplenum.font=[UIFont systemFontOfSize:17.0];
        peoplenum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        [cell.contentView addSubview:peoplenum];
        [peoplenum release];
        partynum=[[UILabel alloc]initWithFrame:CGRectMake(268, 214, 44, 21)];
        partynum.font=[UIFont systemFontOfSize:17.0];
        partynum.backgroundColor=[UIColor clearColor];
        partynum.textColor=[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1];
        [cell.contentView addSubview:partynum];
        [partynum release];

        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(11, 6, 279, 174)];
        
        [cell.contentView addSubview:imageview];
        [imageview release];
        UIImageView* shadeImage=[[UIImageView alloc]initWithFrame:CGRectMake(11, 152, 279, 28)];
        shadeImage.image=[UIImage imageNamed:@"shade@2x.png"];
        [cell.contentView addSubview:shadeImage];
        [shadeImage release];
        title=[[UILabel alloc]initWithFrame:CGRectMake(20, 148, 222, 35)];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor whiteColor];
        title.shadowColor=[UIColor darkGrayColor];
        title.shadowOffset=CGSizeMake(1, 1);
        title.font=[UIFont systemFontOfSize:17.0];
        [cell.contentView addSubview:title];
        [title release];
        UIImageView* labelpic=[[UIImageView alloc]initWithFrame:CGRectMake(242, -4, 40, 27)];
        labelpic.image=[UIImage imageNamed:@"Tag@2x.png"];
        [cell.contentView addSubview:labelpic];
        [labelpic release];
        label=[[UILabel alloc]initWithFrame:CGRectMake(242, -13, 40, 37)];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:10.0];
        label.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label release];
        UILabel* pnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(156, 215, 42, 21)];
        pnumLabel.text=@"人数:";
        pnumLabel.font=[UIFont systemFontOfSize:12.0];
        pnumLabel.backgroundColor=[UIColor clearColor];
        pnumLabel.textColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:pnumLabel];
        [pnumLabel release];
        UILabel* fnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(239, 215, 42, 21)];
        fnumLabel.backgroundColor=[UIColor clearColor];
        fnumLabel.textColor=[UIColor lightGrayColor];
        fnumLabel.font=[UIFont systemFontOfSize:12.0];
        fnumLabel.text=@"派对:";
        [cell.contentView addSubview:fnumLabel];
        [fnumLabel release];
        NSDictionary* dict=[self.addrarray objectAtIndex:indexPath.section];
        NSURL* url=[NSURL URLWithString:[dict objectForKey:@"C_PIC"]];
        [imageview setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
        title.text=[dict objectForKey:@"C_TITLE"];
        partynum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_PNUM"]];
        peoplenum.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"C_FNUM"]];
        addrlabel.text=[dict objectForKey:@"C_LOCAL"];
        label.text=[dict objectForKey:@"C_LABEL"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment==0) {
    NSDictionary* dict=[self.actsumarray objectAtIndex:indexPath.section];
    detail=[[DetailViewController alloc]init];
    detail.C_id=[dict objectForKey:@"C_ID"];
    [self.navigationController pushViewController:detail animated:YES];
    
    }
    else
    {
        NSDictionary* dict=[self.addrarray objectAtIndex:indexPath.section];
        addrdetail=[[AddrDetailViewController alloc]init];
        addrdetail.C_id=[dict objectForKey:@"C_ID"];
        [self.navigationController pushViewController:addrdetail animated:YES];

    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment==0) {
        return 212;
    }
    else
        return 255;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (segment==0) {
        if (section==self.actsumarray.count-1) {
            return 160;
        }
    }
    if (segment==1) {
        if (section==self.addrarray.count-1) {
            return 160;
        }
    }
    return 3;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view=[tableView dequeueReusableCellWithIdentifier:@"header"];
    if (!view) {
        view=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)]autorelease];
        //view.backgroundColor=[UIColor redColor];
    }
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (segment==0) {
        if (section==[self.actsumarray count]-1) {
            UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
            footerview.backgroundColor=[UIColor clearColor];
            UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            morebutton.frame=CGRectMake(57, 20, 206, 32);
            [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
            [morebutton addTarget:self action:@selector(ACTclickmore) forControlEvents:UIControlEventTouchDown];
            [footerview addSubview:morebutton];
            return footerview;
            
        }
    }
    if (segment==1) {
        if (section==[self.addrarray count]-1) {
            UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
            footerview.backgroundColor=[UIColor clearColor];
            UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            morebutton.frame=CGRectMake(57, 20, 206, 32);
            [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
            [morebutton addTarget:self action:@selector(ACTclickmore) forControlEvents:UIControlEventTouchDown];
            [footerview addSubview:morebutton];
            return footerview;
        }
    }
    return nil;
}


//活动列表加载更多
-(void)ACTclickmore
{
    //接口28，需要from and to
    flag=1;
    if (total<mytotal) {
        NSLog(@"已经是全部");
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"加载完毕" message:@"所有数据已经加载完毕" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00028?uuid=%@&&from=%d",userUUid,[self.actsumarray count]+1];
        NSLog(@"获取活动列表,接口28:%@",stringUrl);
        NSLog(@"加载更多:");
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }

    
}

//地点列表加载更多
-(void)ADDRclickmore
{
    flag=1;
    if (total<mytotal) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"加载完毕" message:@"所有数据已经加载完毕" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];

    }
    else
    {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00029?uuid=%@&&from=%d",userUUid,[self.addrarray count]+1];
        NSLog(@"获取地点列表,接口29:%@",stringUrl);
        NSLog(@"加载更多:");
        NSURL* url=[NSURL URLWithString:stringUrl];
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 3;
    if (segment==0) {
        return [self.actsumarray count];
    }
    else
    {
        return [self.addrarray count];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (segment==0) {
        return 7;
    }
    else
    {
        return 1.0f;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    //====================获取数据================================
    if (segment==1) {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00029?uuid=%@",userUUid];
        NSLog(@"接口29网址:::%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    if (segment==0) {
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00028?uuid=%@",userUUid];
        NSLog(@"获取活动列表,接口28:%@",stringUrl);
        NSURL* url=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
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

- (void)dealloc
{
    [tableview release];
    [actsumarray release];
    [addrdetail release];
    [detail release];
    [super dealloc];
    
}
@end
