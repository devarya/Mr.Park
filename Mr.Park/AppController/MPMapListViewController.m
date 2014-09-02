//
//  MPMapViewController.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPMapListViewController.h"

@interface MPMapListViewController ()

@end

@implementation MPMapListViewController

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
    
    MPBottomBarViewController *vc_bottomBar = [[MPBottomBarViewController alloc] initWithNibName:@"MPBottomBarViewController" bundle:nil];
    
    if (IS_IPHONE_5) {
        vc_bottomBar.view.frame = CGRectMake(0, 520, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }else{
        vc_bottomBar.view.frame = CGRectMake(0, 432, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);
    }
    [self.view addSubview:[vc_bottomBar view]];
    
    isMapView = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
}
#pragma mark - IB_ACTION

-(IBAction)btnFeedBackDidClicked:(id)sender{
    
    MPFeedBackViewController *vc_feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    [self presentViewController:vc_feedback animated:YES completion:NULL];
    
}
-(IBAction)btnSettingDidClicked:(id)sender{
    
    MPSettingViewController *vc_setting = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self presentViewController:vc_setting animated:YES completion:NULL];
    
}
-(IBAction)btnShareDidClicked:(id)sender{ 
    
    MPShareViewController *vc_share = [self.storyboard instantiateViewControllerWithIdentifier:@"share"];
    [self presentViewController:vc_share animated:YES completion:NULL];

}

-(IBAction)btnReminderDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_addTimer" sender:nil];
    
}
-(IBAction)btnSwitchToMapAndList:(id)sender{
    
    if (isMapView) {
        isMapView = NO;
        [btnToggleMapList setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
        [self performCubeAnimation:@"cube" animSubType:kCATransitionFromRight];
        [map_View removeFromSuperview];
        
        [containerView addSubview:tbl_View];
    }else{
        isMapView = YES;
        [btnToggleMapList setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [self performCubeAnimation:@"cube" animSubType:kCATransitionFromLeft];
        [tbl_View removeFromSuperview];
        
        [containerView addSubview:map_View];
    }
}
-(void)performCubeAnimation:(NSString*)animType animSubType:(NSString*)animSubType{
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = animType;
    transition.subtype = animSubType;
    [self.view.layer addAnimation:transition forKey:nil];
    [[[self view] layer] addAnimation: transition forKey: nil];
    
}

#pragma mark TABLE_VIEW DELEGATE AND DATASOURCE

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSString *cellIdentifier = @"listCell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"testing Mr.Park";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"segue_tblDetail" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
