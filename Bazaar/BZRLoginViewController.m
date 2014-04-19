//
//  BZRLoginViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/1/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRLoginViewController.h"
#import "BZRTabBarController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "BZRFilterViewController.h"


@interface BZRLoginViewController () <FBLoginViewDelegate>
@property (strong, nonatomic) SWRevealViewController *revealController;
@property BOOL isFirstLoginDone;
@end

@implementation BZRLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Front View with tab bar
    BZRTabBarController *tabBarController = [[BZRTabBarController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: tabBarController];
    //Rear view (SideBar)
    BZRFilterViewController *filterTableViewController = [[BZRFilterViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:filterTableViewController];
    //Init reveal controller
  	self.revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:navigationController];
  
    /* After a user logs in, Parse will automatically cache the Facebook and Parse sessions in the currentUser object. 
       By pass login screen 
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
      [self presentViewController:self.nav animated:NO completion:nil];
    } */
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUser:(id)sender {
  NSArray *permissionsArray = @[ @"user_about_me"];
  //initialize facebook
  [PFFacebookUtils initializeFacebook];
  // Login PFUser using Facebook
  [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    if (!user) {
      if (!error) {
        NSLog(@"The user cancelled the Facebook login.");
      } else {
        NSLog(@"An error occurred: %@", error);
      }
    } else if (user.isNew) {
      NSLog(@"User with facebook signed up and logged in!");
      [self presentViewController:self.revealController animated:YES completion:nil];
    } else {
      NSLog(@"User with facebook logged in!");
      [self presentViewController:self.revealController animated:YES completion:nil];
    }
  }];
}

@end