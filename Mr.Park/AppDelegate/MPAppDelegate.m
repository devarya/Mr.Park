//
//  MPAppDelegate.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPAppDelegate.h"
#import "MPMapListViewController.h"

@implementation MPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isSupport = YES;
    isUpdate = NO;
    isSeverResponse = YES;
    [self getCurrentDateAndTime];
    [self checkUpdate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:now] capitalizedString];
    weekday = dayString;
    UITextField *txtField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [txtField becomeFirstResponder];
    [self.window addSubview:txtField];
    [txtField removeFromSuperview];
    txtField = nil;
    
    UIImageView *launchView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    launchView.image = [UIImage imageNamed:@"Default.png"];
    UIViewController *rootViewCtr = [[UIViewController alloc]init];
    rootViewCtr.view.frame = [UIScreen mainScreen].bounds;
    [rootViewCtr.view addSubview:launchView];
    self.window.rootViewController = rootViewCtr;
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    hostReachable = [Reachability reachabilityWithHostName: @"www.google.com"] ;
    [hostReachable startNotifier];
    return YES;
}
-(void)startMP{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:[NSBundle mainBundle]];
    MPMapListViewController *mapViewController = (MPMapListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mapViewCtr"];
//    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:mapViewController];
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];

   self.window.rootViewController = mapViewController;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)checkUpdate{
    NSMutableDictionary *updateDic = [NSMutableDictionary new];
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    NSString *query;
    query = [NSString stringWithFormat:@"Select * from updateTable"];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            updateArray = [NSMutableArray new];
            while ([dataArr next]){
                [updateDic setValue:[dataArr stringForColumn:@"updated_at"] forKey:[dataArr stringForColumn:@"tableName"]];
            }
        }
        else
        {
            NSLog(@"error in insertation");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    if ([MPUtils isConnectedToInternet]) {
        NSMutableDictionary * parkingInfo = [NSMutableDictionary new];
        [[MPRestIntraction sharedManager] requestParkingCall:parkingInfo withUpdate:[updateDic valueForKey: @"parkingTable"]];
        NSMutableDictionary * regionInfo = [NSMutableDictionary new];
        [[MPRestIntraction sharedManager] requestRegionCall:regionInfo withUpdate:[updateDic valueForKey: @"regionTable"]];
        NSMutableDictionary * holidayInfo = [NSMutableDictionary new];
        [[MPRestIntraction sharedManager] requestHolidayCall:holidayInfo withUpdate:[updateDic valueForKey: @"holidayTable"]];
        NSMutableDictionary *info= [NSMutableDictionary new];
        [self requestAddressControlCall:info];
    }
    else{
        
        [MPGlobalFunction showAlert:MESSAGE_NET_NOT_AVAILABLE];
        
        [self performSelector:@selector(startMP) withObject:nil afterDelay:1];
    }
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)requestAddressControlCall:(NSMutableDictionary*) info{
    if (!mrParkDB)
    {
        NSString*path = [[MPDBIntraction databaseInteractionManager] getDatabasePathFromName:DBname];
        mrParkDB = [[FMDatabase alloc] initWithPath:path];
    }
    NSString *query;
    query = [NSString stringWithFormat:@"Select * from addressUpdate"];
    @try
    {
        [mrParkDB open];
        if ([mrParkDB executeQuery:query])
        {
            FMResultSet *dataArr = [mrParkDB executeQuery:query];
            addressControlArray = [NSMutableArray new];
            while ([dataArr next]){
                adUCHolder = [AddressUpdateControl new];
                adUCHolder.int_region_id = [NSNumber numberWithInt:[dataArr intForColumn:@"region_id"]];
                adUCHolder.str_update_at = [dataArr stringForColumn:@"update_at"];
                adUCHolder.str_region_name = [dataArr stringForColumn:@"region_name"];
                [addressControlArray addObject:adUCHolder];
            }
        }
        else
        {
            NSLog(@"error in select from addressUpdate");
        }
        [mrParkDB close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
    if (addressControlArray.count == 0) {
        [self requestAddressCall:info andRegionID:[NSNumber numberWithInt:20] adUpdateTime:@"2001-01-01 00:00:00"];
    }
    for (AddressUpdateControl* ad in addressControlArray) {
        NSMutableDictionary* info = [NSMutableDictionary new];
        [self requestAddressCall:info andRegionID:ad.int_region_id adUpdateTime:ad.str_update_at];
    }
}

#pragma mark Address Table
- (void)requestAddressCall:(NSMutableDictionary*) info andRegionID:(NSNumber*) region_id adUpdateTime: (NSString*) time{
    if (![time isEqualToString:@"2000-01-01 00:00:00"]) {
        isUpdate = YES;
    }
    [info setValue:[NSString stringWithFormat:@"%@", region_id] forKey:@"region_id"];
    [info setValue:time forKey:@"update_at"];
    [info setValue:@"get_address" forKey:@"cmd"];
    [self requestForAddress:info];
}
- (void)requestForAddress: (NSMutableDictionary*)info{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonStr=  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self requestAddress:jsonStr];
}

- (void)requestAddress: (NSString*)info {
    NSURL *urlMain = [[NSURL alloc] initWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlMain];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddressFail:)];
    [request setDidFinishSelector:@selector(requestAddressSuccess:)];
    [request startAsynchronous];
    
}

- (void)requestAddressFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [MPGlobalFunction showAlert:MESSAGE_NOT_RESPOND];
                   });
    [self performSelector:@selector(startMP) withObject:nil afterDelay:1];
}

- (void)requestAddressSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser=[[SBJSON alloc]init];
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSDictionary *dataArray = [results objectForKey:@"data"];
    addressTable_server_update_time = [dataArray objectForKey:@"update_at"];
    addressArray = [NSMutableArray new];
    if (dataArray != nil) {
        for (int i=0; i<dataArray.count; i++) {
            NSMutableArray *dataArr=((NSMutableArray*)[dataArray objectForKey:[NSString stringWithFormat:@"%d", i]]);
            AddressDB *data = [AddressDB new];
            data.int_addId = [dataArr valueForKey:@"address_id"];
            data.str_cityName = [dataArr valueForKey:@"city_name"];
            data.str_createdId = [dataArr valueForKey:@"created_at"];
            data.str_houseFullAddress = [dataArr valueForKey:@"house_full_address"];
            NSString* latString = [dataArr valueForKey:@"house_latitude"];
            data.double_houseLat = [NSNumber numberWithDouble:[latString doubleValue]];
            NSString* longString = [dataArr valueForKey:@"house_longitude"];
            data.double_houseLong = [NSNumber numberWithDouble:[longString doubleValue]];
            data.str_houseNo = [dataArr valueForKey:@"house_no"];
            data.str_houseSide = [dataArr valueForKey:@"house_side"];
            data.str_regionName = [dataArr valueForKey:@"region_name"];
            data.str_stateName = [dataArr valueForKey:@"state_name"];
            data.str_status = [dataArr valueForKey:@"status"];
            data.str_streetName = [dataArr valueForKey:@"street_name"];
            NSString * parkingIDS = [[dataArr valueForKey:@"parking_ids"] componentsSeparatedByString:@","][0];
            data.int_parking_ids = [NSNumber numberWithInt:[parkingIDS intValue]];
            [addressArray addObject:data];
        }
    }
    if (addressArray.count!= 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MPDBIntraction databaseInteractionManager] insertAddresList:addressArray];
        });
    }
    else{
        NSLog(@"addressTable no need to update");
    }
    [self performSelector:@selector(startMP) withObject:nil afterDelay:3];
}
@end
