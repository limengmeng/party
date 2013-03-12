//
//  ChangeMyInfoViewController.m
//  party
//
//  Created by 李 萌萌 on 13-1-27.
//
//

#import "ChangeMyInfoViewController.h"

@interface ChangeMyInfoViewController ()

@end

@implementation ChangeMyInfoViewController
@synthesize beginstr;
@synthesize delegate;

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
  
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"POBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(Quit) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    
    UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    donebutton.frame=CGRectMake(0.0, 0.0, 50, 31);
    [donebutton setImage:[UIImage imageNamed:@"Editdone@2x.png"] forState:UIControlStateNormal];
    [donebutton addTarget:self action:@selector(ChangeInfo) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
    self.navigationItem.rightBarButtonItem=Makedone;
    [goback release];
    [Makedone release];


    
    textview=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300, 240)];
    textview.text=beginstr;
    textview.delegate=self;
    [textview becomeFirstResponder];
    self.view.backgroundColor=[UIColor grayColor];
    [self.view addSubview:textview];
}

-(void)ChangeInfo
{
    [delegate passValue:textview.text andChangeinfo:1];
    NSLog(@"%@",textview.text);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Quit
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
