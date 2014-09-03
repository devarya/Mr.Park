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
    isMapView = YES;
    MPCustomAnnotation *pin = [[MPCustomAnnotation alloc] initWithTitle:@"streetName" Subtitle:@"fullAddress" Location:destCoordinate];
    [map_View addAnnotation:pin];
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(destCoordinate, 2000, 2000);
    [self.map_View setRegion:zoomRegion animated:YES];
    [self.map_View setCenterCoordinate:destCoordinate animated:YES];
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

#pragma mark TABLE_VIEW DELEGATE AND DATASOURCE

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *availableTime = @"12PM - 3PM";
    NSString *parkingType = @"Free Parking";
    
    NSString *cellIdentifier = @"detailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *cellLabel;
    cellLabel = (UILabel *)[cell viewWithTag:1];
    cellLabel.text = availableTime;
    cellLabel = (UILabel *)[cell viewWithTag:2];
    cellLabel.text = parkingType;
    return cell;
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
