//
//  ICUtils.h
//  IntegrityCubes
//
//  Created by aditi on 13/03/14.
//  Copyright (c) 2014 Aryavrat Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICAlertView.h"

@interface ICUtils : NSObject
+(BOOL)isConnectedToInternet;
+(BOOL)isConnectedToHost;
+(ICAlertView*)showAlert:(NSString*)msg;
+(ICAlertView*)showAlert:(NSString*)msg delegate:(id)delegate btnOk:(NSString*)btnOk btnCancel:(NSString*)btnCancel;
+(BOOL)isFileExists:(NSString*)name;
@end
