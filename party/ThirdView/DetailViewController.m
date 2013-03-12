//
//  DetailViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-18.
//
//

#import "DetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

static NSString* P_type=@"activity";

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize dict;
@synthesize tableview;
@synthesize C_id;
@synthesize C_title;
@synthesize userUUid;

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
    [self getUUidForthis];
    [self hideTabBar:YES];
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
    [super viewWillDisappear:animated];
}
-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"活动详细信息:self.c_id=%@",self.C_id);
    NSData* response=[request responseData];
    //NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //NSLog(@"%@",bizDic);
    NSArray* array=[bizDic objectForKey:@"activity"];
    if ([array count]>0) {
        [self.dict setDictionary:nil];
        [self.dict addEntriesFromDictionary:[array objectAtIndex:0]];
    }
    NSLog(@"接口四::::%@",self.dict);
    self.C_title=[dict objectForKey:@"C_TITLE"];
    NSLog(@"C_title:%@",self.C_title);
    NSString* joinorno=[self.dict objectForKey:@"C_STATUS"];
    NSLog(@"判断是否已经加入活动%@",joinorno);
    
    if ([[joinorno substringToIndex:1] isEqualToString:@"Y"])
    {
        [joinParty setImage:[UIImage imageNamed:@"quit@2x.png"] forState:UIControlStateNormal];
        joinParty.tag=002;
    }
    else
    {
        [joinParty setImage:[UIImage imageNamed:@"join@2x.png"] forState:UIControlStateNormal];
        joinParty.tag=001;
    }
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(158, mainscreenhight-94, 2, 30)];
    imageView.image=[UIImage imageNamed:@"CutOffRule.png"];
    
    [self.view addSubview:imageView];
    
    [self tableviewreload];
    [imageView release];
    
}

-(void)tableviewreload
{
    [tableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    dict=[[NSMutableDictionary alloc]init];
    changePicview=[[UIImageView alloc]init];
	// Do any additional setup after loading the view.
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00004?uuid=%@&&c_id=%@",userUUid,self.C_id];
    NSLog(@"活动信息网址%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    self.title=@"活动信息";
    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 131, 190)];
    Actitle=[[UILabel alloc]initWithFrame:CGRectMake(140, 65, 160, 16)];
    Actitle.text=@"迷笛音乐节";
    Actitle.backgroundColor=[UIColor clearColor];
    Actitle.font=[UIFont systemFontOfSize:16];
    Actitle.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
    Actitle.shadowColor=[UIColor colorWithRed:198.0/255 green:198.0/255 blue:198.0/255 alpha:1];
    Actitle.shadowOffset=CGSizeMake(1.0, 1.0);
    
    
    Achost=[[UILabel alloc]initWithFrame:CGRectMake(192, 95, 120, 20)];
    Achost.text=@"****音乐学院";
    Achost.backgroundColor=[UIColor clearColor];
    Achost.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    Achost.font=[UIFont systemFontOfSize:14];
    
    Acaddr=[[UITextView alloc]initWithFrame:CGRectMake(185, 111,100, 60)];
    Acaddr.text=@"anzhen";
    Acaddr.font=[UIFont systemFontOfSize:14];
    Acaddr.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
    Acaddr.backgroundColor=[UIColor clearColor];
    Acaddr.userInteractionEnabled=NO;
    Acaddr.multipleTouchEnabled=NO;
    
    Aclabel=[[UILabel alloc]initWithFrame:CGRectMake(256, -14, 40, 37)];
    Aclabel.text=@"大趴";
    Aclabel.font=[UIFont systemFontOfSize:10];
    Aclabel.backgroundColor=[UIColor clearColor];
    Aclabel.textColor=[UIColor whiteColor];
    Aclabel.textAlignment=NSTextAlignmentCenter;
    
    tableview =[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self.view addSubview:tableview];
    
    //================加入/退出活动按钮======================
    joinParty = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    NSString* joinorno=[self.dict objectForKey:@"C_STATUS"];
    NSLog(@"判断是否已经加入活动%@",joinorno);
    
    if ([[joinorno substringToIndex:1] isEqualToString:@"Y"])
    {
        [joinParty setImage:[UIImage imageNamed:@"quit@2x.png"] forState:UIControlStateNormal];
        joinParty.tag=002;
    }
    else
    {
        [joinParty setImage:[UIImage imageNamed:@"join@2x.png"] forState:UIControlStateNormal];
        joinParty.tag=001;
    }
    [joinParty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [joinParty setFrame:CGRectMake(0,mainscreenhight-105, 160, 44)];
    [self.view addSubview:joinParty];

    //====================创建party按钮=====================
    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    [join setImage:[UIImage imageNamed:@"found@2x.png"] forState:UIControlStateNormal];
    [join addTarget:self action:@selector(buttonClickTwo:) forControlEvents:UIControlEventTouchUpInside];
    [join setFrame:CGRectMake(160,mainscreenhight-105, 160, 44)];
    [self.view addSubview:join];
    
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
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==001) {
        NSLog(@"加入活动，需要上传,接口IF00026");
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/party/IF00026"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.C_id forKey:@"c_id"];
        [rrequest startSynchronous];
        btn.tag=002;
        [btn setImage:[UIImage imageNamed:@"quit@2x.png"] forState:UIControlStateNormal];
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00004?uuid=%@&&c_id=%@",userUUid,self.C_id];
        NSLog(@"活动信息网址%@",stringUrl);
        NSURL* reurl=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:reurl];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    else
    {   NSLog(@"退出已加入的活动，需要上传数据，接口IF00027");
        NSString* url27=@"http://www.ycombo.com/che/mac/party/IF00027";
        NSURL* url=[NSURL URLWithString:url27];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:userUUid forKey: @"uuid"];
        [rrequest setPostValue:self.C_id forKey:@"c_id"];
        [rrequest startSynchronous];
        btn.tag=001;
        [btn setImage:[UIImage imageNamed:@"join@2x.png"] forState:UIControlStateNormal];
        NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/party/IF00004?uuid=%@&&c_id=%@",userUUid,self.C_id];
        NSLog(@"活动信息网址%@",stringUrl);
        NSURL* reurl=[NSURL URLWithString:stringUrl];
        
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:reurl];
        request.delegate = self;
        request.shouldAttemptPersistentConnection = NO;
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setDidFailSelector:@selector(requestDidFailed:)];
        [request startAsynchronous];
    }
    
}

-(void)buttonClickTwo:(UIButton *)btB
{
    btB.selected=!btB.selected;
    //*******************************创建 party********************************
    
    NSLog(@"C_title:%@",self.C_title);
    NSLog(@"C_id:%@",self.C_id);
    NSLog(@"P_type:%@",P_type);
    creatParty=[[CreatPartyViewController alloc]init];
    creatParty.title=@"创建party";
    creatParty.from_P_type=@"2";
    creatParty.from_C_title=self.C_title;
    creatParty.from_C_id=self.C_id;
    [self.navigationController pushViewController:creatParty animated:YES];
    //*******************************创建 party end********************************
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=[indexPath section];
    
    if (section==0) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"]autorelease];
        }
        
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOview@2x.png"]]autorelease];
        UIImageView* labelimage=[[UIImageView alloc]initWithFrame:CGRectMake(256, -6, 40, 27)];
        labelimage.image=[UIImage imageNamed:@"AOTag@2x.png"];
        [cell.contentView addSubview:labelimage];
        [labelimage release];
        UIImageView* hostimage=[[UIImageView alloc]initWithFrame:CGRectMake(145, 100, 10, 10)];
        hostimage.image=[UIImage imageNamed:@"AOuser@2x.png"];
        [cell.contentView addSubview:hostimage];
        [hostimage release];
        UILabel* hostl=[[UILabel alloc]initWithFrame:CGRectMake(160, 98 ,100, 15)];
        hostl.text=@"主办:";
        hostl.backgroundColor=[UIColor clearColor];
        hostl.font=[UIFont systemFontOfSize:14];
        hostl.textColor=[UIColor lightGrayColor];
        
        [cell.contentView addSubview:hostl];
        [hostl release];
        UIImageView* addrimage=[[UIImageView alloc]initWithFrame:CGRectMake(145, 122, 10, 12)];
        addrimage.image=[UIImage imageNamed:@"AOlocation@2x.png"];
        [cell.contentView addSubview:addrimage];
        [addrimage release];
        UILabel* addrl=[[UILabel alloc]initWithFrame:CGRectMake(160, 115, 100, 25)];
        
        addrl.text=@"地点:";
        addrl.textColor=[UIColor lightGrayColor];
        addrl.backgroundColor=[UIColor clearColor];
        addrl.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:addrl];
        [addrl release];
        [cell.contentView addSubview:imageview];
        [cell.contentView addSubview:Actitle];
        [cell.contentView addSubview:Achost];
        [cell.contentView addSubview:Acaddr];
        [cell.contentView addSubview:Aclabel];
        
        Acaddr.text=[dict objectForKey:@"C_LOCAL"];
        Actitle.text=[dict objectForKey:@"C_TITLE"];
        Achost.text=[dict objectForKey:@"C_HOST"];
        Aclabel.text=[dict objectForKey:@"C_LABEL"];
        NSURL* url=[NSURL URLWithString:[dict objectForKey:@"C_PIC"]];
        [imageview setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"huodong@2x.png"]];
        imageview.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageview addGestureRecognizer:singleTap];
        [singleTap release];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (section==1) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOmessage@2x.png"]]autorelease];
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 8, 10)];
        takeimage.image=[UIImage imageNamed:@"AOgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];
        UIImageView* acimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, -7, 14, 19)];
        acimage.image=[UIImage imageNamed:@"AOballoon@2x.png"];
        [cell.contentView addSubview:acimage];
        [acimage release];
        
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.text=[NSString stringWithFormat:@"   活动中的派对(%@)",[dict objectForKey:@"C_PNUM"]];
        cell.textLabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.text=@"参与派对      ";
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor=[UIColor lightGrayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (section==2) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        if (indexPath.row==0) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOmessage2one@2x.png"]]autorelease];
            cell.textLabel.text=[NSString stringWithFormat:@"活动中的玩伴(%@)",[dict objectForKey:@"C_FNUM"]];
            cell.textLabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.detailTextLabel.text=@"查看好友      ";
            cell.detailTextLabel.backgroundColor=[UIColor clearColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 8, 10)];
            takeimage.image=[UIImage imageNamed:@"AOgo@2x.png"];
            [cell.contentView addSubview:takeimage];
            [takeimage release];
            
        }
        if (indexPath.row==1) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOmessage2two@2x.png"]]autorelease];
            image1=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 33, 33)];
            
            image2=[[UIImageView alloc]initWithFrame:CGRectMake(44, 4, 33, 33)];
            
            image3=[[UIImageView alloc]initWithFrame:CGRectMake(84, 4, 33, 33)];
          
            image4=[[UIImageView alloc]initWithFrame:CGRectMake(124, 4, 33, 33)];
           
            image5=[[UIImageView alloc]initWithFrame:CGRectMake(164, 4, 33, 33)];
          
            image6=[[UIImageView alloc]initWithFrame:CGRectMake(204, 4, 33, 33)];
            
            image7=[[UIImageView alloc]initWithFrame:CGRectMake(244, 4, 33, 33)];
            image1.tag=1001;
            image2.tag=1002;
            image3.tag=1003;
            image4.tag=1004;
            image5.tag=1005;
            image6.tag=1006;
            image7.tag=1007;
            
            [cell.contentView addSubview:image1];
            [cell.contentView addSubview:image2];
            [cell.contentView addSubview:image3];
            [cell.contentView addSubview:image4];
            [cell.contentView addSubview:image5];
            [cell.contentView addSubview:image6];
            [cell.contentView addSubview:image7];
            [image1 release];
            [image2 release];
            [image3 release];
            [image4 release];
            [image5 release];
            [image6 release];
            [image7 release];
            //结构有问题
            NSArray* picarray=[dict objectForKey:@"c_fpics"];
            int num=[picarray count];
            for (int a=1; a<=num; a++) {
                NSLog(@"%d",a);
                NSDictionary* imagedic=[picarray objectAtIndex:a-1];
                NSString* urlstr=[imagedic objectForKey:@"C_FPIC"];
                NSLog(@"%@",urlstr);
                NSURL* url=[NSURL URLWithString:urlstr];
                int flag=1000+a;
                UIImageView* currimage=(UIImageView*)[cell viewWithTag:flag];
                [currimage setImageWithURL: url refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            }
        }
        return cell;
    }
    else {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOInformation1@2x.png"]]autorelease];
            UIImageView *labelimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOnews@2x.png"]];
            labelimage.frame=CGRectMake(15, 12, 8, 10);
            [cell.contentView addSubview:labelimage];
            [labelimage release];
            UILabel* infolabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 9, 200, 15)];
            infolabel.text=@"活动介绍:";
            infolabel.font=[UIFont systemFontOfSize:14];
            infolabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            infolabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:infolabel];
            [infolabel release];
        }
        if (indexPath.row==1) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOInformation2@2x.png"]]autorelease];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 0;
            label.font=[UIFont systemFontOfSize:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            [cell.contentView addSubview:label];
            [label release];

            CGRect cellFrame = CGRectMake(12, 10.0, 280, 30);
            label.text=[dict objectForKey:@"C_INFO"];
            CGRect rect = cellFrame;
            label.frame = rect;
            [label sizeToFit];
            cellFrame.size.height = label.frame.size.height+10;
            [cell setFrame:cellFrame];   
        }
        if (indexPath.row==2) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AOInformation3@2x.png"]]autorelease];
        }
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3) {
        return 120;
    }
    if (section==0) {
        return 10;
    }
    else
        return 2.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=[indexPath section];
    if (section==0) {
        return 203;
    }
    if (section==1) {
        return 28;
    }
    if ((section==2)&&(indexPath.row==0)) {
        return 28;
    }
    if ((section==2)&&(indexPath.row==1)) {
        return 42;
        
    }
    if (section==3) {
        if (indexPath.row==0) {
            return 25;
        }
        if (indexPath.row==1) {
            UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
    }

    return 15;

}


//第一个分组需要有阴影
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        UIImageView* shadowview=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AoViewShadow@2x.png"]]autorelease];
        shadowview.backgroundColor=[UIColor clearColor];
        shadowview.frame=CGRectMake(5, 0, 310, 11);
        return shadowview;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 2;
    }
    if (section==3) {
        return 3;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        actParty=[[AciPartyViewController alloc]init];
        actParty.stringNamePID=self.C_id;
        actParty.P_label=[dict objectForKey:@"C_LABEL"];
        [self.navigationController pushViewController:actParty animated:YES];
        
        
    }
    if ((indexPath.section==2)&&(indexPath.row==0)) {
        friends=[[CollectfriendViewController alloc]init];
        friends.C_id=self.C_id;
        [self.navigationController pushViewController:friends animated:YES];
        
    }
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    changePicview.image=imageview.image;
    changePicview.frame=self.view.bounds;
    [self.view addSubview:changePicview];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapRe:)];
    [changePicview addGestureRecognizer:singleTap];
    [singleTap release];
    
}
- (void)handleSingleTapRe:(UIGestureRecognizer *)gestureRecognizer
{
    self.navigationController.navigationBarHidden=NO;
    [changePicview removeFromSuperview];
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
    [actParty release];
    [friends release];
    [creatParty release];
}

@end
