//
//  MPFeedBackViewController.h
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPShareViewController.h"
#import "MPSettingViewController.h"

@interface MPFeedBackViewController : MPBottomBarViewController{
    
   IBOutlet UITextField *tx_email;
   IBOutlet UITextView *tv_message;
    
}
-(IBAction)btnBackDidClicked:(id)sender;

@end
