//
//  MPAddTimerViewController.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPAddTimerViewController.h"

@interface MPAddTimerViewController ()

@end

@implementation MPAddTimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tv_remindNote.layer.cornerRadius = 1.0f;
    tv_remindNote.layer.borderWidth = 1.0f;
    tv_remindNote.layer.borderColor = [UIColor grayColor].CGColor;
    
    btn_calender.layer.cornerRadius = 1.0f;
    btn_calender.layer.borderWidth = 1.0f;
    btn_calender.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)schedulLocalNotificationWithDate:(NSDate *)firedate{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];;
    notification.alertBody = tv_remindNote.text;
    notification.soundName = @"7f_in-a-hurry-song.mp3";
    //    notification.soundName = @"alarm-clock-bell.caf";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}
#pragma mark - IB_ACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self->tv_remindNote resignFirstResponder];
    
}
- (IBAction)btn_showPickerView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    v_dateAndTime.frame = CGRectMake(0, 307, 320, 199);
    [UIView commitAnimations];
}
- (IBAction)btn_hidePickerView:(id)sender {
    NSDate *dateSelect = [ pv_dateAndTime date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    
    NSString *dateStamp = [dateFormat stringFromDate:dateSelect];
    l_dateAndTime.text = dateStamp;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    v_dateAndTime.frame = CGRectMake(0, 600, 320, 199);
    [UIView commitAnimations];
}
- (IBAction)btn_overnight:(id)sender {
    
    if (!isOvernight) {
        isOvernight = YES;
        [overnight setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        NSLog(@"IS OVERNIGHT");
    }
    else{
        isOvernight = NO;
        [overnight setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        NSLog(@"IS NOT OVERNIGHT");

    }
}

- (IBAction)btn_remindMe:(id)sender {
    NSString *timeLabel = l_dateAndTime.text;
    NSString *noteText = tv_remindNote.text;
    if ([timeLabel isEqualToString:@""] || [noteText isEqualToString:@""]) {
        UIAlertView *errorAlert =[[UIAlertView alloc]initWithTitle:@"Time Reminder" message:@"Please Write Some Note OR Select Remind Time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Parking Reminder" message:@"Alarm has added to the Notification." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;

        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSString *dateTimeString = [dateFormatter stringFromDate:pv_dateAndTime.date];
    NSLog(@"Set Alarm: %@", dateTimeString);
        
        [self schedulLocalNotificationWithDate:pv_dateAndTime.date];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)btn_CancelReminder:(id)sender {
    UIAlertView * cancelAlert = [[UIAlertView alloc] initWithTitle:@"Message"
                                       message:@"Do you want cancel remind in."
                                      delegate:self
                             cancelButtonTitle:@"NO"
                             otherButtonTitles: @"YES", nil];
    cancelAlert.tag=1;
    [cancelAlert show];
}
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alert.tag == 1)
    {
        if(buttonIndex == alert.cancelButtonIndex)
        {
            
        }
        else
        {
//            [[UIApplication sharedApplication] cancelLocalNotification:NSNotification];
//            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated: YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self->tv_remindNote resignFirstResponder];
    return NO;
}


@end
