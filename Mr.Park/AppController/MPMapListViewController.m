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
//        for(tempTable* tpObj in tempTableArray) {
//            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
//            [map_View addAnnotation:pin];
//        }
        for(int i = 0; i < 3; i++) {
            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:@"aaa" Subtitle:@"bbb" Location:CLLocationCoordinate2DMake(33.8503432, -117.738511)];
            [map_View addAnnotation:pin];
        }
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //[HUD hide];
    if([annotation isKindOfClass:[MPCustomAnnotation class]]) {
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

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    MPParkingDetailViewController *dvc = [[MPParkingDetailViewController alloc] initWithNibName:@"MPParkingDetailViewController" bundle:nil];
    self.destCoordinate = [[view annotation] coordinate];
    destLatitude = destCoodinate.latitude;
    destLongitude = destCoodinate.longitude;
    [self getDestInformationWithLatitude:[NSString stringWithFormat:@"%lf",destLatitude] Longitude:[NSString stringWithFormat:@"%lf",destLongitude]];
    [self.navigationController pushViewController:dvc animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (NSString *) getParkingTypeLatitude: (NSString *)lat Longitude: (NSString *) lon {
//    for(tempTable* tpObj in tempTableArray) {
//        if([tpObj.lat isEqual: lat] && [tpObj.lon  isEqual: lon]) {
//            parkingType = tpObj.parkingID;
//            break;
//        }
//    }
    return parkingType;
}

- (void) getDestInformationWithLatitude: (NSString *)lat Longitude: (NSString *) lon {
//    for(tempTable* tpObj in tempTableArray) {
//        if([tpObj.lat isEqual: lat] && [tpObj.lon  isEqual: lon]) {
//            destStreetName = tpObj.streetName;
//            destAddress = tpObj.fullAddress;
//            break;
//        }
//    }
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
        [containerView addSubview:infoView];
    }else{
        isMapView = YES;
        [btnToggleMapList setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [self performCubeAnimation:@"cube" animSubType:kCATransitionFromLeft];
        [tbl_View removeFromSuperview];
        
        [containerView addSubview:map_View];
        [containerView addSubview:infoView];
    }
}
- (IBAction)btn_FreeParking:(id)sender {
}
- (IBAction)btn_FreeParkingStructure:(id)sender {
}
- (IBAction)btn_LimitParking:(id)sender {
}
- (IBAction)btn_MeterParking:(id)sender {
}
- (IBAction)btn_MeterParkingStructure:(id)sender{
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self->searchBar resignFirstResponder];
    
}


-(void)createTempDB{
    
    
    //    NSString* currentTime = strTime;
    //    NSString* currentDay = weekday;
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM addressTable where address_id < 21"];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            tempTableArray = [NSMutableArray new];
            while([dataArr next]){
                tempTable * tempObj = [tempTable new];
                tempObj.addressID = [dataArr stringForColumn:@"address_id"];
                tempObj.lat = [dataArr stringForColumn:@"houseLat"];
                tempObj.lon = [dataArr stringForColumn:@"houseLong"];
                tempObj.parkingID = [dataArr stringForColumn:@"parking_ids"];
                tempObj.fullAddress  = [dataArr stringForColumn:@"houseFullAddress"];
                tempObj.streetName = [dataArr stringForColumn:@"streetName"];
                [tempTableArray addObject:tempObj];
            }
        }
        else
        {
            NSLog(@"error in select from address to create temp table");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    for (tempTable *tp in tempTableArray) {
        NSArray *arr_type = [tp.parkingID componentsSeparatedByString:@","];
        for (int i =0; i<arr_type.count; i++) {
            NSString *part = arr_type[i];
            [self getParkingFromDatabase:[part intValue]];
            if ([parkingHolder.str_parking_default_days rangeOfString:weekday].location != NSNotFound) {
                tp.parkingID = part;
                break;
            }
        }
    }
    
}


- (void)getAddressFromDatabase{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM addressTable where houseLat = \"%lf\" AND houseLong = \"%lf\"", destLatitude, destLatitude];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            addressHolder = [AddressDB new];
            
            addressHolder.str_addId = [NSNumber numberWithInt:[dataArr intForColumn:@"address_id"]];
            addressHolder.str_cityName = [dataArr stringForColumn:@"city_name"];
            addressHolder.str_createdId = [dataArr stringForColumn:@"created_at"];
            addressHolder.str_houseFullAddress = [dataArr stringForColumn:@"houseFullAddress"];
            addressHolder.str_houseLat = [dataArr stringForColumn:@"houseLat"];
            addressHolder.str_houseLong = [dataArr stringForColumn:@"houseLong"];
            addressHolder.str_houseNo = [dataArr stringForColumn:@"houseNo"];
            addressHolder.str_houseSide = [dataArr stringForColumn:@"houseSide"];
            addressHolder.str_regionName = [dataArr stringForColumn:@"regionName"];
            addressHolder.str_stateName = [dataArr stringForColumn:@"stateName"];
            addressHolder.str_status = [dataArr stringForColumn:@"status"];
            addressHolder.str_streetName = [dataArr stringForColumn:@"streetName"];
            addressHolder.str_updatedAt = [dataArr stringForColumn:@"updateAt"];
            addressHolder.str_parking_ids = [dataArr stringForColumn:@"parking_ids"];
            
        }
        else
        {
            NSLog(@"error in address table retrieving data");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}

- (void)getParkingFromDatabase:(int) parkingID{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM parkingTable where id  = \"%d\"", parkingID];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            parkingHolder = [Parking new];
            parkingHolder.str_id = [NSNumber numberWithInt:[dataArr intForColumn:@"id"]];
            parkingHolder.str_parking_type = [dataArr stringForColumn:@"parking_type"];
            parkingHolder.str_parking_free_limit = [NSNumber numberWithInt:[dataArr intForColumn:@"parking_limit"]];
            parkingHolder.str_parking_default_time_start = [dataArr stringForColumn:@"parking_default_time_start"];
            parkingHolder.str_parking_default_time_end = [dataArr stringForColumn:@"parking_default_time_end"];
            parkingHolder.str_parking_default_days = [dataArr stringForColumn:@"parking_default_days"];
            parkingHolder.str_parking_restrict_time_start = [dataArr stringForColumn:@"parking_restrict_time_start"];
            parkingHolder.str_parking_restrict_time_end = [dataArr stringForColumn:@"parking_restrict_time_end"];
            parkingHolder.str_parking_sweeping_time_start = [dataArr stringForColumn:@"parking_sweeping_time_start"];
            parkingHolder.str_parking_sweeping_time_end = [dataArr stringForColumn:@"parking_sweeping_time_end"];
            parkingHolder.str_notes = [dataArr stringForColumn:@"notes"];
            parkingHolder.str_update_at = [dataArr stringForColumn:@"update_at"];
        }
        else
        {
            NSLog(@"error in parking table retrieving data");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}

//- (void) getRegionFromDatabase{
//    if (!mrParkDB)
//    {
//        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
//        mrParkDB = [[FMDatabase alloc] initWithPath:path];
//    }
//    
//    NSString *query;
//    
//    query = [NSString stringWithFormat:@"Select * FROM regionTable"];
//    
//    @try
//    {
//        [mrParkDB open];
//        if ([mrParkDB executeQuery:query])
//        {
//            FMResultSet *dataArr = [mrParkDB executeQuery:query];
//            
//            while([dataArr next])
//            {
//                Region *data = [Region new];
//                data.str_region_id = [NSNumber numberWithInt:[dataArr intForColumn:@"region_id"]];
//                data.str_state_id = [NSNumber numberWithInt: [dataArr intForColumn:@"state_id"]];
//                data.str_region_name = [dataArr stringForColumn:@"region_name"];
//                [arr_regionFromDB addObject:data];
//            }
//        }
//        else
//        {
//            NSLog(@"error in region table retrieving data");
//        }
//        [mrParkDB close];
//    }
//    @catch (NSException *e)
//    {
//        NSLog(@"%@",e);
//    }
//}

- (BOOL) isHolidayWithCurrentDate:(NSString*) date{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select count(*) AS count  FROM holidayTable where date = \"%@\"", date];
    
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            
            [dataArr next];
            int count = [[dataArr stringForColumn:@"count"] intValue];
            if (count>=1) {
                return YES;
            }
            else{
                return NO;
            }
        }
        else
        {
            NSLog(@"error in holiday table retrieving data");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}


@end
