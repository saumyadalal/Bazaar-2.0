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
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel1;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel2;
- (IBAction)cancelTrade:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *numItems;
@end
