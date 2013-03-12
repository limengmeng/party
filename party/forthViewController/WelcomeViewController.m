//
//  WelcomeViewController.m
//  AboutView
//
//  Created by 李 萌萌 on 13-1-21.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    self.title=@"欢迎页";
    [super viewDidLoad];
    [self hideTabBar:YES];
	// Do any additional setup after loading the view.
    
    scrollview =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, mainscreenhight)];
    scrollview.contentSize=CGSizeMake(320*6, mainscreenhight);
    scrollview.contentOffset=CGPointMake(0.0, 0);
    scrollview.pagingEnabled=YES;//是否自己动适应
    for (int i=0; i<=5; i++) {
        UIView* sview=[[UIView alloc]initWithFrame:CGRectMake(320*i, 0, 320, mainscreenhight)];
        
        UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, mainscreenhight)];
        imageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        [sview addSubview:imageview];
        [imageview release];
        
        if (i==5) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(43, mainscreenhight-80, 234, 37);
            [button setImage:[UIImage imageNamed:@"enter@2x.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(removeScro) forControlEvents:UIControlEventTouchDown];
            [sview addSubview:button];
        }
        [scrollview addSubview:sview];
        [sview release];
        
    }
    [self.view addSubview:scrollview];
    scrollview.delegate=self;
    scrollview.canCancelContentTouches=NO;
    
    //当值是 YES 的时候，用户触碰开始.要延迟一会，看看是否用户有意图滚动。假如滚动了，那么捕捉 touch-down 事件，否则就不捕捉。假如值是NO，当用户触碰， scroll view 会立即触发
    scrollview.delaysContentTouches=YES;
    [scrollview release];
    //显示有多少页的pageController
    pageController=[[UIPageControl alloc] initWithFrame:CGRectMake(0, mainscreenhight-40, 320, 20)];
    pageController.userInteractionEnabled=NO;
    [pageController setNumberOfPages:6];
    [pageController setCurrentPage:0];
    [self.view addSubview:pageController];
    [pageController release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    self.navigationController.navigationBarHidden=NO;
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:YES];
    self.navigationController.navigationBarHidden=YES;
    [super viewWillAppear:animated];
}


-(void)removeScro
{
    [self.navigationController popViewControllerAnimated:YES];

}

//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) /  scrollView.frame.size.width) + 1;
    [pageController setCurrentPage:currentPage];
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
