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
//#import "tempTable.h"


@interface MPMapListViewController : MPBottomBarViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *containerView;
    IBOutlet UIView *infoView;
    
    IBOutlet MKMapView *map_View;
    IBOutlet UITableView *tbl_View;
    IBOutlet UIButton *btnToggleMapList;
    IBOutlet UISearchBar *searchBar;
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
@property (nonatomic) CLLocationCoordinate2D destCoordinate;
-(IBAction)btnReminderDidClicked:(id)sender;
-(IBAction)btnSwitchToMapAndList:(id)sender;
- (IBAction)btn_FreeParking:(id)sender;
- (IBAction)btn_FreeParkingStructure:(id)sender;
- (IBAction)btn_LimitParking:(id)sender;
- (IBAction)btn_MeterParking:(id)sender;
- (IBAction)btn_MeterParkingStructure:(id)sender;
@end
