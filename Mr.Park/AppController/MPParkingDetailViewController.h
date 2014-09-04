//
//  MPMapListViewController.h
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMapListViewController.h"
#import "MPFeedBackViewController.h"
#import "MPSettingViewController.h"
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface MPParkingDetailViewController : MPBottomBarViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet MKMapView *map_View;
    BOOL isMapView;
}
@property (nonatomic, retain) IBOutlet MKMapView *map_View;
@property (weak, nonatomic) IBOutlet UILabel *streetNameText;
@property (weak, nonatomic) IBOutlet UILabel *addressText;
- (IBAction)navButton:(UIButton *)sender;

- (IBAction)btn_Facebook:(id)sender;
- (IBAction)btn_Twitter:(id)sender;
- (IBAction)btn_Email:(id)sender;

@end
