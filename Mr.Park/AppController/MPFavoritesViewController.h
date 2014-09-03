//
//  MPFavoritesViewController.h
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPSettingViewController.h"

@interface MPFavoritesViewController : MPSettingViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *favoritesTableView;
}
- (IBAction)btnDelete:(id)sender;
@property (strong, nonatomic) NSMutableArray *aryaInfo2014;

@end
