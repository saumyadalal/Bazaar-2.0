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

-(void) viewWillAppear:(BOOL)animated {
    [self loadUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.username.font = [UIFont fontWithName:@"Gotham-Medium" size:15]; //make font of username bold
    self.logoutButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13]; //logout button font
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem.target = self.tabBarController.revealViewController;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
    NSLog(@"before load user: %@",self.user);
    [self loadUserInfo];
}


- (void) loadUserInfo {
    NSLog(@"user before: %@",self.user);
  if (self.user == nil) {
    self.user = [PFUser currentUser];
  }
  PFUser *user = self.user;
    NSLog(@"user: %@",self.user);
  PFFile *imageFile = [user objectForKey:@"imageFile"];
  [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    if (!error) {
      self.profilePicture.image = [UIImage imageWithData:data];
      self.username.text = [user objectForKey:@"username"];
      self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
      self.profilePicture.clipsToBounds = YES;
      NSString *numOfTrades = [[user objectForKey:@"numTrades"] stringValue];
        self.numTrades.text = numOfTrades;
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
