//
//  PrivacyViewController.m
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController
@synthesize userUUid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"隐私设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];

	// Do any additional setup after loading the view.
    //栏
    field1 =[[UITextField alloc]initWithFrame:CGRectMake(10*mainwith, 40*mainhight, (self.view.frame.size.width-20)*mainwith, 40*mainhight)];
    field1.text=@"   加我为好友是需要验证";
    field1.textColor=[UIColor lightGrayColor];
    field1.userInteractionEnabled=NO;
    [field1 setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field1.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field1.delegate=self;
    [self.view addSubview:field1];
    
    UISwitch *mySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(220*mainwith, 48*mainhight, (self.view.frame.size.width-40)*mainwith, 40*mainhight)];
    [self.view addSubview:mySwitch];
    [mySwitch release];
    
    //栏
    field2 =[[UITextField alloc]initWithFrame:CGRectMake(10*mainwith, 100*mainhight, (self.view.frame.size.width-20)*mainwith, 40*mainhight)];
    field2.text=@"   可通过手机号搜到我";
    field2.userInteractionEnabled=NO;
    field2.textColor=[UIColor lightGrayColor];
    [field2 setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field2.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    [self.view addSubview:field2];
    
    UISwitch *mySwitch1=[[UISwitch alloc]initWithFrame:CGRectMake(220*mainwith, 108*mainhight, (self.view.frame.size.width-40)*mainwith, 40*mainhight)];
    [self.view addSubview:mySwitch1];
    [mySwitch1 release];
    
    //栏
    field3 =[[UITextField alloc]initWithFrame:CGRectMake(10*mainwith, 160*mainhight, (self.view.frame.size.width-20)*mainwith, 40*mainhight)];
    field3.text=@"   在活动中可见";
    field3.userInteractionEnabled=NO;
    field3.textColor=[UIColor lightGrayColor];
    [field3 setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field3.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    [self.view addSubview:field3];
    
    UISwitch *mySwitch2=[[UISwitch alloc]initWithFrame:CGRectMake(220*mainwith, 168*mainhight, (self.view.frame.size.width-40)*mainwith, 40*mainhight)];
    [self.view addSubview:mySwitch2];
    [mySwitch2 release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:YES];
    [self getUUidForthis];
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


-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
