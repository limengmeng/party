//
//  MapViewController.h
//  party
//
//  Created by yilinlin on 13-1-19.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class CustomAnnotation;

@protocol passValueDelegate
-(void)passLat:(float)_lat andLng:(float)_lng;
-(void)passCity:(NSString*)city andLocal:(NSString*)local;
@end
@interface MapViewController : UIViewController<MKMapViewDelegate,UISearchBarDelegate>
{
    id<passValueDelegate> delegate;
    MKMapView* map;
    CLGeocoder* geocoder;
    UISearchBar* mySearchBar;
    float lat;
    float lng;
    UILabel* label;
    NSMutableString* city;
    NSMutableString* local;
}
@property (strong,nonatomic) NSMutableString* city;
@property (strong,nonatomic) NSMutableString* local;

@property (nonatomic,assign)id<passValueDelegate> delegate;
@property (strong,nonatomic) MKMapView* map;
@property (strong,nonatomic) CLGeocoder* geocoder;
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer;
- (void)showDetails;

@end
