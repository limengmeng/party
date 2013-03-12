//
//  MakefriendViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-29.
//
//

#import "MakefriendViewController.h"
#import "ASIFormDataRequest.h"
#import "SDImageView+SDWebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface MakefriendViewController ()

@end

@implementation MakefriendViewController
@synthesize delegate;
@synthesize picimage;
@synthesize user_id;
@synthesize userUUid;
@synthesize dict;

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    [self getUUidForthis];
    [super viewWillDisappear:animated];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:YES];
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"FMBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=back;
    [back release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self getUUidForthis];
    changePicview=[[UIImageView alloc]init];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self.view addSubview:tableview];
    NSString* urlstr=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00003?uuid=%@&&user_id=%@",self.userUUid,self.user_id];
    NSLog(@"请求接口的网址:%@",urlstr);
    
    NSURL* url=[NSURL URLWithString:urlstr];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];

}

-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* response=[request responseData];
    NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",bizDic);
    self.dict=bizDic;
    [tableview reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"::::::%@",self.dict);
    if (indexPath.section!=2) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Fbackview@2x.png"]]autorelease];
        if (indexPath.section==0) {
            picimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, -18, 45, 45)];
            
            picimage.layer.borderColor=[[UIColor whiteColor] CGColor];
            picimage.layer.borderWidth=2;
            picimage.layer.shadowOffset = CGSizeMake(2, 2);
            picimage.layer.shadowOpacity = 0.5;
            picimage.layer.shadowRadius = 2.0;
            
            [picimage setImageWithURL:[NSURL URLWithString:[self.dict objectForKey:@"USER_PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
            picimage.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [picimage addGestureRecognizer:singleTap];
            [singleTap release];

            UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 7, 80, 20)];
            namelabel.backgroundColor=[UIColor clearColor];
            namelabel.text=[self.dict objectForKey:@"USER_NICK"];
            namelabel.font=[UIFont systemFontOfSize:14];
            namelabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 11, 13)];
            NSString* sexstr=[self.dict objectForKey:@"USER_SEX"];
            NSLog(@"性别:%@",sexstr);
            if ([[sexstr substringToIndex:1] isEqualToString:@"M"]) {
                seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
            }
            else
            {
                seximage.image=[UIImage imageNamed:@"PRfemale1.png"];
            }
            [cell.contentView addSubview:picimage];
            [cell.contentView addSubview:namelabel];
            [cell.contentView addSubview:seximage];
            [namelabel release];
            [seximage release];
            
        }
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                cell.textLabel.text=@"年龄 ";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.textLabel.textColor=[UIColor lightGrayColor];
                cell.textLabel.font=[UIFont systemFontOfSize:14];
                UILabel* agelabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 8, 50, 20)];
                agelabel.font=[UIFont systemFontOfSize:14];
                agelabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
                agelabel.backgroundColor=[UIColor clearColor];
                agelabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"USER_AGE"]];
                
                [cell.contentView addSubview:agelabel];
                [agelabel release];
            }
            if (indexPath.row==1) {
                cell.textLabel.text=@"地区 ";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.textLabel.textColor=[UIColor lightGrayColor];
                cell.textLabel.font=[UIFont systemFontOfSize:14];
                cell.textLabel.backgroundColor=[UIColor clearColor];
                UILabel* locallabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 8, 150, 20)];
                locallabel.font=[UIFont systemFontOfSize:14];
                locallabel.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
                locallabel.backgroundColor=[UIColor clearColor];
                if (([[dict objectForKey:@"USER_CITY"] isEqualToString:@"(null)"])||([[dict objectForKey:@"USERE_LOCAL"] isEqualToString:@"(null)"])) {
                    locallabel.text=@"";
                }
                else
                {
                    locallabel.text=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"USER_CITY"],[dict objectForKey:@"USER_LOCAL"]];
                }

                [cell.contentView addSubview:locallabel];
                [locallabel release];
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"]autorelease];
        }
        for (UIView *views in cell.contentView.subviews)
        {
            [views removeFromSuperview];
        }
        if (indexPath.row==0) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FInformation1@2x.png"]]autorelease];
            cell.textLabel.text=@"个人简介";
            cell.textLabel.textColor=[UIColor lightGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            
        }
        else
        {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Fbackview2@2x.png"]]autorelease];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 0;
            label.font=[UIFont systemFontOfSize:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
            [cell.contentView addSubview:label];
            [label release];
            
            CGRect cellFrame = CGRectMake(12, 10.0, 280, 30);
            label.text=[dict objectForKey:@"USER_DES"];
            CGRect rect = cellFrame;
            label.frame = rect;
            [label sizeToFit];
            cellFrame.size.height = label.frame.size.height+20;
            [cell setFrame:cellFrame];
        }
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        if (![[[dict objectForKey:@"USER_STATUS"]substringToIndex:1]isEqualToString:@"Y"])
        {
            UIView* footview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(20, 20, 280, 40);

            [button setImage:[UIImage imageNamed:@"Faddfri@2x.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(makeFriend:) forControlEvents:UIControlEventTouchDown];
            [footview addSubview:button];
            return footview;
        }
        else
            return nil;
    }
    return nil;
}

-(void)makeFriend:(id)sender
{
    //确认添加好友的界面
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认添加此人为好友?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    [alert release];

   
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"确认");
        NSLog(@"确认添加好友,需要确认添加好友的接口13:::");
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00013"];        
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        NSLog(@"确认添加好友：接口13：：：：%@,%@",self.userUUid,user_id);
        [rrequest setPostValue:self.userUUid forKey: @"uuid"];
        
        [rrequest setPostValue:user_id forKey:@"user_id"];
        
        [rrequest startSynchronous];
        //更改数据源
        [self.delegate Frichangedatasource];
        [self.navigationController popViewControllerAnimated:YES];
        
         
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section==2)&&(indexPath.row==1)) {
        UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    if ((indexPath.section==2)&&(indexPath.row==0)){
        return 25;
    }
    return 36;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    return 2.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 200;
    }
    return 10.0f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 2;
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

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    changePicview.backgroundColor=[UIColor blackColor];
    changePicview.frame=mainscreen;
    UIImageView* picima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 320, 320)];//不需要适配
    picima.image=picimage.image;
    [changePicview addSubview:picima];
    
    [picima release];
    
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

@end
