//
//  BZRTabBarController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/28/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRTabBarController.h"
#import "BZRBazaarController.h"
#import "BZRUserMarketPlaceViewController.h"

@interface BZRTabBarController () <UITabBarControllerDelegate>

@end

@implementation BZRTabBarController

- (void) viewDidLoad {
  self.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
  // Reload selected VC's view
  //NSLog(@"hi");
  //[viewController.view setNeedsDisplay];
//    if (![viewController isKindOfClass:[BZRBazaarController class]]) {
//        ((BZRBazaarController*) viewController).items = [NSArray array];
//    }
}


@end
