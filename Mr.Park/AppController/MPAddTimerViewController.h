//
//  MPAddTimerViewController.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMapListViewController.h"
#import "MPFeedBackViewController.h"
#import "MPSettingViewController.h"

@interface MPAddTimerViewController : MPMapListViewController{
    
    IBOutlet UITextView *tv_remindNote;
    IBOutlet UIButton *btn_calender;
}

@end
