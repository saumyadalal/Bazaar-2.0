//
//  BZRUserProfileViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRUserProfileViewController.h"
#import "BZRUserMarketPlaceViewController.h"
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>


@interface BZRUserProfileViewController () <BZRUserMarketPlaceDelegate>
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
    [self loadUserInfo];
}


- (void) loadUserInfo {
  if (self.user == nil) {
    self.user = [PFUser currentUser];
  }
  PFUser *user = self.user;
  PFFile *imageFile = [user objectForKey:@"imageFile"];
  [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    if (!error) {
      self.profilePicture.image = [UIImage imageWithData:data];
      self.username.text = [user objectForKey:@"username"];
      self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
      self.profilePicture.clipsToBounds = YES;
    }
    else {
      NSLog(@"error fetching image");
    }
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"embedMarketPlace"]) {
    BZRUserMarketPlaceViewController *marketPlaceView = segue.destinationViewController;
    marketPlaceView.user = self.user;
    marketPlaceView.inSelectionMode = NO;
    marketPlaceView.delegate = self;
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateNumItems:(NSUInteger)itemCount {
  [self.numItems setText:[NSString stringWithFormat:@" %d ", itemCount]];
}


- (IBAction)logout:(id)sender {
  [PFUser logOut];
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
