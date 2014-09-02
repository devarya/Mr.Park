//
//  MPGlobalFunction.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

FMDatabase *dBMrPark;

@interface MPGlobalFunction : NSObject{
    
    
}
+(void)showAlert:(NSString*)msg;
+(void)showCustomizeAlert:(NSString*)msg;
+(BOOL)isConnectedToInternet;
+(BOOL)isConnectedToHost;
+(BOOL)isFileExists:(NSString*)name;


@end
