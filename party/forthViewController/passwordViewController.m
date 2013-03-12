//
//  passwordViewController.m
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import "passwordViewController.h"
#import "ASIFormDataRequest.h"

@interface passwordViewController ()

@end

@implementation passwordViewController
@synthesize userUUid;
@synthesize mail,mail_pass;
@synthesize mynewPass,mynewPassDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"修改密码";
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
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    //旧密码：
    UITextField *field1=[[UITextField alloc]initWithFrame:CGRectMake(20, 40, 280, 40)];
    field1.borderStyle=UITextBorderStyleBezel;
    field1.placeholder=@"旧密码：";
    field1.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field1.font=[UIFont systemFontOfSize:12];
    field1.userInteractionEnabled=NO;
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field1];
    
    
    oldPass =[[UITextField alloc]initWithFrame:CGRectMake(70, 40, (self.view.frame.size.width-90), 40)];
    oldPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //oldPass.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    oldPass.delegate=self;
    oldPass.tag=101;
    oldPass.backgroundColor=[UIColor clearColor];
    [self.view addSubview:oldPass];
    
    [field1 release];
    
//    //新密码栏
    UITextField *field2=[[UITextField alloc]initWithFrame:CGRectMake(20, 100, 280, 40)];
    field2.borderStyle=UITextBorderStyleBezel;
    field2.placeholder=@"新密码：";
    field2.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field2.userInteractionEnabled=NO;
    field2.font=[UIFont systemFontOfSize:12];
    field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field2];
    [field2 release];
    
    newPass =[[UITextField alloc]initWithFrame:CGRectMake(70, 100, (self.view.frame.size.width-90), 40)];
    newPass.backgroundColor=[UIColor clearColor];
    newPass.tag=102;
    newPass.delegate=self;
    newPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:newPass];
    
    //密码确认
    UITextField *field3=[[UITextField alloc]initWithFrame:CGRectMake(20, 160, 280, 40)];
    field3.borderStyle=UITextBorderStyleBezel;
    field3.placeholder=@"密码确认：";
    field3.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field3.userInteractionEnabled=NO;
    field3.font=[UIFont systemFontOfSize:12];
    field3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field3];
    
    
    passAgan=[[UITextField alloc]initWithFrame:CGRectMake(85, 160, (self.view.frame.size.width-105), 40)];
    passAgan.delegate=self;
    passAgan.backgroundColor=[UIColor clearColor];
    passAgan.tag=103;
    passAgan.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:passAgan];
    
    [field3 release];
    
    
    //**********************************按钮操作*****************************************
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(20, 280, self.view.frame.size.width-40, 40);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor grayColor];
    [button setImage:[UIImage imageNamed:@"DONE@2x.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    //**********************************按钮操作 end*****************************************
    
    [self getUUidForthis];
    [self getUUidfromthis];


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
}

-(void)getUUidfromthis
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag==102) {
        //[textField endEditing:YES];
        self.mynewPass=textField.text;
    }
    if (textField.tag==103) {
        //[textField endEditing:YES];
        self.mynewPassDone=textField.text;
    }
}

-(void)buttonAction{
   
    NSLog(@"newPass=========%@",mynewPass);
    NSLog(@"passAgan=========%@",mynewPassDone);
    
    if ([oldPass.text isEqualToString:self.mail_pass]) {
        if(self.mynewPass.length!=0&&self.mynewPassDone.length!=0){
            if ([self.mynewPassDone isEqualToString:self.mynewPass]) {
                    NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00038"];
                    ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
                    //[request setPostValue:[self.senderDic objectForKey:@"SENDER_ID"] forKey: @"user_id"];
                    NSLog(@"38接口用户uuid=======%@",self.userUUid);
                    NSLog(@"38接口用户新密码=======%@",self.mynewPass);
                    
                    [request setPostValue:self.userUUid forKey:@"uuid"];
                    [request setPostValue:self.mynewPass forKey:@"user_mail_pass"];
                    [request startSynchronous];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    //更换本地数据
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
                    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
                    NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObjects:self.mail, self.mynewPass,nil];
                    NSLog(@"sadafdasfas%@",uuidMutablearray);
                    [uuidMutablearray writeToFile:fileName atomically:YES];
                    [self.view removeFromSuperview];
            }else{
                UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不对应" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [soundAlert show];
                [soundAlert release];
            }
        }
        else{
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
    }
    else{
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旧密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
        [soundAlert release];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
