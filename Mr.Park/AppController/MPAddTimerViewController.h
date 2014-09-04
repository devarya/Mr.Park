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
    IBOutlet UIView *v_dateAndTime;
    IBOutlet UILabel *l_dateAndTime;
    IBOutlet UIDatePicker *pv_dateAndTime;
    IBOutlet UIButton *overnight;
    BOOL isOvernight;
}

- (IBAction)btn_hidePickerView:(id)sender;
- (IBAction)btn_showPickerView:(id)sender;
- (IBAction)btn_overnight:(id)sender;
- (IBAction)btn_remindMe:(id)sender;
- (IBAction)btn_CancelReminder:(id)sender;

@end
