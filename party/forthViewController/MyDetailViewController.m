//
//  MyDetailViewController.m
//  Mydetail
//
//  Created by 李 萌萌 on 13-1-20.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "MyDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "areaPicker.h"
#import "sexPicker.h"
#import "ASIHTTPRequest.h"
#import "SDImageView+SDWebCache.h"
#import "ASIFormDataRequest.h"

static int flag=0;//标志位，标志所选择的选择器是哪一个

@interface MyDetailViewController ()

@end

@implementation MyDetailViewController
@synthesize mylocal,mycity;
@synthesize tableview;
@synthesize mylist;
@synthesize mydetailstring;
@synthesize dict;
@synthesize userUUid;
@synthesize Changeinfo,ChangePic;
-(void)viewWillAppear:(BOOL)animated
{
    self.title=@"个人资料";
    [self hideTabBar:YES];
    [self getUUidForthis];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillDisappear:animated];
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

    ChangePic=0;
    Changeinfo=0;
    [self getUUidForthis];
    
    datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, mainscreenhight,320, 216)];
    [datepicker setLocale: [[[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"]autorelease]];//设置时间选择器语言环境为中文
    datepicker.datePickerMode=UIDatePickerModeDate;
    [self.view addSubview:datepicker];
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"Back1@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=back;
    [back release];
    if (areapic==nil) {
        areapic = [[areaPicker alloc] initWithFrame:CGRectMake(0, mainscreenhight, 320, 216)];
        [self.view addSubview:areapic];
    }
    if (sexpic==nil) {
        sexpic = [[sexPicker alloc] initWithFrame:CGRectMake(0, mainscreenhight, 320, 216)];
        [self.view addSubview:sexpic];
    }
    if (areaboardToolbar == nil) {
        areaboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        areaboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(AreapickerHide)];
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(resignAreaboard:)];
        
        [areaboardToolbar setItems:[NSArray arrayWithObjects:cancelBtn,spaceBarItem,doneBarItem, nil]];
        [cancelBtn release];
        [doneBarItem release];
        [spaceBarItem release];
    }
    changePicview=[[UIImageView alloc]init];
    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(223, 10, 42, 42) ];
    imageview.layer.borderColor=[[UIColor colorWithRed:220.0/255 green:215.0/255 blue:215.0/255 alpha:1] CGColor];
    imageview.layer.borderWidth=2;
    imageview.layer.shadowOffset = CGSizeMake(1, 1);
    imageview.layer.shadowOpacity = 0.5;
    imageview.layer.shadowRadius = 2.0;
    picture=nil;
    mylist=[[NSArray alloc]initWithObjects:@"姓名 ",@"性别 ",@"年龄 ",@"地区 ", nil];
    NSString *stringUrl=[NSString stringWithFormat:@"http://www.ycombo.com/che/mac/user/IF00008?uuid=%@",userUUid];
    NSURL* url=[NSURL URLWithString:stringUrl];
    
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.backgroundColor=[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    [self.view addSubview:tableview];
   
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
    //请求数据
    NSData* response=[request responseData];
    NSLog(@"%@",response);
    NSError* error;
    NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",bizDic);
    self.dict=bizDic;
    [tableview reloadData];    
}
-(void)back
{

    //用户的图像更改了，调用接口11
    if (ChangePic==1) {
        NSLog(@"更新个人数据，包括个人图片,需要上传接口11");
        NSLog(@"%@",namefield.text);
        NSLog(@"%@",sexfield.text);

        if ([sexfield.text isEqualToString:@"女"]) {
            NSLog(@"F");
        }
        if ([sexfield.text isEqualToString:@"男"]) {
            NSLog(@"M");
        }
        NSLog(@"%@",agefield.text);
        NSLog(@"%@",self.mycity);
        NSLog(@"%@",self.mylocal);
        NSLog(@"%@",detail.text);
        
    
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/servlet/Upload"];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        NSMutableString* sexstr=[[NSMutableString alloc]init];
        if ([sexfield.text isEqualToString:@"女"]) {
            NSLog(@"F");
            [sexstr setString:@""];
            [sexstr appendString:@"F"];
        }
        if ([sexfield.text isEqualToString:@"男"]) {
            NSLog(@"M");
            [sexstr setString:@""];
            [sexstr appendString:@"M"];
        }
        NSLog(@"sexstr::::%@",sexstr);
        NSMutableString* filename=[[NSMutableString alloc]init];
        [filename appendFormat:@"a___%@",userUUid];
        [filename appendFormat:@"b___%@",namefield.text];
        [filename appendFormat:@"c___%@",agefield.text];
        [filename appendFormat:@"d___%@",sexstr];
        [filename appendFormat:@"e___%@",self.mycity];
        [filename appendFormat:@"f___%@",self.mylocal];
        [filename appendFormat:@"g___%@h___.jpg",detail.text];
        NSLog(@"%@",filename);
        UIImage* image=imageview.image;
        NSData *imageData=UIImageJPEGRepresentation(image, 0.1);
        //压缩
        [rrequest  addData:imageData withFileName:filename andContentType:@"image/jpeg" forKey:@"user_pic"];
        [rrequest startSynchronous];
        
        [filename release];
        [sexstr release];
    }
    else
    {
        //只是更改了个人资料，图片未更改
        if (Changeinfo==1) {
            //调用接口：未定
             NSLog(@"更新个人数据，不包括个人图片,需要上传接口未定");
            NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00066"];
            
            ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
            NSMutableString* sexstr=[[NSMutableString alloc]init];
            if ([sexfield.text isEqualToString:@"女"]) {
                NSLog(@"F");
                [sexstr setString:@""];
                [sexstr appendString:@"F"];
            }
            if ([sexfield.text isEqualToString:@"男"]) {
                NSLog(@"M");
                [sexstr setString:@""];
                [sexstr appendString:@"M"];
            }
            NSLog(@"接口66::::%@ %@ %@ %@ %@",sexstr,namefield.text,agefield.text,self.mycity,self.mylocal);
            [rrequest setPostValue:self.userUUid forKey: @"uuid"];
            
            [rrequest setPostValue:namefield.text forKey:@"user_nick"];
            [rrequest setPostValue:agefield.text forKey:@"user_age"];
            [rrequest setPostValue:sexstr forKey:@"user_sex"];
            [rrequest setPostValue:self.mycity forKey:@"user_city"];
            [rrequest setPostValue:self.mylocal forKey:@"user_local"];
            [rrequest setPostValue:detail.text forKey:@"user_des"];
            [rrequest startSynchronous];
            
        }
        else
        {
             NSLog(@"不需要上传,直接返回");
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }

    if (indexPath.section==0) {
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UPview@2x.png"]]autorelease];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10,16, 60, 30)];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor lightGrayColor];
        label.text=@"头像";
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:label];
        [label release];
        UIImageView* takeimage=[[UIImageView alloc]initWithFrame:CGRectMake(272, 26, 8, 10)];
        takeimage.image=[UIImage imageNamed:@"AOgo@2x.png"];
        [cell.contentView addSubview:takeimage];
        [takeimage release];

        if (picture!=nil) {
            imageview.image=picture;
        }
        else
            [imageview setImageWithURL:[NSURL URLWithString:[self.dict objectForKey:@"PIC"]]refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
        imageview.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageview addGestureRecognizer:singleTap];
        [singleTap release];
        
        [cell addSubview:imageview];

    }
    if (indexPath.section==1) {
        if (indexPath.row==3) {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UPview3@2x.png"]]autorelease];
        }
        else
        {
            cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UPview2@2x.png"]]autorelease];
        }
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 25)];
        label.text=[mylist objectAtIndex:indexPath.row];
        
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor lightGrayColor];
        label.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        UITextField* textfield=[[UITextField alloc]initWithFrame:CGRectMake(60, 10, 230, 25)];
        textfield.delegate=self;
        textfield.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        textfield.font=[UIFont systemFontOfSize:14];
        if (indexPath.row==0) {
            namefield=textfield;
            namefield.delegate=self;
            namefield.keyboardType=UIKeyboardTypeAlphabet;
            namefield.text=[self.dict objectForKey:@"NICK"];
        }
        if (indexPath.row==1) {
            sexfield=textfield;
            sexfield.tag=1002;
            if ([[[self.dict objectForKey:@"SEX"]substringToIndex:1] isEqualToString:@"F"]) {
                sexfield.text=@"女";

            }
            else
            {
                if ([[[self.dict objectForKey:@"SEX"]substringToIndex:1] isEqualToString:@"M"])
                {
                    sexfield.text=@"男";
                }
            }
        
            sexfield.inputAccessoryView=areaboardToolbar;
            sexfield.inputView=sexpic;
        }
        if (indexPath.row==2) {
            agefield=textfield;
            agefield.tag=1003;
            agefield.text=[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"AGE"]];
            agefield.inputView=datepicker;
            agefield.inputAccessoryView=areaboardToolbar;
        }
        if (indexPath.row==3) {
            localfield=textfield;
            localfield.tag=1001;
            self.mycity=[self.dict objectForKey:@"USER_CITY"];
            self.mylocal=[self.dict objectForKey:@"USER_LOCAL"];
            NSLog(@"++++%@+++++++%@++++",self.mycity,self.mylocal);
            if ([self.mycity isEqualToString:@"(null)"]) {
                localfield.text=@"";
            }
            else
            {
                localfield.text=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"USER_CITY"],[dict objectForKey:@"USER_LOCAL"]];
               
            }
            localfield.inputView = areapic;
            localfield.inputAccessoryView=areaboardToolbar;
        }
        [cell.contentView addSubview:textfield];
        [textfield release];
    }
    if (indexPath.section==2) {
        cell.backgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Uinfoview@2x.png"]]autorelease];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
        label.text=@"个人简介";
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor lightGrayColor];
        label.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        detail=[[UITextView alloc]initWithFrame:CGRectMake(10, 35, 280, 100)];
        detail.font=[UIFont systemFontOfSize:14];
        detail.tag=1;
        detail.text=[dict objectForKey:@"DES"];
        detail.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        detail.userInteractionEnabled=NO;
        detail.multipleTouchEnabled=NO;
        [cell.contentView addSubview:detail];
        [detail release];
    }

    cell.selectionStyle=UITableViewCellEditingStyleNone;

        return cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    Changeinfo=1;
    flag=textField.tag-1000;
    NSLog(@"%d",textField.tag);
    [self animateTextField: textField up: YES];
    
}

- (void)AreapickerHide
{
    [agefield endEditing:YES];
    [sexfield endEditing:YES];
    [localfield endEditing:YES];
}

-(void)resignAreaboard:(id)sender {
    Changeinfo=1;
    if (flag==1) {
        localfield.text=[NSString stringWithFormat:@"%@ %@",areapic.state,areapic.city];
        self.mycity=areapic.state;
        self.mylocal=areapic.city;
        [localfield endEditing:YES];
    }
    if (flag==2) {
        sexfield.text=sexpic.sex;
        [sexfield endEditing:YES];
    }
    if (flag==3) {
        NSDate *myDate = [NSDate date];//获取系统时间
        NSLog(@"myDate = %@",myDate);
        NSDate* date2=datepicker.date;//时间选择器的时间
        
        //计算两个事件之间的时间差，可以用来计算年龄
        NSCalendar *userCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit;
        NSDateComponents *components = [userCalendar components:unitFlags fromDate:date2 toDate:myDate options:0];
        int years = [components year];
        NSLog(@"%d",years);

        agefield.text=[NSString stringWithFormat:@"%d",years];
        [agefield endEditing:YES];
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.navigationController.navigationBarHidden=YES;
    changePicview.userInteractionEnabled=YES;
    changePicview.backgroundColor=[UIColor blackColor];
    changePicview.frame=mainscreen;
    UIImageView* picima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 320, 320)];//不需要适配
    picima.image=imageview.image;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UIActionSheet* myaction=[[UIActionSheet alloc]initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"本地照片" otherButtonTitles:@"拍照", nil];
        [myaction showInView:self.view];
        [myaction release];
        //[self choosePhoto];
    }
    if (indexPath.section==1) {
        if (indexPath.row==3) {
            NSLog(@"33333");
        }
    }
    if (indexPath.section==2) {

        ChangeMyInfoViewController* changemyinfo=[[ChangeMyInfoViewController alloc]init];
        changemyinfo.delegate=self;
        changemyinfo.beginstr=detail.text;
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:changemyinfo animated:YES];
        [changemyinfo release];
        }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self choosePhoto];
        
    }
    if (buttonIndex==1) {
        [self takePhoto];
    }
}


//编辑完之后键盘返回
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
     [textField resignFirstResponder];
     return YES;
}



//调用照相功能
-(void)takePhoto
{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"调用照相功能");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }

}


//从本地选择图片
- (void)choosePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];

}




#pragma mark delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    picture=aImage;
    imageview.image = picture;
    ChangePic=1;
    [picker dismissModalViewControllerAnimated:YES];
    
}


#pragma mark tableview-delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 4;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 63;
    }
    else
        if (indexPath.section==2) {
            return 150;
        }
        else
            return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 31;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 120;
    }
    return 5.0f;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const float movementDuration = 0.3f; // tweak as needed
    int movement=0;
    if (up) {
        movement=-100;
    }
    else
    {
        movement=100;
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

-(void)dealloc
{
    [mydetailstring release];
    [tableview release];
    [mylist release];
    [areapic release];
    [sexpic release];
    [areaboardToolbar release];
    [super dealloc];
}

-(void)passValue:(NSString *)value andChangeinfo:(int)changeinfo
{
    detail.text=value;
    self.Changeinfo=1;
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

@end
