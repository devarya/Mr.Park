//
//  MPRestIntraction.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPRestIntraction.h"

@implementation MPRestIntraction

+(id)sharedManager{
    
    if (!restIntraction) {
        
        restIntraction = [MPRestIntraction new];
        
    }
    return  restIntraction;
}

-(id)init{
    if (self = [super init]) {
        NSString * strUrl = URL_MAIN;
        urlMain = [[NSURL alloc] initWithString:strUrl];
    }
    return self;
}

#pragma mark Reigion
- (void)requestRegionCall:(NSMutableDictionary*) info withUpdate: (NSString*) time{
    [info setValue:[NSString stringWithFormat:@"%@", time] forKey:@"update_at"];
    [info setValue:@"get_region" forKey:@"cmd"];
    [self requestForRegion:info];
}

- (void)requestForRegion: (NSMutableDictionary*)info{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonStr=  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self requestRegion:jsonStr];
}

- (void)requestRegion: (NSString*)info {
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestRegionFail:)];
    [request setDidFinishSelector:@selector(requestRegionSuccess:)];
    [request startAsynchronous];
    
}

- (void)requestRegionFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [MPGlobalFunction showAlert:MESSAGE_NOT_RESPOND];
                   });
}

- (void)requestRegionSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser=[[SBJSON alloc]init];
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSDictionary *dataArray=[results objectForKey:@"data"];
    regionTable_server_update_time = [dataArray objectForKey:@"update_at"];
    regionArray = [NSMutableArray new];
    NSMutableArray *dataArr = ((NSMutableArray*)[dataArray objectForKey:@"data"]);
    for (int i=0; i<dataArr.count; i++) {
        
        Region *data = [Region new];
        
        data.str_region_id = [[dataArr valueForKey:@"region_id"]objectAtIndex:i];
        data.str_state_id = [[dataArr valueForKey:@"state_id"]objectAtIndex:i];
        data.str_region_name = [[dataArr valueForKey:@"region_name"]objectAtIndex:i];
        data.str_update_at = [[dataArr valueForKey:@"update_at"]objectAtIndex:i];
        
        [regionArray addObject:data];
    }
    if (regionArray.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[[MKDataBaseInteraction databaseInteractionManager] insertRegionList:regionArray];
        });
    }
    else{
        NSLog(@"regionTable no need to update");
    }
}

@end