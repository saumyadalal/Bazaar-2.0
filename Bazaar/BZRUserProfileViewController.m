//
//  BZRUserProfileViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRUserProfileViewController.h"
#import "SWRevealViewController.h"
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
    self.navigationItem.leftBarButtonItem.target = self.tabBarController.revealViewController;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
    self.username.font = [UIFont fontWithName:@"Gotham-Medium" size:14]; //make font of username bold
    self.logoutButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:14];
    [self loadUserInfo];
}


- (void) loadUserInfo {
  PFUser *user = [PFUser currentUser];
  PFFile *imageFile = [user objectForKey:@"imageFile"];
  [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    if (!error) {
      self.profilePicture.image = [UIImage imageWithData:data];
      self.username.text = [user objectForKey:@"username"];
    }
    else {
      NSLog(@"error fetching image");
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
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
