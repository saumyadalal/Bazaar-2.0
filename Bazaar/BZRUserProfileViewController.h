//
//  BZRUserProfileViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 4/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BZRUserProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *username;
- (IBAction)logout:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *numTrades;
@property (strong, nonatomic) IBOutlet UILabel *numItems;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *fbPic;
@end
