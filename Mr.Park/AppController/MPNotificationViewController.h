//
//  MPNotificationViewController.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPSettingViewController.h"
#import "MPAddTimerViewController.h"

@interface MPNotificationViewController : MPSettingViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv_myTableView;

@end
