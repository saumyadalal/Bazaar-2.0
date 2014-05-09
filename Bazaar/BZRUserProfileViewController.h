//
//  BZRUserProfileViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 4/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRUserProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) PFUser* user;
@property (nonatomic, assign) BOOL inSelectionMode;
- (IBAction)logout:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *numTrades;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UILabel *numItems;
@property (strong, nonatomic) IBOutlet UILabel *tradesLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *behindProfileColor;
@end
