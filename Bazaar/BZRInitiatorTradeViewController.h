//
//  BZRInitiatorTradeViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRInitiatorTradeViewController : UIViewController
@property (strong, nonatomic) PFObject* trade;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UIImageView *initiatorImage;
@property (strong, nonatomic) IBOutlet UIImageView *ownerImage;
@property (strong, nonatomic) IBOutlet UILabel *usersLabel;
- (IBAction)cancelTrade:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *tradeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage1;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage2;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage3;
@property (strong, nonatomic) IBOutlet UIButton *cancelTradeButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
- (IBAction)acceptTrade:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *bidMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *bidLabel;
@property (strong, nonatomic) NSString* tradeMessage;
@property (strong, nonatomic) IBOutlet UILabel *bidStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *greyOverlay;
@end
