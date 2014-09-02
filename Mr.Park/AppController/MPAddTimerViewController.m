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
#pragma mark - IB_ACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
