//
//  MPAppDelegate.m
//  Mr.Park
//
//  Created by aditi on 01/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPAppDelegate.h"
#import "MPMapListViewController.h"

@implementation MPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITextField *txtField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [txtField becomeFirstResponder];
    [self.window addSubview:txtField];
    [txtField removeFromSuperview];
    txtField = nil;
    
    UIImageView *launchView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    launchView.image = [UIImage imageNamed:@"Default.png"];
    UIViewController *rootViewCtr = [[UIViewController alloc]init];
    rootViewCtr.view.frame = [UIScreen mainScreen].bounds;
    [rootViewCtr.view addSubview:launchView];
    self.window.rootViewController = rootViewCtr;
    [self performSelector:@selector(startMP) withObject:nil afterDelay:3];

    return YES;
}
-(void)startMP{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:[NSBundle mainBundle]];
    MPMapListViewController *mapViewController = (MPMapListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mapViewCtr"];
//    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:mapViewController];
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];

   self.window.rootViewController = mapViewController;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
