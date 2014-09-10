//
//  MPFavoritesViewController.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPFavoritesViewController.h"

@interface MPFavoritesViewController ()

@end

@implementation MPFavoritesViewController

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
    [[MPDBIntraction databaseInteractionManager] getFavoriteListFromDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TABLE_VIEW DELEGATE AND DATASOURCE

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 62;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return favoriteListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"favCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    FavoriteList *flist = [FavoriteList new];
        flist = [favoriteListArray objectAtIndex:indexPath.row];
    NSString *fullAddress = [NSString stringWithFormat:@"%@ %@, %@", flist.str_houseNo, flist.str_houseFullAddress, flist.str_cityName];
    cell.textLabel.text = fullAddress;
    
    return cell;
}


//-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle == UITableViewCellEditingStyleDelete){
//        [self deleteFavWith:indexPath.row];
//        [favoriteListArray removeObjectAtIndex:indexPath.row];
//        [tableView reloadData];
//    }
//}
#pragma mark - IB_ACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDelete:(id)sender {
    
//    [numbers removeObjectAtIndex:indexPath.row];
//    [favoritesTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showDetails"]) {
        //DetailViewController *dtv = [segue destinationViewController];
        NSInteger tagIndex = [(UIButton *)sender tag];
        FavoriteList *flObj = favoriteListArray[tagIndex];
        destCoordinate = CLLocationCoordinate2DMake([flObj.double_houseLat doubleValue], [flObj.double_houseLong doubleValue]);
        destAddressID = [NSString stringWithFormat:@"%@", flObj.int_addId];
        destLatitude = destCoordinate.latitude;
        destLongitude = destCoordinate.longitude;
        destStreetName = flObj.str_streetName;
        destAddress = flObj.str_houseFullAddress;
        destParkingType = [[MPDBIntraction databaseInteractionManager] getParkingTypeWithID:[flObj.int_addId integerValue]];
        [[MPDBIntraction databaseInteractionManager] getParkingFromDatabase:[flObj.int_parking_id integerValue]];
        NSString *startTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_default_time_start componentsSeparatedByString:@":"][1]];
        NSString *endTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_default_time_end componentsSeparatedByString:@":"][1]];
        destParkingTime = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        NSString *restrictStartTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_restrict_time_start componentsSeparatedByString:@":"][1]];
        NSString *restrictEndTime = [NSString stringWithFormat:@"%@:%@", [parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][0], [parkingHolder.str_parking_restrict_time_end componentsSeparatedByString:@":"][1]];
        destRestrictTime = [NSString stringWithFormat:@"%@ - %@", restrictStartTime, restrictEndTime];
    }
    NSLog(@"%@", destParkingType);
}

//-(void)deleteFavWith:(int)row{
//    
//    FavoriteList *deleteItem = [favoriteListArray objectAtIndex:row];
//    NSString* query=[NSString stringWithFormat:@"delete from favoriteTable where address_id = %@", deleteItem.int_addId];
//    @try
//    {
//        [mrParkDB open];
//        if ([mrParkDB executeQuery:query])
//        {
//            NSLog(@"successfully delete address_id: %@ from favorite table", deleteItem.int_addId);
//        }
//    }
//    @catch (NSException *e)
//    {
//        NSLog(@"%@",e);
//    }
//    @finally{
//        [mrParkDB close];
//    }
//}


@end
