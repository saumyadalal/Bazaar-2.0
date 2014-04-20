//
//  BZRNewLoginViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/20/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRNewLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface BZRNewLoginViewController ()

@end

@implementation BZRNewLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [super viewDidLoad];
    //Front View with tab bar
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: tabBarController];
    //Rear view (SideBar)
    UITableViewController *filterTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:filterTableViewController];
    //Init reveal controller
  	//self.tabBarController = [[UIPageViewController alloc] initWithRearViewController:rearNavigationController frontViewController:navigationController];
    
    /* After a user logs in, Parse will automatically cache the Facebook and Parse sessions in the currentUser object.
     By pass login screen */
     if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
     [self presentViewController:self animated:NO completion:nil];
     }
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
            [self presentViewController:self.tabBarController animated:YES completion:nil];
        } else {
            NSLog(@"User with facebook logged in!");
            [self presentViewController:self.tabBarController animated:YES completion:nil];
        }
    }];

}
@end
