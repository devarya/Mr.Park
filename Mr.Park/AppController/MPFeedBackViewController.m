//
//  MPFeedBackViewController.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPFeedBackViewController.h"

@interface MPFeedBackViewController ()

@end

@implementation MPFeedBackViewController

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
    
    //adding Bottom Bar
    MPBottomBarViewController *vc_bottomBar = [[MPBottomBarViewController alloc] initWithNibName:@"MPBottomBarViewController" bundle:nil];
    
    if (IS_IPHONE_5) {
        vc_bottomBar.view.frame = CGRectMake(0, 520, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }else{
        vc_bottomBar.view.frame = CGRectMake(0, 432, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }
    [self.view addSubview:[vc_bottomBar view]];
    
    tx_email.layer.cornerRadius = 3.0f;
    tx_email.layer.borderWidth = 0.6f;
    tx_email.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    tv_message.layer.cornerRadius = 3.0f;
    tv_message.layer.borderWidth = 0.6f;
    tv_message.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IB_ACTION
-(IBAction)btnBackDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)btnSettingDidClicked:(id)sender{
    
    MPSettingViewController *vc_setting = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self presentViewController:vc_setting animated:YES completion:NULL];
    
}
-(IBAction)btnShareDidClicked:(id)sender{
    
    MPShareViewController *vc_share = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
    [self presentViewController:vc_share animated:YES completion:NULL];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self->tv_message resignFirstResponder];
    [self->tx_email resignFirstResponder];

}

@end
