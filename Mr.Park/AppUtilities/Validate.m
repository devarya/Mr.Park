//
//  Validate.m
//  GiftMail
//
//  Created by Shivam on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Validate.h"


@implementation Validate

/**
 * Function name isNull                         
 *                                              
 * @params: NSString *str                       
 *                                              
 * @object: function to check a string to null  
 *
 * return BOOL
 */

+ (BOOL)isNull:(NSString*)str{
	if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || str==nil) {
		return YES;
	}
	return NO;
}
/**
 * Function name isValidEmailId                
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid email id  
 *
 * return BOOL
 */
+ (BOOL)isValidEmailId:(NSString*)email
{
    
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
	return [emailTest evaluateWithObject:email];
}
/**
 * Function name isValidMobileNumber           
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid Mobile # 
 *
 * return BOOL
 */
+ (BOOL)isValidMobileNumber:(NSString*)number
{
    number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([number length]<5 || [number length]>17) {
		return FALSE;
	}
	NSString *Regex = @"^([0-9]*)$"; 
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex]; 
	
    return [mobileTest evaluateWithObject:number];
}
/**
 * Function name isValidUserName                
 *                                             
 * @params: NSString                            
 *                                              
 * @object: function to check a valid user name 
 *
 * return BOOL
 */
+ (BOOL) isValidUserName:(NSString*)userName{
    NSString *regex=@"^[a-zA-Z0-9_-]{3,15}$";
    NSPredicate *userNameTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [userNameTest evaluateWithObject:userName];
}
/**
 * Function name isValidPassword                
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid password 
 *
 * return BOOL
 */
+ (BOOL) isValidPassword:(NSString*)password{
    NSString *regex=@"^[a-zA-Z0-9_-[!#$%&]]{5,15}$";
    NSPredicate *passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [passwordTest evaluateWithObject:password];
}
/**
 * Function name isValidDOB
 *
 * @params: NSDate
 *
 * @object: function to check a valid date of birth
 *
 * return BOOL
 */
+ (BOOL)isValidDOB:(NSString*)strDate{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *now=[NSDate date];
    NSDate *dob=[formatter dateFromString:strDate];
    
    NSComparisonResult result=[now compare:dob];
    switch (result)
    {
        case NSOrderedDescending: return TRUE; break;
//        case NSOrderedAscending: NSLog(@"dob greater"); break;
//        case NSOrderedSame: NSLog(@"same"); break;
//        default: NSLog(@"erorr dates "); break;
    }
    return  FALSE;
    
}
@end
