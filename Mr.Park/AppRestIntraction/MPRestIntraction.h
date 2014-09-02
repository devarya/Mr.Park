//
//  MPRestIntraction.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MPGlobalData.h"

@class MPRestIntraction;
MPRestIntraction *restIntraction;
@interface MPRestIntraction : NSObject{
    
    NSURL * urlMain;
}
+(id)sharedManager;

@end
