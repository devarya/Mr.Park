//
//  MPSettingViewController.h
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPShareViewController.h"
#import "MPFeedBackViewController.h"

@interface MPSettingViewController : MPBottomBarViewController{
    
    IBOutlet UIButton *btn_notification;
    IBOutlet UIButton *btn_profile;
    IBOutlet UIButton *btn_favorites;
    IBOutlet UIButton *btn_legal;
    
}
-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnNotificationDidClicked:(id)sender;
-(IBAction)btnProfileDidClicked:(id)sender;
-(IBAction)btnFavoritesDidClicked:(id)sender;
-(IBAction)btnLegalDidClicked:(id)sender;
@end
