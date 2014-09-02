//
//  MPMapViewController.h
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MPFeedBackViewController.h"
#import "MPSettingViewController.h"
#import "MPShareViewController.h"
#import "MPParkingDetailViewController.h"
#import "MPGlobalData.h"
#import "MPCustomAnnotation.h"

@interface MPMapListViewController : MPBottomBarViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *containerView;
    IBOutlet UIView *infoView;
    
    IBOutlet MKMapView *map_View;
    IBOutlet UITableView *tbl_View;
    IBOutlet UIButton *btnToggleMapList;
    
    BOOL isMapView;
    
    double currentLatitude;
    double currentLongitude;
    NSString *currentAddress;
    MKPlacemark *placemark;
    CLGeocoder *geocoder;
    CLLocation *currentLocation;
    CLLocationCoordinate2D currentCoodinate;
    CLLocationCoordinate2D destCoodinate;
}
@property (nonatomic, retain) IBOutlet MKMapView *map_View;
@property (nonatomic, retain) CLGeocoder *geocoder;
-(IBAction)btnReminderDidClicked:(id)sender;
-(IBAction)btnSwitchToMapAndList:(id)sender;

@end
