//
//  ICUtils.m
//  IntegrityCubes
//
//  Created by aditi on 13/03/14.
//  Copyright (c) 2014 Aryavrat Infotech. All rights reserved.
//

#import "ICUtils.h"
#import "Reachability.h"

@implementation ICUtils
+(BOOL)isConnectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+(BOOL)isConnectedToHost
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+(ICAlertView*)showAlert:(NSString*)msg{
    
    ICAlertView *alertView = [[ICAlertView alloc]initWithTitle:@"Message" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    return alertView;
}

+(ICAlertView*)showAlert:(NSString*)msg delegate:(id)delegate btnOk:(NSString*)btnOk btnCancel:(NSString*)btnCancel{
    
    ICAlertView *alertView = [[ICAlertView alloc]initWithTitle:@"Message" message:msg delegate:delegate cancelButtonTitle:btnCancel otherButtonTitles:btnOk,nil];
    
    [alertView show];
    return alertView;
}

+(BOOL)isFileExists:(NSString*)name{
    
    NSFileManager *fileManager = [NSFileManager new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,name];
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:nil];
    return isExist;
}
@end
