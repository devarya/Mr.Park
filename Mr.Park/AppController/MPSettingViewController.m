//
//  MPSettingViewController.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPSettingViewController.h"
#import "MPFavoritesViewController.h"

@interface MPSettingViewController ()

@end

@implementation MPSettingViewController

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

    //adding Bottom Bar
    MPBottomBarViewController *vc_bottomBar = [[MPBottomBarViewController alloc] initWithNibName:@"MPBottomBarViewController" bundle:nil];
    
    if (IS_IPHONE_5) {
        vc_bottomBar.view.frame = CGRectMake(0, 520, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }else{
        vc_bottomBar.view.frame = CGRectMake(0, 432, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }
    [self.view addSubview:[vc_bottomBar view]];
    
    btn_notification.layer.cornerRadius = 3.0f;
    btn_notification.layer.masksToBounds = YES;
    btn_notification.layer.borderWidth = 0.6f;
    btn_notification.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    btn_profile.layer.cornerRadius = 3.0f;
    btn_profile.layer.borderWidth = 0.6f;
    btn_profile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    btn_favorites.layer.cornerRadius = 3.0f;
    btn_favorites.layer.borderWidth = 0.6f;
    btn_favorites.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    btn_legal.layer.cornerRadius = 3.0f;
    btn_legal.layer.borderWidth = 0.6f;
    btn_legal.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
-(IBAction)btnFeedBackDidClicked:(id)sender{
    
    MPFeedBackViewController *vc_feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    [self presentViewController:vc_feedback animated:YES completion:NULL];
    
}
-(IBAction)btnShareDidClicked:(id)sender{
    
    MPShareViewController *vc_share = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
    [self presentViewController:vc_share animated:YES completion:NULL];
    
}
-(IBAction)btnNotificationDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_notification" sender:nil];
}
-(IBAction)btnProfileDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_profile" sender:nil];
}
-(IBAction)btnFavoritesDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_fav" sender:nil];
}
-(IBAction)btnLegalDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_legal" sender:nil];
}
@end
