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
#import "MPConstant.h"


@interface MPMapListViewController : MPBottomBarViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>{
    
    AryaHUD *hud;
    IBOutlet UIView *containerView;
    IBOutlet UIView *infoView;
    
    IBOutlet MKMapView *map_View;
    IBOutlet UIButton *btnToggleMapList;
    BOOL isMapView;
    
    int countList;
    
    NSString *currentAddress;
    MKPlacemark *placemark;
    CLGeocoder *geocoder;
    
    double d_start;
    double d_end;
    double r_start;
    double r_end;
    double c_time;
    double s_start;
    double s_end;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet MKMapView *map_View;
@property (nonatomic, retain) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@property (nonatomic) CLLocationCoordinate2D destCoordinate;

- (IBAction)btnReminderDidClicked:(id)sender;
- (IBAction)btnSwitchToMapAndList:(id)sender;

//=========== INFO_Btn ===========
- (IBAction)btn_FreeParking:(id)sender;
- (IBAction)btn_FreeParkingStructure:(id)sender;
- (IBAction)btn_LimitParking:(id)sender;
- (IBAction)btn_MeterParking:(id)sender;
- (IBAction)btn_MeterParkingStructure:(id)sender;
@end
