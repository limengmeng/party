//
//  AboutViewController.m
//  AboutView
//
//  Created by 李 萌萌 on 13-1-21.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "AboutViewController.h"
#import "FunctionViewController.h"
#import "WelcomeViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize tableview;
@synthesize myVersions;
@synthesize mylist;

-(void)back
{
    //[self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initVersions:(NSString *)versions
{

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"关于玩聚";
    mylist=[[NSArray alloc]initWithObjects:@"版本",@"功能介绍",@"欢迎页", nil];
    
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    [table release];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self.view addSubview:self.tableview];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"]autorelease];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row!=0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=[mylist objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text=@"版本";
        cell.detailTextLabel.text=@"4.3.3";
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)]autorelease];
    UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 320, 30)];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.text=@"使用条款和隐私政策";
    label1.backgroundColor=[UIColor clearColor];
    [footerview addSubview:label1];
    [label1 release];
    UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 20)];
    label2.backgroundColor=[UIColor clearColor];
    label2.text=@"玩聚公司  版权所有";
    label2.textAlignment=NSTextAlignmentCenter;
    [footerview addSubview:label2];
    [label2 release];
    UILabel* label3=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, 320, 20)];
    label3.backgroundColor=[UIColor clearColor];
    label3.text=@"Copyright @ 2012-2013 Tencent.";
    label3.textAlignment=NSTextAlignmentCenter;
    [footerview addSubview:label3];
    [label3 release];
    UILabel* label4=[[UILabel alloc]initWithFrame:CGRectMake(0, 140, 320, 20)];
    label4.backgroundColor=[UIColor clearColor];
    label4.text=@"All Rights Reserved.";
    label4.textAlignment=NSTextAlignmentCenter;
    [footerview addSubview:label4];
    [label4 release];
    return footerview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        FunctionViewController* function=[[FunctionViewController alloc]init];
        [self.navigationController pushViewController:function animated:YES];
        [function release];
    }
    if (indexPath.row==2) {
        WelcomeViewController* welcome=[[WelcomeViewController alloc]init];
        [self.navigationController pushViewController:welcome animated:YES];
        [welcome release];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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






@end
