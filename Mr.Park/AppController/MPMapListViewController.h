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
//#import "tempTable.h"


@interface MPMapListViewController : MPBottomBarViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *containerView;
    IBOutlet UIView *infoView;
    
    IBOutlet MKMapView *map_View;
    IBOutlet UITableView *tbl_View;
    IBOutlet UIButton *btnToggleMapList;
    IBOutlet UISearchBar *searchBar;
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
