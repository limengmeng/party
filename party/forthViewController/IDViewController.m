//
//  IDViewController.m
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import "IDViewController.h"
#import "passwordViewController.h"
#import "LogInViewController.h"
#import "firstViewController.h"

@interface IDViewController ()

@end

@implementation IDViewController
@synthesize mail,mail_pass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"我的账号";
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
    [backbutton setImage:[UIImage imageNamed:@"POBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    
    [super viewWillAppear:animated];
    [self getUUidForthis];
    [goback release];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
	// Do any additional setup after loading the view.
    //**********************************账号*****************************************
    UITextField *field1=[[UITextField alloc]initWithFrame:CGRectMake(20, 40, 280, 40)];
    field1.borderStyle=UITextBorderStyleBezel;
    field1.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field1.userInteractionEnabled=NO;
    [self.view addSubview:field1];
    
    //账号栏
    name =[[UITextField alloc]initWithFrame:CGRectMake(65, 40, 220, 40)];
    [name setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.backgroundColor=[UIColor clearColor];
    name.tag=100;
    name.textColor=[UIColor lightGrayColor];
    name.userInteractionEnabled=NO;
    name.delegate=self;
    [self.view addSubview:name];
    
    UILabel *labelName=[[UILabel alloc]initWithFrame:CGRectMake(27, 40, 60, 40)];
    labelName.text=@"账号：";
    labelName.textColor=[UIColor lightGrayColor];
    [labelName setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    labelName.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelName];
    [labelName release];
    [field1 release];
    //**********************************账号 end*****************************************
    
    //**********************************密码*****************************************
    //密码栏
    password =[[UITextField alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 40)];
    password.text=@"密码：";
    password.textColor=[UIColor lightGrayColor];
    [password setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    password.borderStyle=UITextBorderStyleBezel;
    password.backgroundColor=[UIColor clearColor];
    [self.view addSubview:password];

    passWordButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 40)];
    //[button setFont:[UIFont fontWithName:@"Arial" size:12.0];
    [passWordButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    passWordButton.backgroundColor=[UIColor clearColor];
    //button.titleLabel.text=@"添加好友";
    //[passWordButton setTitle:@"密码：" forState:UIControlStateNormal];
    button.titleLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:passWordButton];
     //**********************************密码 end*****************************************
    
     //**********************************手机号*****************************************
    UITextField *field3=[[UITextField alloc]initWithFrame:CGRectMake(20, 160, 280, 40)];
    field3.backgroundColor=[UIColor clearColor];
    field3.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field3.userInteractionEnabled=NO;
    [self.view addSubview:field3];
    //手机号栏
    phone =[[UITextField alloc]initWithFrame:CGRectMake(100, 160, 220, 40)];
    [phone setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phone.backgroundColor=[UIColor clearColor];
    phone.textColor=[UIColor lightGrayColor];
    phone.tag=101;
    phone.userInteractionEnabled=NO;
    phone.delegate=self;
    [self.view addSubview:phone];
    
    UILabel *labelTime=[[UILabel alloc]initWithFrame:CGRectMake(27, 160, 80, 40)];
    labelTime.text=@"您的手机号：";
    labelTime.textColor=[UIColor lightGrayColor];
    [labelTime setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    labelTime.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelTime];
    [labelTime release];
    [field3 release];
    //**********************************手机号end*****************************************
    
    
    //**********************************按钮操作*****************************************
    button =[[UIButton alloc]initWithFrame:CGRectMake(20, 280, self.view.frame.size.width-40, 40)];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor grayColor];
    [button setImage:[UIImage imageNamed:@"TUICHU@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    //**********************************按钮操作 end*****************************************

}

-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"Guo.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *getmail=[stringmutable objectAtIndex:0];
    NSString *getmail_pass=[stringmutable objectAtIndex:1];
    self.mail=getmail;
    self.mail_pass=getmail_pass;
    name.text=self.mail;
    password.text=[NSString stringWithFormat:@"密码:   %@",self.mail_pass];
}

-(void) action
{
    passwordViewController *passVC=[[passwordViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:passVC animated:YES];
    [passVC release];
}

-(void)buttonAction{
    NSLog(@"退出！");
   
    //=========将用户的UUid放入本地=============================================
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:fileName];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:fileName error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }

    LogInViewController *lvController=[[LogInViewController alloc]init];
    //[self presentViewController:lvController animated:YES completion:nil];
    [self.tabBarController.view addSubview:lvController.view];
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popViewControllerAnimated:YES];
    //[lvController release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击done隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
