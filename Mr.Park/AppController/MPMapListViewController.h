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

@interface MPMapListViewController : MPBottomBarViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *containerView;
    IBOutlet UIView *infoView;
    
    IBOutlet MKMapView *map_View;
    IBOutlet UITableView *tbl_View;
    IBOutlet UIButton *btnToggleMapList;
    
    BOOL isMapView;
}
-(IBAction)btnReminderDidClicked:(id)sender;
-(IBAction)btnSwitchToMapAndList:(id)sender;

@end
