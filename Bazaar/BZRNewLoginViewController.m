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

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@", [PFUser currentUser]);
	if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [self performSegueWithIdentifier:@"RevealTabBarController" sender:self];
    }
}

- (void)viewDidLoad
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
            NSLog(@"%@", [PFUser currentUser]);
            [self performSegueWithIdentifier:@"RevealTabBarController" sender:self];
        } else {
            NSLog(@"User with facebook logged in!");
            NSLog(@"%@", [PFUser currentUser]);
            [self performSegueWithIdentifier:@"RevealTabBarController" sender:self];
        }
    }];

}
@end
