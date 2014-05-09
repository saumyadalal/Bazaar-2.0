//
//  BZRSuccessfulTradeViewController.h
//  Bazaar
//
//  Created by Saumya Dalal on 5/7/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRSuccessfulTradeViewController : UIViewController
- (IBAction)launchMessenger:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *ownerImage;
@property (strong, nonatomic) IBOutlet UIImageView *initiatorImage;
@property (strong, nonatomic) IBOutlet UILabel *usersLabel;
@property (strong, nonatomic) IBOutlet UIImageView *keyItemImage_1;
@property (strong, nonatomic) IBOutlet UIImageView *returnItemImage_1;

@property (strong, nonatomic) IBOutlet UILabel *successLabel;
@property (strong, nonatomic) PFObject* trade;
@property (strong, nonatomic) IBOutlet UIImageView *keyItemImage;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage2_1;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage2_2;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage1;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage2;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage3;

@end
