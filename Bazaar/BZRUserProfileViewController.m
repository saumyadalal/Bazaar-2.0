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
#import "BZRDesignUtils.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


@interface BZRUserProfileViewController () <BZRUserMarketPlaceDelegate>
@property (strong, nonatomic) UIView* containerView;
@end

@implementation BZRUserProfileViewController

-(void) viewWillAppear:(BOOL)animated {
    [self loadUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFont];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem.target = self.tabBarController.revealViewController;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
    [self loadUserInfo];
}

- (void) setFont {
  NSString* fontName = @"Gotham-Book";
  [self.itemsLabel setFont:[UIFont fontWithName:fontName size:13]];
  //[self.itemsLabel setTextColor:[BZRDesignUtils dateTimeColor]];
  [self.tradesLabel setFont:[UIFont fontWithName:fontName size:13]];
  //[self.tradesLabel setTextColor:[BZRDesignUtils dateTimeColor]];
  [self.numItems setFont:[UIFont fontWithName:fontName size:14]];
  [self.numTrades setFont:[UIFont fontWithName:fontName size:14]];
  self.username.font = [UIFont fontWithName:@"Gotham-Medium" size:17];
  self.logoutButton.titleLabel.font = [UIFont fontWithName:fontName size:13];
  [self.view setBackgroundColor:[BZRDesignUtils profileBackgroundColor]];
  //[self.containerView.layer setShadowOffset:CGSizeMake(5, 5)];
  //[self.containerView.layer setShadowColor:[[UIColor grayColor] CGColor]];
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
      PFQuery *numTradesQuery = [PFQuery queryWithClassName:@"numTrades"];
      [numTradesQuery whereKey:@"user" equalTo:self.user];
      [numTradesQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
          for (PFObject *user in users) {
              
              self.numTrades.text = [user[@"numTrades"] stringValue];
              NSLog(@"user: %@", user);
              NSLog(@"numTrades: %@", self.numTrades.text);
          }
      }];

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
    self.containerView = marketPlaceView.view;
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
