//
//  BZRTabBarController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRTabBarController.h"
#import "BZRUserProfileViewController.h"
#import "BZRLoginViewController.h"
#import "BZRMarketPlaceViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SWRevealViewController.h"

@interface BZRTabBarController ()
@end

@implementation BZRTabBarController

- (id) init {
  self =  [super init];
  if (self) {
    BZRUserProfileViewController *userProfileVC = [[BZRUserProfileViewController alloc] initWithNibName:@"BZRUserProfileViewController" bundle:nil];
    BZRMarketPlaceViewController *marketPlaceVC = [[BZRMarketPlaceViewController alloc]
                                                   initWithStyle:UITableViewStylePlain];
    NSArray *tabViewControllers = @[userProfileVC, marketPlaceVC];
    [self setViewControllers:tabViewControllers];
  }
  return self;
}

//occurs only once
- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem *newItemButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
      style:UIBarButtonItemStylePlain target:self action:@selector(newItem:)];
  self.navigationItem.rightBarButtonItem = newItemButton;
  
  //Get the Reveal View Controller
  SWRevealViewController *revealController = [self revealViewController];
  [revealController panGestureRecognizer];
  [revealController tapGestureRecognizer];
  //look for the selector method in the target
  UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters"                                                                       style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
  self.navigationItem.leftBarButtonItem = revealButtonItem;
}

- (void)newItem:(id)sender{
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
