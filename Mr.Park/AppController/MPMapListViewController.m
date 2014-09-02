//
//  MPMapViewController.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPMapListViewController.h"

@interface MPMapListViewController ()

@end

@implementation MPMapListViewController
@synthesize map_View;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCurrentDateAndTime];
    
    MPBottomBarViewController *vc_bottomBar = [[MPBottomBarViewController alloc] initWithNibName:@"MPBottomBarViewController" bundle:nil];
    
    if (IS_IPHONE_5) {
        vc_bottomBar.view.frame = CGRectMake(0, 520, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }else{
        vc_bottomBar.view.frame = CGRectMake(0, 432, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }
    [self.view addSubview:[vc_bottomBar view]];
    
    isMapView = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.map_View setShowsUserLocation:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:now] capitalizedString];
    weekday = dayString;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    currentCoodinate = [userLocation coordinate];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(currentCoodinate, 2000, 2000);
    [self.map_View setRegion:zoomRegion animated:NO];
    currentLocation = userLocation.location;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (placemarks != nil && placemarks.count > 0) {
            placemark = [placemarks objectAtIndex:0];
            currentAddress = [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@",
                              placemark.subThoroughfare, placemark.thoroughfare,
                              placemark.locality, placemark.administrativeArea,
                              placemark.postalCode, placemark.country];
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    // Center the map the first time we get a real location change.
	static dispatch_once_t centerMapFirstTime;
    
	if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
		dispatch_once(&centerMapFirstTime, ^{
			[self.map_View setCenterCoordinate:userLocation.coordinate animated:YES];
		});
        for(tempTable* tpObj in tempTableArray) {
            CustomAnnotation *pin = [[CustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
            [map_View addAnnotation:pin];
        }
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //[HUD hide];
    if([annotation isKindOfClass:[CustomAnnotation class]]) {
        MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc]     initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
        CLLocationCoordinate2D temp = [annotation coordinate];
        newAnnotation.canShowCallout = YES;
        newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        newAnnotation.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_twitter@2x.png"]];
        //newAnnotation.image = [UIImage imageNamed:@"ic_fps@2x.png"];
        if([[self getParkingTypeLatitude:[NSString stringWithFormat:@"%lf",temp.latitude] Longitude:[NSString stringWithFormat:@"%lf",temp.longitude]]  isEqual: @"1"]) {
            newAnnotation.image = [UIImage imageNamed:@"ic_fp@2x.png"];
        }
        if([[self getParkingTypeLatitude:[NSString stringWithFormat:@"%lf",temp.latitude] Longitude:[NSString stringWithFormat:@"%lf",temp.longitude]]  isEqual: @"2"]) {
            newAnnotation.image = [UIImage imageNamed:@"ic_fps@2x.png"];
        }
        if([[self getParkingTypeLatitude:[NSString stringWithFormat:@"%lf",temp.latitude] Longitude:[NSString stringWithFormat:@"%lf",temp.longitude]]  isEqual: @"3"]) {
            newAnnotation.image = [UIImage imageNamed:@"ic_lt@2x.png"];
        }
        if([[self getParkingTypeLatitude:[NSString stringWithFormat:@"%lf",temp.latitude] Longitude:[NSString stringWithFormat:@"%lf",temp.longitude]]  isEqual: @"4"]) {
            newAnnotation.image = [UIImage imageNamed:@"ic_mp@2x.png"];
        }if([[self getParkingTypeLatitude:[NSString stringWithFormat:@"%lf",temp.latitude] Longitude:[NSString stringWithFormat:@"%lf",temp.longitude]]  isEqual: @"5"]) {
            newAnnotation.image = [UIImage imageNamed:@"ic_mps@2x.png"];
        }
        return newAnnotation;
    }
    else
        return nil;
    
}

- (NSString *) getParkingTypeLatitude: (NSString *)lat Longitude: (NSString *) lon {
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.lat isEqual: lat] && [tpObj.lon  isEqual: lon]) {
            parkingType = tpObj.parkingID;
            break;
        }
    }
    return parkingType;
}

#pragma mark - IB_ACTION

-(IBAction)btnFeedBackDidClicked:(id)sender{
    
    MPFeedBackViewController *vc_feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    [self presentViewController:vc_feedback animated:YES completion:NULL];
    
}
-(IBAction)btnSettingDidClicked:(id)sender{
    
    MPSettingViewController *vc_setting = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self presentViewController:vc_setting animated:YES completion:NULL];
    
}
-(IBAction)btnShareDidClicked:(id)sender{ 
    
    MPShareViewController *vc_share = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
    [self presentViewController:vc_share animated:YES completion:NULL];

}

-(IBAction)btnReminderDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_addTimer" sender:nil];
    
}
-(IBAction)btnSwitchToMapAndList:(id)sender{
    
    if (isMapView) {
        isMapView = NO;
        [btnToggleMapList setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
        [self performCubeAnimation:@"cube" animSubType:kCATransitionFromRight];
        [map_View removeFromSuperview];
        
        [containerView addSubview:tbl_View];
    }else{
        isMapView = YES;
        [btnToggleMapList setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [self performCubeAnimation:@"cube" animSubType:kCATransitionFromLeft];
        [tbl_View removeFromSuperview];
        
        [containerView addSubview:map_View];
    }
}
-(void)performCubeAnimation:(NSString*)animType animSubType:(NSString*)animSubType{
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = animType;
    transition.subtype = animSubType;
    [self.view.layer addAnimation:transition forKey:nil];
    [[[self view] layer] addAnimation: transition forKey: nil];
    
}

#pragma mark TABLE_VIEW DELEGATE AND DATASOURCE

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSString *cellIdentifier = @"listCell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"testing Mr.Park";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"segue_tblDetail" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getCurrentDateAndTime {
    now = [NSDate date]; // format is 2011-02-28 09:57:49 +0000
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-M-dd hh:mm:ss"];
    NSString *strNow = [dateFormat stringFromDate:now];
    NSArray *arr = [strNow componentsSeparatedByString:@" "];
    
    strDate = [arr objectAtIndex:0]; // strDate is 2011-02-28
    NSArray *arr_date = [strDate componentsSeparatedByString:@"-"];
    currentDay = [arr_date objectAtIndex:2];
    currentMonth = [arr_date objectAtIndex:1];
    currentYear = [arr_date objectAtIndex:0];
    
    strTime = [arr objectAtIndex:1]; // strTime is 09:57:49
    NSArray *arr_time = [strTime componentsSeparatedByString:@":"];
    currentSecond = [arr_time objectAtIndex:2];
    currentMinute = [arr_time objectAtIndex:1];
    currentHour = [arr_time objectAtIndex:0];
}

@end
