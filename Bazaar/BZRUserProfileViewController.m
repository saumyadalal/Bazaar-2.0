//
//  BZRUserProfileViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRUserProfileViewController.h"
#import "BZRTabBarController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>


@interface BZRUserProfileViewController ()
@end

@implementation BZRUserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        self.tabBarItem.title = self.title;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [self setUserInfo];
}

- (void) setUserInfo {
  //create request for data
  FBRequest *request = [FBRequest requestForMe];
  // Send request to Facebook
  [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      // result is a dictionary with the user's Facebook data
      NSDictionary *userData = (NSDictionary *)result;
      
      NSString *facebookID = userData[@"id"];
      NSString *name = userData[@"name"];

      // Now add the data to the UI elements
      self.profilePictureView.profileID = facebookID;
      self.username.text = name;
    }
  }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender {
  [PFUser logOut];
  [self.tabBarController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
