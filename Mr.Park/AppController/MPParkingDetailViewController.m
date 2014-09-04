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
        CLLocationCoordinate2D temp = [annotation coordinate];
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
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
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
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
    }
    if(buttonIndex == 6) {
        if([currentHour intValue]*60 + [currentMinute intValue] + 120 > [restrictStartTime intValue] && [currentHour intValue]*60 + [currentMinute intValue] + 120 < [restrictEndTime intValue]) {
            UIAlertView *subAlert = [[UIAlertView alloc]initWithTitle:@"Setting failed!" message:@"2 hour later is swapping time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [subAlert show];
        }
        else {
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
                                   
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                                   
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


- (IBAction)checkInButton:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Parking Time Set Up" message:@"Alarm has added to the Notification." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"30 Minutes", @"1 Hour", @"2 Hours", @"4Hours", @"Overnight", @"Default", nil];
    [alert show];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSLog(@"aaa");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thank you!" message:@"Your reminder is setted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}



@end
