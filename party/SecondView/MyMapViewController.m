//
//  MyMapViewController.m
//  Aibangapi
//
//  Created by lly on 13-2-3.
//  Copyright (c) 2013年 尹林林. All rights reserved.
//

#import "MyMapViewController.h"

@interface MyMapViewController ()

@end

@implementation MyMapViewController
@synthesize map;
@synthesize lat,lon;
@synthesize shoptitle;

-(void)initTitle:(NSString *)str
{
    self.shoptitle=str;
    
}
-(void)initData:(float)latsss and:(float)lonsss
{
    self.lat=latsss;
    
    self.lon=lonsss;
    NSLog(@"lly:::%f,%f",self.lat,self.lon);
}
-(id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
-(void)back
{
    //[self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"POBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    [super viewWillAppear:animated];
    [goback release];
    //[self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    MKMapView* smap=[[MKMapView alloc]initWithFrame:self.view.bounds];
    self.map=smap;
    [smap release];
    
    self.map.showsUserLocation=YES;
    self.map.userLocation.title=@"我在这里噢";
    self.map.mapType=MKMapTypeStandard;
    map.delegate=self;
    [self.view addSubview:self.map];
    CLLocationCoordinate2D coords=CLLocationCoordinate2DMake(lat,lon);
    
    //定义显示范围
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    
    //定义一个区域（使用设置的经度纬度加上一个范围）
    MKCoordinateRegion theRegion;
    theRegion.center=coords;
    theRegion.span=theSpan;
    [map setRegion:theRegion];
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));

    
    MKCoordinateRegion fitRegion = [self.map regionThatFits:region];
    //lat=116.398546;
    //lon=39.1215241;
    [map setRegion:fitRegion animated:YES];
    [self createAnnotationWithCoords:coords];
}


-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords {
    
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate: coords];
    annotation.title = self.shoptitle;
    
    [map addAnnotation:annotation];
    [annotation release];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [shoptitle release];
    [map release];
    [super dealloc];
}
@end
