//
//  MyMapViewController.h
//  Aibangapi
//
//  Created by lly on 13-2-3.
//  Copyright (c) 2013年 尹林林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@interface MyMapViewController : UIViewController<MKMapViewDelegate>
{
    MKMapView* map;
    float lat;
    float lon;
    NSString* shoptitle;
}


@property CGFloat lat,lon;
@property (strong,nonatomic) MKMapView* map;

@property (strong,nonatomic) NSString* shoptitle;
-(void)initData:(float)latsss and:(float)lonsss;


-(void)initTitle:(NSString*)str;



@end
