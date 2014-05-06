//
//  BZRAppDelegate.m
//  Bazaar
//
//  Created by Shikhara Nalla on 3/22/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "BZRLoginViewController.h"


@implementation BZRAppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //load the profilePictureViewClass for interface builder
    [FBProfilePictureView class];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //set up parse BEFORE the login view controller
    [Parse setApplicationId:@"6c9l1sdeHO3zCyRj6EonwpLKqo2Tedv23TyMS0mU"
                  clientKey:@"IRBP4MYHb36uwgnvcYCmP4IIC9KV8UMosddwWJGu"];
    //initialize facebook
    [PFFacebookUtils initializeFacebook];
    //set login view controller
    BZRLoginViewController *loginViewController = [[BZRLoginViewController alloc] initWithNibName:@"BZRLoginViewController" bundle:nil];
    self.window.rootViewController = loginViewController;
   [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(79/255.0) green:(44/255.0) blue:(112/255.0) alpha:(1)]]; //tab bar background color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]]; //tab bar item and font color when selected
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(79/255.0) green:(44/255.0) blue:(112/255.0) alpha:(1)]]; //navigation bar background color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; //navigation bar side objects and text color
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,[UIFont fontWithName:@"Gotham-Medium" size:17],NSFontAttributeName,
      nil]]; //navigation bar main title color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Medium" size:15]}forState:UIControlStateNormal];
    
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //changes status bar style to light, also added a key in .plist file called "view controlled based status bar appearance" and set it to NO
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Gotham-Book" size:14.0]];
    return YES;
}


// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [FBAppCall handleOpenURL:url
                sourceApplication:sourceApplication
                      withSession:[PFFacebookUtils session]];
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
  [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
