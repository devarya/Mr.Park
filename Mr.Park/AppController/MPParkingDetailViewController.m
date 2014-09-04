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
    MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:@"streetName" Subtitle:@"fullAddress" Location:destCoordinate];
    [map_View addAnnotation:pin];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(currentCoordinate, 2000, 2000);
    [self.map_View setRegion:zoomRegion animated:YES];
    [self.map_View setCenterCoordinate:currentCoordinate animated:YES];
    streetNameText.text = destStreetName;
    addressText.text = destAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Parking Reminder" message:@"Alarm has added to the Notification." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
