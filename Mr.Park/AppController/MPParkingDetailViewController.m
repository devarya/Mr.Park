//
//  MPMapListViewController.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPParkingDetailViewController.h"

@interface MPParkingDetailViewController ()

@end

@implementation MPParkingDetailViewController
@synthesize  map_View, streetNameText, addressText;

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
    self.map_View.delegate = self;
    [self.map_View setShowsUserLocation:YES];
    isMapView = YES;
    MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:destStreetName Subtitle:destAddress Location:destCoordinate];
    [map_View addAnnotation:pin];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(destCoordinate, 2000, 2000);
    [self.map_View setRegion:zoomRegion animated:YES];
    [self.map_View setCenterCoordinate:destCoordinate animated:YES];
    streetNameText.text = destStreetName;
    addressText.text = destAddress;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IB_ACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //[HUD hide];
    if([annotation isKindOfClass:[MPCustomAnnotation class]]) {
        MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc]     initWithAnnotation:annotation reuseIdentifier:@"MPCustomAnnotation"];
        newAnnotation.canShowCallout = YES;
        newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        newAnnotation.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter"]];
        //newAnnotation.image = [UIImage imageNamed:@"fp"];
        if([destParkingType isEqual: @"Free parking"]) {
            newAnnotation.image = [UIImage imageNamed:@"fp"];
        }
        else if([destParkingType isEqual: @"Free parking structure"]) {
            newAnnotation.image = [UIImage imageNamed:@"fps"];
        }
        else if([destParkingType isEqual: @"Limited time parking"]) {
            newAnnotation.image = [UIImage imageNamed:@"lt"];
        }
        else if([destParkingType isEqual: @"Metered parking"]) {
            newAnnotation.image = [UIImage imageNamed:@"mp"];
        }
        else if([destParkingType isEqual: @"Metered parking structure"]) {
            newAnnotation.image = [UIImage imageNamed:@"mps"];
        }
        return newAnnotation;
    }
    else
        return nil;
}
- (IBAction)btn_Facebook:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [slComposerSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/eadbook/id790237067?ls=1&mt=8"]];
        [slComposerSheet setInitialText:@"Please download this app."];
        
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSLog(@"start completion block");
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Link Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   UIAlertView *alert_fb = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert_fb show];
                               });
            }
        }];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't share application link right now, make sure your device has an internet connection and you have to  login from setting."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (IBAction)checkInButton:(UIButton *)sender {
    alert = [[UIAlertView alloc]initWithTitle:@"Parking Time Set Up" message:@"Alarm has added to the Notification." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"30 Minutes", @"1 Hour", @"2 Hours", @"3Hours", @"4Hours", @"Overnight", nil];
    [alert show];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 30 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 30 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"30 minutes later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
            notification.alertBody = [NSString stringWithFormat:@"%@", destAddress];
            notification.soundName = @"7f_in-a-hurry-song.mp3";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];

            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
    if(buttonIndex == 2) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 60 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 60 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"1 hour later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
            notification.alertBody = [NSString stringWithFormat:@"%@", destAddress];
            notification.soundName = @"7f_in-a-hurry-song.mp3";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
    if(buttonIndex == 3) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 120 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 120 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"2 hours later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:120*60];
            notification.alertBody = [NSString stringWithFormat:@"%@", destAddress];
            notification.soundName = @"7f_in-a-hurry-song.mp3";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
    if(buttonIndex == 4) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 180 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 180 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"3 hours later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:180*60];
            notification.alertBody = [NSString stringWithFormat:@"%@", destAddress];
            notification.soundName = @"7f_in-a-hurry-song.mp3";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
    if(buttonIndex == 5) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 240 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 240 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"4 hours later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:240*60];
            notification.alertBody = [NSString stringWithFormat:@"%@", destAddress];
            notification.soundName = @"7f_in-a-hurry-song.mp3";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
    if(buttonIndex == 6) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 480 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 480 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"2 hour later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:480*60];
            notification.alertBody = [NSString stringWithFormat:@"%@", destAddress];
            notification.soundName = @"7f_in-a-hurry-song.mp3";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
}
- (IBAction)btn_Twitter:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposerSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/eadbook/id790237067?ls=1&mt=8"]];
        [slComposerSheet setInitialText:@"Please download this app."];
        
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSLog(@"start completion block");
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Application Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   
                                   
                                   UIAlertView *alert_tw = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert_tw show];
                                   
                               });
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't share application link right now, make sure your device has an internet connection and you have to  login from setting."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (IBAction)btn_Email:(id)sender{
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)btn_Favorite:(id)sender {
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    NSString *query;
    query = [NSString stringWithFormat:@"Select * from addressTable where address_id = %@", destAddressID];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            [dataArr next];
            flistHolder = [FavoriteList new];
            addressHolder = [AddressDB new];
            
            flistHolder.int_addId = [NSNumber numberWithInt:[dataArr intForColumn:@"address_id"]];
            flistHolder.str_cityName = [dataArr stringForColumn:@"city_name"];
            flistHolder.str_createdId = [dataArr stringForColumn:@"created_at"];
            flistHolder.str_houseFullAddress = [dataArr stringForColumn:@"houseFullAddress"];
            flistHolder.double_houseLat = [NSNumber numberWithDouble:[dataArr doubleForColumn:@"houseLat"]];
            flistHolder.double_houseLong = [NSNumber numberWithDouble:[dataArr doubleForColumn:@"houseLong"]];
            flistHolder.str_houseNo = [dataArr stringForColumn:@"houseNo"];
            flistHolder.str_houseSide = [dataArr stringForColumn:@"houseSide"];
            flistHolder.str_regionName = [dataArr stringForColumn:@"regionName"];
            flistHolder.str_stateName = [dataArr stringForColumn:@"stateName"];
            flistHolder.str_status = [dataArr stringForColumn:@"status"];
            flistHolder.str_streetName = [dataArr stringForColumn:@"streetName"];
            flistHolder.int_parking_id = [NSNumber numberWithInt:[dataArr intForColumn:@"parking_id"]];
        }
        else
        {
            NSLog(@"error in selection from address table to favorite list");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    query=[NSString stringWithFormat:@"insert into favoriteTable(address_id, city_name, created_at, houseFullAddress, houseLat, houseLong, houseNo, houseSide, regionName, stateName, status, streetName, parking_ids) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\")",flistHolder.int_addId, flistHolder.str_cityName, flistHolder.str_createdId, flistHolder.str_houseFullAddress, flistHolder.double_houseLat, flistHolder.double_houseLong, flistHolder.str_houseNo, flistHolder.str_houseSide, flistHolder.str_regionName, flistHolder.str_stateName, flistHolder.str_status, flistHolder.str_streetName, flistHolder.int_parking_id];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeUpdate:query])
        {
            NSLog(@"successfully inserted address_id: %@ into favorite table", destAddressID);
            [MPGlobalFunction showAlert:MESSAGE_ADD_FAVORITE];
        }
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
        [MPGlobalFunction showAlert:MESSAGE_ADD_FAVORITE_FAIL];
    }
    @finally{
        [mrParkDB close];
    }

}

#pragma mark TABLE_VIEW DELEGATE AND DATASOURCE

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        NSString *availableTime = destParkingTime;
        NSString *parkingType = destParkingType;
        
        NSString *cellIdentifier = @"detailCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UILabel *cellLabel;
        cellLabel = (UILabel *)[cell viewWithTag:1];
        cellLabel.text = availableTime;
        cellLabel = (UILabel *)[cell viewWithTag:2];
        cellLabel.text = parkingType;
        return cell;
    }
    else {
        NSString *availableTime = destRestrictTime;
        NSString *parkingType = @"No parking";
        
        NSString *cellIdentifier = @"detailCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UILabel *cellLabel;
        cellLabel = (UILabel *)[cell viewWithTag:1];
        cellLabel.text = availableTime;
        cellLabel = (UILabel *)[cell viewWithTag:2];
        cellLabel.text = parkingType;
        return cell;
    }
}

- (IBAction)navButton:(UIButton *)sender {
    NSLog(@"%lf", destLatitude);
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        // Create an MKMapItem to pass to the Maps app
        //CLLocation *ad = [[CLLocation alloc] initWithLatitude:mvc.destCoordinate.latitude longitude:mvc.destCoordinate.longitude];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(destLatitude, destLongitude);
        MKPlacemark *placemarks = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                        addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemarks];
        [mapItem setName: @"terminate"];
        // Pass the map item to the Maps app
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

@end
