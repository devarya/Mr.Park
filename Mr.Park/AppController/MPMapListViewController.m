//
//  MPMapViewController.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPMapListViewController.h"
#import "tempTable.h"

@interface MPMapListViewController ()

@end

@implementation MPMapListViewController
@synthesize map_View, geocoder, tbl_View;
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
    hud = [AryaHUD new];
    [self.view addSubview:hud];
    
    self.map_View.delegate = self;
    self->searchBar.delegate = self;
    
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
    
    ary_ptfp = [NSMutableArray new];
    ary_ptfps = [NSMutableArray new];
    ary_ptlt = [NSMutableArray new];
    ary_ptmp = [NSMutableArray new];
    ary_ptmps = [NSMutableArray new];
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.parkingType isEqual:@"Free parking"]) {
            [ary_ptfp addObject:tpObj];
        }
        if([tpObj.parkingType isEqual:@"Free parking structure"]) {
            [ary_ptfps addObject:tpObj];
        }
        if([tpObj.parkingType isEqual:@"Limited time parking"]) {
            [ary_ptlt addObject:tpObj];
        }
        if([tpObj.parkingType isEqual:@"Metered parking"]) {
            [ary_ptmp addObject:tpObj];
        }
        if([tpObj.parkingType isEqual:@"Metered parking structure"]) {
            [ary_ptmps addObject:tpObj];
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reachabilityHomeStatusChange:)
                                                name:kReachabilityChangedNotification
                                              object:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    currentCoordinate = [userLocation coordinate];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(currentCoordinate, 1000, 1000);
    [self.map_View setRegion:zoomRegion animated:NO];
    currentLocation = userLocation.location;
    
    
    
    
	
    [self checkCurrentRegion];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //[HUD hide];
    if([annotation isKindOfClass:[MPCustomAnnotation class]]) {
        MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc]     initWithAnnotation:annotation reuseIdentifier:@"MPCustomAnnotation"];
        CLLocationCoordinate2D temp = [annotation coordinate];
        newAnnotation.canShowCallout = YES;
        newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        newAnnotation.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter"]];
        //newAnnotation.image = [UIImage imageNamed:@"fp"];
        if([[self getParkingTypeLatitude:temp.latitude Longitude:temp.longitude]  isEqual: @"Free parking"]) {
            newAnnotation.image = [UIImage imageNamed:@"fp"];
        }
        else if([[self getParkingTypeLatitude:temp.latitude Longitude:temp.longitude]  isEqual: @"Free parking structure"]) {
            newAnnotation.image = [UIImage imageNamed:@"fps"];
        }
        else if([[self getParkingTypeLatitude:temp.latitude Longitude:temp.longitude]  isEqual: @"Limited time parking"]) {
            newAnnotation.image = [UIImage imageNamed:@"lt"];
        }
        else if([[self getParkingTypeLatitude:temp.latitude Longitude:temp.longitude]  isEqual: @"Metered parking"]) {
            newAnnotation.image = [UIImage imageNamed:@"mp"];
        }
        else if([[self getParkingTypeLatitude:temp.latitude Longitude:temp.longitude]  isEqual: @"Metered parking structure"]) {
            newAnnotation.image = [UIImage imageNamed:@"mps"];
        }
        return newAnnotation;
    }
    else
        return nil;
    
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MPParkingDetailViewController *dvc = [[MPParkingDetailViewController alloc] initWithNibName:@"MPParkingDetailViewController" bundle:nil];
    destCoordinate = [[view annotation] coordinate];
    destLatitude = destCoordinate.latitude;
    destLongitude = destCoordinate.longitude;
    [self getDestInformationWithLatitude:[NSString stringWithFormat:@"%lf",destLatitude] Longitude:[NSString stringWithFormat:@"%lf",destLongitude]];
    [self.navigationController pushViewController:dvc animated:YES];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (NSString *) getParkingTypeLatitude: (double)lat Longitude: (double) lon {
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.lat doubleValue] == lat && [tpObj.lon doubleValue] == lon) {
            parkingType = tpObj.parkingType;
            break;
        }
    }
    return parkingType;
}

- (void) getDestInformationWithLatitude: (NSString *)lat Longitude: (NSString *) lon {
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.lat isEqual: lat] && [tpObj.lon  isEqual: lon]) {
            destStreetName = tpObj.streetName;
            destAddress = tpObj.fullAddress;
            destParkingType = tpObj.parkingType;
            [[MPDBIntraction databaseInteractionManager] getParkingFromDatabase:[tpObj.parkingID intValue]];
            startTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][1]];
            endTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][1]];
            destParkingTime = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
            restrictStartTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][1]];
            restrictEndTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][1]];
            destRestrictTime = [NSString stringWithFormat:@"%@ - %@", restrictStartTime, restrictEndTime];
            break;
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self->searchBar resignFirstResponder];    
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self->searchBar resignFirstResponder];
    
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(currentCoordinate, 2000, 2000);
    [self.map_View setRegion:zoomRegion animated:NO];
    
    //Instantiate geolocation
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:self->searchBar.text completionHandler:^(NSArray *placemarks, NSError *error){
        
        //Mark location and center
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        //Drop pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate: newLocation];
        [annotation setTitle:self->searchBar.text];  // you can set the subtitle, too
//        [self.map_View addAnnotation:annotation];
        
        //scroll to search result
        MKMapRect mr = [self.map_View visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width *0.5;
        mr.origin.y = pt.y - mr.size.height *0.25;
        [self.map_View setVisibleMapRect:mr animated:YES];
    }];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showDetails"]) {
        //DetailViewController *dtv = [segue destinationViewController];
        NSInteger tagIndex = [(UIButton *)sender tag];
        tempTable* tpObj = tempTableArray[tagIndex];
        destCoordinate = CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue]);
        destLatitude = destCoordinate.latitude;
        destLongitude = destCoordinate.longitude;
        destStreetName = tpObj.streetName;
        destAddress = tpObj.fullAddress;
        destParkingType = tpObj.parkingType;
        [[MPDBIntraction databaseInteractionManager] getParkingFromDatabase:[tpObj.parkingID intValue]];
        NSString *startTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][1]];
        NSString *endTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][1]];
        destParkingTime = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        NSString *restrictStartTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][1]];
        NSString *restrictEndTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][1]];
        destRestrictTime = [NSString stringWithFormat:@"%@ - %@", restrictStartTime, restrictEndTime];
    }
    NSLog(@"%@", destParkingType);
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
    [self.map_View removeAnnotations:[self.map_View annotations]];
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.parkingType isEqual:@"Free parking"]) {
            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
            [map_View addAnnotation:pin];
        }
    }
    countList = FREE_PARKING;
    [tbl_View reloadData];
}
- (IBAction)btn_FreeParkingStructure:(id)sender {
    [self.map_View removeAnnotations:[self.map_View annotations]];
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.parkingType isEqual:@"Free parking structure"]) {
            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
            [map_View addAnnotation:pin];
        }
    }
    countList = FREE_PARKING_STRUCTURE;
    [tbl_View reloadData];
}
- (IBAction)btn_LimitParking:(id)sender {
    [self.map_View removeAnnotations:[self.map_View annotations]];
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.parkingType isEqual:@"Limited time parking"]) {
            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
            [map_View addAnnotation:pin];
        }
    }
    countList = LIMITED_TIME_PARKING;
    [tbl_View reloadData];
}
- (IBAction)btn_MeterParking:(id)sender {
    [self.map_View removeAnnotations:[self.map_View annotations]];
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.parkingType isEqual:@"Metered parking"]) {
            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
            [map_View addAnnotation:pin];
        }
    }
    countList = METERED_PARKING;
    [tbl_View reloadData];
}
- (IBAction)btn_MeterParkingStructure:(id)sender{
    [self.map_View removeAnnotations:[self.map_View annotations]];
    for(tempTable* tpObj in tempTableArray) {
        if([tpObj.parkingType isEqual:@"Metered parking structure"]) {
            MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
            [map_View addAnnotation:pin];
        }
    }
    countList = METERED_PARKING_STRUCTURE;
    [tbl_View reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(countList == FREE_PARKING){
        return [ary_ptfp count];}
    else if(countList == FREE_PARKING_STRUCTURE)
        return [ary_ptfps count];
    else if(countList == LIMITED_TIME_PARKING)
        return [ary_ptlt count];
    else if(countList == METERED_PARKING)
        return [ary_ptmp count];
    else if(countList == METERED_PARKING_STRUCTURE)
        return [ary_ptmps count];
    else
        return [tempTableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(countList == FREE_PARKING) {
        NSString *identifier = nil;
        tempTable *temp =[ary_ptfp objectAtIndex:indexPath.row];
        NSString *streetName = temp.streetName;
        NSString *address = temp.fullAddress;
        NSString *distance = [NSString stringWithFormat:@"%@",temp.lat];
        if (indexPath.row % 2 == 0) {
            identifier = @"cellDark";
        }
        else {
            identifier = @"cellLight";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if([temp.parkingType isEqual:@"Free parking"]) {
            cell.imageView.image = [UIImage imageNamed:@"fp"];
            UILabel *cellLabel;
            cellLabel = (UILabel *)[cell viewWithTag:1];
            cellLabel.text = streetName;
            cellLabel = (UILabel *)[cell viewWithTag:2];
            cellLabel.text = address;
            cellLabel = (UILabel *)[cell viewWithTag:3];
            cellLabel.text = distance;
        }
        return cell;
    }
    else if(countList == FREE_PARKING_STRUCTURE) {
        NSString *identifier = nil;
        tempTable *temp =[ary_ptfps objectAtIndex:indexPath.row];
        NSString *streetName = temp.streetName;
        NSString *address = temp.fullAddress;
        NSString *distance = [NSString stringWithFormat:@"%@",temp.lat];
        if (indexPath.row % 2 == 0) {
            identifier = @"cellDark";
        }
        else {
            identifier = @"cellLight";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if([temp.parkingType isEqual:@"Free parking structure"]) {
            cell.imageView.image = [UIImage imageNamed:@"ic_fps@2x.png"];
            UILabel *cellLabel;
            cellLabel = (UILabel *)[cell viewWithTag:1];
            cellLabel.text = streetName;
            cellLabel = (UILabel *)[cell viewWithTag:2];
            cellLabel.text = address;
            cellLabel = (UILabel *)[cell viewWithTag:3];
            cellLabel.text = distance;
        }
        return cell;
    }
    else if(countList == LIMITED_TIME_PARKING) {
        NSString *identifier = nil;
        tempTable *temp =[ary_ptlt objectAtIndex:indexPath.row];
        NSString *streetName = temp.streetName;
        NSString *address = temp.fullAddress;
        NSString *distance = [NSString stringWithFormat:@"%@",temp.lat];
        if (indexPath.row % 2 == 0) {
            identifier = @"cellDark";
        }
        else {
            identifier = @"cellLight";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if([temp.parkingType isEqual:@"Limited time parking"]) {
            cell.imageView.image = [UIImage imageNamed:@"lt"];
            UILabel *cellLabel;
            cellLabel = (UILabel *)[cell viewWithTag:1];
            cellLabel.text = streetName;
            cellLabel = (UILabel *)[cell viewWithTag:2];
            cellLabel.text = address;
            cellLabel = (UILabel *)[cell viewWithTag:3];
            cellLabel.text = distance;
        }
        return cell;
    }
    else if(countList == METERED_PARKING) {
        NSString *identifier = nil;
        tempTable *temp =[ary_ptmp objectAtIndex:indexPath.row];
        NSString *streetName = temp.streetName;
        NSString *address = temp.fullAddress;
        NSString *distance = [NSString stringWithFormat:@"%@",temp.lat];
        if (indexPath.row % 2 == 0) {
            identifier = @"cellDark";
        }
        else {
            identifier = @"cellLight";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if([temp.parkingType isEqual:@"Metered parking"]) {
            cell.imageView.image = [UIImage imageNamed:@"mp"];
            UILabel *cellLabel;
            cellLabel = (UILabel *)[cell viewWithTag:1];
            cellLabel.text = streetName;
            cellLabel = (UILabel *)[cell viewWithTag:2];
            cellLabel.text = address;
            cellLabel = (UILabel *)[cell viewWithTag:3];
            cellLabel.text = distance;
        }
        return cell;
    }
    else if(countList == METERED_PARKING_STRUCTURE) {
        NSString *identifier = nil;
        tempTable *temp =[ary_ptmps objectAtIndex:indexPath.row];
        NSString *streetName = temp.streetName;
        NSString *address = temp.fullAddress;
        NSString *distance = [NSString stringWithFormat:@"%@",temp.lat];
        if (indexPath.row % 2 == 0) {
            identifier = @"cellDark";
        }
        else {
            identifier = @"cellLight";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if([temp.parkingType isEqual:@"Metered parking structure"]) {
            cell.imageView.image = [UIImage imageNamed:@"mps"];
            UILabel *cellLabel;
            cellLabel = (UILabel *)[cell viewWithTag:1];
            cellLabel.text = streetName;
            cellLabel = (UILabel *)[cell viewWithTag:2];
            cellLabel.text = address;
            cellLabel = (UILabel *)[cell viewWithTag:3];
            cellLabel.text = distance;
        }
        return cell;
    }
    else {
        NSString *identifier = nil;
        tempTable *temp =[tempTableArray objectAtIndex:indexPath.row];
        NSString *streetName = temp.streetName;
        NSString *address = temp.fullAddress;
        NSString *distance = [NSString stringWithFormat:@"%@",temp.lat];
        if (indexPath.row % 2 == 0) {
            identifier = @"cellDark";
        }
        else {
            identifier = @"cellLight";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if([temp.parkingType isEqual:@"Free parking"])
            cell.imageView.image = [UIImage imageNamed:@"fp"];
        else if([temp.parkingType isEqual:@"Free parking structure"])
            cell.imageView.image = [UIImage imageNamed:@"fps"];
        else if([temp.parkingType isEqual:@"Limited time parking"])
            cell.imageView.image = [UIImage imageNamed:@"lt"];
        else if([temp.parkingType isEqual:@"Metered parking"])
            cell.imageView.image = [UIImage imageNamed:@"mp"];
        else if([temp.parkingType isEqual:@"Metered parking structure"])
            cell.imageView.image = [UIImage imageNamed:@"mps"];
        UILabel *cellLabel;
        cellLabel = (UILabel *)[cell viewWithTag:1];
        cellLabel.text = streetName;
        cellLabel = (UILabel *)[cell viewWithTag:2];
        cellLabel.text = address;
        cellLabel = (UILabel *)[cell viewWithTag:3];
        cellLabel.text = distance;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark TABLE_VIEW DELEGATE AND DATASOURCE

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [self performSegueWithIdentifier:@"segue_tblDetail" sender:self];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)createTempDBWithRegionName: (NSString*)region_arr{
    NSArray *region_part = [region_arr componentsSeparatedByString:@", "];
    NSString *format = @"regionName = \"";
    NSMutableString *queryName = [NSMutableString new];
    for(NSString * rName in region_part){
        if ([queryName length] !=0) {
            [queryName appendString:@" and "];
        }
            [queryName appendString:format];
            [queryName appendString:rName];
            [queryName appendString:@"\""];
    }

    
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    NSString *query;
    
    query = [NSString stringWithFormat:@"Select * FROM addressTable where %@", queryName];
    //query = [NSString stringWithFormat:@"Select * FROM addressTable where houseLat in 33.8 between 33.85];

    //query = [NSString stringWithFormat:@"Select * FROM addressTable where address_id < 22"];
    
    
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
                tempObj.lat = [NSNumber numberWithDouble:[[dataArr stringForColumn:@"houseLat"] doubleValue]];
                NSLog(@"%f", [tempObj.lat doubleValue]);
                tempObj.lon = [NSNumber numberWithDouble:[[dataArr stringForColumn:@"houseLong"] doubleValue]];
                tempObj.parkingID = [NSNumber numberWithInt:[dataArr intForColumn:@"parking_id"]];
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
        if([self isHolidayWithCurrentDate:strDate]) {
            tp.parkingType = @"Free parking";
        }
        else {
            [[MPDBIntraction databaseInteractionManager] getParkingFromDatabase:[tp.parkingID intValue]];
            if([self isSwappingWithHour:currentHour andMinute:currentMinute andParkingType:[tp.parkingID intValue]]) {
                tp.parkingType = @"No Parking";
            }
            else {
                BOOL isDefaultDay = false;
                NSArray *arr_days = [parkingHolder.str_parking_default_days componentsSeparatedByString:@","];
                for(NSString *day in arr_days) {
                    if([weekday isEqual:day]) {
                        isDefaultDay = true;
                        break;
                    }
                }
                if (isDefaultDay) {
                    d_start =[[parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][0] integerValue]*60 + [[parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][0] integerValue];
                    
                    d_end =[[parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][0] integerValue]*60 + [[parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][0] integerValue];
                    
                    r_start =[[parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][0] integerValue]*60 + [[parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][0] integerValue];
                    
                    r_end =[[parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][0] integerValue]*60 + [[parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][0] integerValue];
                    
                    if(([currentHour integerValue]*60+[currentMinute integerValue])> d_start && ([currentHour integerValue]*60+[currentMinute integerValue]) < d_end) {
                        if(([currentHour integerValue]*60+[currentMinute integerValue]) > r_start && ([currentHour integerValue]*60+[currentMinute integerValue]) < r_end) {
                            tp.parkingType = @"No Parking";
                        }
                        else {
                            tp.parkingType = parkingHolder.str_parking_type;
                        }
                    }
                    else {
                        tp.parkingType = parkingHolder.str_parking_type;
                    }
                }
                else{
                    tp.parkingType = @"Free parking";
                }
            }
        }
    }
    if ((currentCoordinate.latitude != 0.0) && (currentCoordinate.longitude != 0.0)) {
        static dispatch_once_t centerMapFirstTime;
		dispatch_once(&centerMapFirstTime, ^{
			[self.map_View setCenterCoordinate:currentCoordinate animated:NO];
		});
        for(tempTable* tpObj in tempTableArray) {
            if(![tpObj.parkingType isEqual:@"No Parking"]){
                MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:tpObj.streetName Subtitle:tpObj.fullAddress Location:CLLocationCoordinate2DMake([tpObj.lat doubleValue], [tpObj.lon doubleValue])];
                [map_View addAnnotation:pin];
            }
        }
    }
    [hud hide];
}

- (BOOL) isSwappingWithHour:(NSString *) currentHour andMinute:(NSString *) currentMinute andParkingType: (int) parkingType {
    c_time =[currentHour integerValue]*60 + [currentMinute integerValue];
    [[MPDBIntraction databaseInteractionManager] getParkingFromDatabase:parkingType];
    
    s_start =[[parkingHolder.str_parking_sweeping_time_start componentsSeparatedByString:@":"][0] integerValue]*60 + [[parkingHolder.str_parking_sweeping_time_start componentsSeparatedByString:@":"][0] integerValue];
    
    s_end =[[parkingHolder.str_parking_sweeping_time_end componentsSeparatedByString:@":"][0] integerValue]*60 + [[parkingHolder.str_parking_sweeping_time_end componentsSeparatedByString:@":"][0] integerValue];
    if(c_time > s_start && c_time < s_end)
        return true;
    else
        return false;
}


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

-(void)checkCurrentRegion{
    
    NSMutableString * region_arr = [NSMutableString new];
    NSMutableArray * point_arr = [NSMutableArray new];
    
    CoordinatePoint * cp = [CoordinatePoint new];
    
    cp.lat = [NSString stringWithFormat:@"%f", currentCoordinate.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", currentCoordinate.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D neCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude + MILEINCOORDINATE, currentCoordinate.longitude - MILEINCOORDINATE);
    cp.lat = [NSString stringWithFormat:@"%f", neCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", neCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D swCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude - MILEINCOORDINATE, currentCoordinate.longitude + MILEINCOORDINATE);
    cp.lat = [NSString stringWithFormat:@"%f", swCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", swCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D nwCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude + MILEINCOORDINATE, currentCoordinate.longitude + MILEINCOORDINATE);
    cp.lat = [NSString stringWithFormat:@"%f", nwCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", nwCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D seCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude - MILEINCOORDINATE, currentCoordinate.longitude - MILEINCOORDINATE);
    cp.lat = [NSString stringWithFormat:@"%f", seCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", seCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D sCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude - MILEINCOORDINATE, currentCoordinate.longitude);
    cp.lat = [NSString stringWithFormat:@"%f", sCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", sCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D eCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude - MILEINCOORDINATE);
    cp.lat = [NSString stringWithFormat:@"%f", eCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", eCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D nCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude + MILEINCOORDINATE, currentCoordinate.longitude);
    cp.lat = [NSString stringWithFormat:@"%f", nCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", nCoord.longitude];
    [point_arr addObject:cp];
    cp = [CoordinatePoint new];
    CLLocationCoordinate2D wCoord = CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude + MILEINCOORDINATE);
    cp.lat = [NSString stringWithFormat:@"%f", wCoord.latitude];
    cp.lon = [NSString stringWithFormat:@"%f", wCoord.longitude];
    [point_arr addObject:cp];
    
    //dispatch_semaphore_t fd_sema = dispatch_semaphore_create(0);
//    CoordinatePoint *point = [point_arr objectAtIndex:0];
//    CLGeocoder *ceo = [[CLGeocoder alloc]init];
//    CLLocation *loc =[[CLLocation alloc]initWithLatitude:[point.lat doubleValue] longitude:[point.lon doubleValue]];;
//        [ceo reverseGeocodeLocation: loc completionHandler:
//     ^(NSArray *placemarks, NSError *error) {
//         CLPlacemark *pm = [placemarks objectAtIndex:0];
//        // dispatch_semaphore_signal(fd_sema);
//         if ([region_arr rangeOfString:pm.subAdministrativeArea].location == NSNotFound) {
//             [region_arr appendString:pm.subAdministrativeArea];
//             [region_arr appendString:@", "];
//             
//             NSLog(@"%@", region_arr);
//         }
//     }];
    //dispatch_semaphore_wait(fd_sema, DISPATCH_TIME_FOREVER);
    [hud show];
    [self.view bringSubviewToFront:hud];
//    dispatch_sync(dispatch_get_main_queue(), ^
//                   {
                       CLGeocoder *ceo;
                       CLLocation *loc;
    region_arr = [NSMutableString new];
    for (CoordinatePoint *point in point_arr) {
        ceo = [[CLGeocoder alloc]init];
        loc = [[CLLocation alloc]initWithLatitude:[point.lat doubleValue] longitude:[point.lon doubleValue]];
        [ceo reverseGeocodeLocation: loc completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             CLPlacemark *pm = [placemarks objectAtIndex:0];
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                if ([region_arr rangeOfString:pm.subAdministrativeArea].location == NSNotFound) {
                                    if([region_arr length] !=0 ){
                                        [region_arr appendString:@", "];
                                    }
                                    [region_arr appendString:pm.subAdministrativeArea];
                                    NSLog(@"%@", region_arr);
                                    [self checkLocalDBforReigon:region_arr];
                                }
                            });
         }];
    }
    //                   }
    //                   );

    
//
//    dispatch_semaphore_signal(fd_sema);
   // [self checkLocalDBforReigon:region_arr];
//    [self createTempDBWithRegionName:region_arr];
}



-(void)checkLocalDBforReigon: (NSString*) region_arr{
    //NSString *newRe = @"Orange";
    NSArray *region_part = [region_arr componentsSeparatedByString:@", "];
    NSString *query;
    NSMutableArray *region_id_arr = [NSMutableArray new];

    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    
    [mrParkDB open];
    
    for (int i=0; i<region_part.count; i++) {
        
        query = [NSString stringWithFormat:@"select * from regionTable where region_name = \"%@\"", region_part[i]];
        @try
        {
            if ([mrParkDB executeQuery:query])
            {
                FMResultSet *dataArr = [mrParkDB executeQuery:query];
                [dataArr next];
                NSNumber *rID = [NSNumber numberWithInt:[dataArr intForColumn:@"region_id"]];
                if ([rID isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if (isSupport == YES) {
                        isSupport = NO;
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [MPGlobalFunction showAlert:MESSAGE_REGION_NOT_FOUND];
                                   });
                    }
                    [hud hide];
                }else{
                    [region_id_arr addObject:rID];
                    query = [NSString stringWithFormat:@"select count(*) from addressUpdate where region_id = \"%@\"", rID];
                    @try
                    {
                        if ([mrParkDB executeQuery:query])
                        {
                            FMResultSet *dataArr = [mrParkDB executeQuery:query];
                            [dataArr next];
                            int count = [dataArr intForColumn:@"count(*)"];
                            if (count == 0) {
                                NSMutableDictionary * Info = [NSMutableDictionary new];
                                [[MPRestIntraction sharedManager] requestAddressCall:Info andRegionID:rID adUpdateTime:@"2000-01-01 00:00:00"];
                            }
                            [self createTempDBWithRegionName:region_arr];
                            
                        }
                        else
                        {
                            NSLog(@"error in select addressUpdate where region_id = %@", rID);
                        }
                    }
                    @catch (NSException *e)
                    {
                        NSLog(@"%@",e);
                    }
                }
                
            }
            else
            {
                NSLog(@"error in check regionTable");
            }
            
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
            [mrParkDB close];
        }
    }
    [mrParkDB close];
    
}

-(void)reachabilityHomeStatusChange:(NSNotification*)notification{
    
    if([MPGlobalFunction isConnectedToInternet])
    {
        
        
    }else{
        
    }
    
}



@end
