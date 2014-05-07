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
- (IBAction)cancelTrade:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *tradeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage1;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage2;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage3;
@property (strong, nonatomic) IBOutlet UIButton *cancelTradeButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UILabel *bidMessageLabel;
@property (strong, nonatomic) NSString* tradeMessage;
@end
