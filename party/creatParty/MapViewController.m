//
//  MapViewController.m
//  party
//
//  Created by yilinlin on 13-1-19.
//
//

#import "MapViewController.h"
#import "CustomAnnotation.h"
#import <QuartzCore/QuartzCore.h>
int flag=0;
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize delegate;
@synthesize city;
@synthesize local;

@synthesize map;
@synthesize geocoder;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"派对地点";
    }
    return self;
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

- (void)viewDidLoad
{
    flag=0;
    NSMutableString* str=[[NSMutableString alloc]init];
    self.city=str;
    [str release];
    NSMutableString* localstr=[[NSMutableString alloc]init];
    self.local=localstr;
    [localstr release];
    MKMapView* smap=[[MKMapView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    NSLog(@"%f,%f",[[UIScreen mainScreen] bounds].size.height,self.view.bounds.size.width);
    self.map=smap;
    [smap release];
    geocoder=[[CLGeocoder alloc]init];
    self.map.showsUserLocation=YES;
    self.map.userLocation.title=@"我在这里噢";
    self.map.mapType=MKMapTypeStandard;
    self.map.delegate=self;
    [self.view addSubview:self.map];
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒作为响应longPress方法
    [map addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
    [lpress release];
    mySearchBar = [[UISearchBar alloc]
                   initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45*mainhight)];
    mySearchBar.delegate = self;
    UIView* segment=[mySearchBar.subviews objectAtIndex:0];
    [segment removeFromSuperview];
    
    UITextField* searchField=[[mySearchBar subviews] lastObject];
    [searchField setReturnKeyType:UIReturnKeySearch];
    mySearchBar.backgroundColor=[UIColor lightGrayColor];
    mySearchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:mySearchBar];
    [mySearchBar release];
    
    mySearchBar.placeholder=@"搜索或长按地图";
    label=[[UILabel alloc]initWithFrame:CGRectMake(10, mainscreenhight-110,300, 20)];
    
    label.font=[UIFont systemFontOfSize:12];
    
    label.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    label.layer.cornerRadius=7;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.text=@"";
    [self.view addSubview:label];
    [super viewDidLoad];
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //map的userlocation在这个方法里才开始获得
   NSLog(@"自己的位置::::%f,%f",map.userLocation.coordinate.latitude,map.userLocation.coordinate.longitude);

    if (flag==0) {
        float zoomLevel = 0.01;
        MKCoordinateRegion region = MKCoordinateRegionMake(map.userLocation.coordinate,MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [self.map setRegion:[self.map regionThatFits:region] animated:YES];
        flag++;
    }
   
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"lly";
        pinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
        {
            pinView = [[[MKPinAnnotationView alloc]
                        initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        }
        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else
    {
        [map.userLocation setTitle:@"我的位置"];
        NSString* locDesc = [NSString stringWithFormat:@"经度%f  纬度:%f", map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude];
        [map.userLocation setSubtitle:locDesc];
    }
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"SelectCheck@2x.png"] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(0, 0, 48 , 30);
    [rightButton addTarget:self action:@selector(showDetails) forControlEvents:UIControlEventTouchUpInside];
    
    //pinView.rightCalloutAccessoryView = rightButton;
    pinView.leftCalloutAccessoryView=rightButton;
   
    return pinView;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    UITextField* searchField=[[searchBar subviews] lastObject];
    [searchField resignFirstResponder];
    [NSThread detachNewThreadSelector:@selector(searchPlace) toTarget:self withObject:nil];
    //[self searchPlace:searchBar];
    
}


-(void)searchPlace
{
    UITextField* searchField=[[mySearchBar subviews] lastObject];
    NSLog(@"%@",searchField.text);
    NSString *urlStr = [[NSString stringWithFormat:@"http://maps.apple.com/maps/geo?q=%@&output=csv",searchField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *apiResponse = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",apiResponse);
    if (apiResponse.length != 0) {
        NSArray *array = [apiResponse componentsSeparatedByString:@","];
        NSLog(@"%@",array);
        lat = [[array objectAtIndex:2] floatValue];
        lng = [[array objectAtIndex:3] floatValue];
        NSLog(@"搜索地图解析出来的经纬度：：：%f,%f",lat,lng);
        float zoomLevel = 0.01;
        //NSLog(@"%f,%f",map.userLocation.coordinate.latitude,map.userLocation.coordinate.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lng),MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [map setRegion:[map regionThatFits:region] animated:YES];

        [self MakeAnnotation];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法查找到您需要的位置，请检查输入或网络连接" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}
- (void)showDetails
{
    NSLog(@"showDetails button clicked!");
    [delegate passCity:self.city andLocal:self.local];
    [delegate passLat:lat andLng:lng];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        return;
    }
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:map];
    CLLocationCoordinate2D touchMapCoordinate =[map convertPoint:touchPoint toCoordinateFromView:map];
    lat=touchMapCoordinate.latitude;
    lng=touchMapCoordinate.longitude;
    NSLog(@"长按地图获取到的经纬度:%f,%f",lat,lng);
    [self MakeAnnotation];
    
}
-(void)MakeAnnotation
{
    CustomAnnotation* pointAnnotation = nil;
    pointAnnotation = [[CustomAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    CLLocation* location=[[CLLocation alloc]initWithLatitude:lat longitude:lng];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark* placemark=[placemarks objectAtIndex:0];
        if (placemark==nil) {
            NSLog(@"null");
        }
        else{
            NSDictionary* dict=placemark.addressDictionary;
            NSLog(@"%@",dict);
            NSLog(@"%@",[dict objectForKey:@"City"]);
            NSLog(@"%@",[dict objectForKey:@"Country"]);
            NSLog(@"%@",[dict objectForKey:@"CountryCode"]);
            NSLog(@"%@",[dict objectForKey:@"FormattedAddressLines"]);
            NSLog(@"%@",[dict objectForKey:@"Name"]);
            NSLog(@"%@",[dict objectForKey:@"State"]);//1
            NSLog(@"%@",[dict objectForKey:@"Street"]);
            NSLog(@"%@",[dict objectForKey:@"SubLocality"]);//1
            NSLog(@"%@",[dict objectForKey:@"Thoroughfare"]);//1
            //在搜索框显示“搜索或长按地图”
            [city setString:@""];
            //[city appendString:[dict objectForKey:@"State"]];
            [city appendFormat:@"%@",[dict objectForKey:@"City"]];
            if ([city isEqualToString:@"(null)"]) {
                [city setString:@""];
                [city appendFormat:@"%@",[dict objectForKey:@"State"]];
            }
            [local setString:@""];
            [local appendFormat:@"%@%@",[dict objectForKey:@"SubLocality"],[dict objectForKey:@"Thoroughfare"]];
            label.text=[NSString stringWithFormat:@"%@ %@",city,local];
        }
        
    }];
    pointAnnotation.title = @" ";
   // pointAnnotation.subtitle=@" ";
    [map removeAnnotations:self.map.annotations];
    [map addAnnotation:pointAnnotation];
    [pointAnnotation release];
    [location release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [map release];
    [geocoder release];
    [city release];
    [local release];
    [super dealloc];
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
