 //
//  MPNotificationViewController.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPNotificationViewController.h"
#import <Foundation/NSObject.h>

@interface MPNotificationViewController ()
- (void)reloadTable;

@end

@implementation MPNotificationViewController
@synthesize scheduledLocalNotifications;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"reloadData"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get list of local notifications
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *localNotification = [localNotifications objectAtIndex:indexPath.row];
    
    // Display notification info
    
    [cell.textLabel setText:localNotification.alertBody];
   
    NSDate *Date = localNotification.fireDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * str_selectedDate  = [dateFormatter stringFromDate:Date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *str_dateSelected = [dateFormatter1 stringFromDate: Date];
    
    [cell.detailTextLabel setText:str_dateSelected];

    
    return cell;
}
- (void)reloadTable
{
    [self.tv_myTableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [scheduledLocalNotifications removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
    }
}
#pragma mark - IB_ACTION
-(IBAction)btnBackDidClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
