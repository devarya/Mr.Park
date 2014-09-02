//
//  MPGlobalFunction.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPGlobalFunction.h"

@implementation MPGlobalFunction


+(void)showAlert:(NSString*)msg{
    
    [[[UIAlertView alloc]initWithTitle:@"Message"
                               message:msg
                              delegate:self
                     cancelButtonTitle:@"Ok"
                     otherButtonTitles:nil]show];
}
+(void)showCustomizeAlert:(NSString *)msg{
    
    [[[UIAlertView alloc]initWithTitle:@"Message"
                               message:msg
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:nil]show];
    
}
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
+(BOOL)isFileExists:(NSString*)name{
    
    NSFileManager *fileManager = [NSFileManager new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,name];
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:nil];
    return isExist;
}


@end
