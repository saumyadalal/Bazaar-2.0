//
//  BZRInitiatorTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRInitiatorTradeViewController.h"
#import "BZRTradeUtils.h"
#import "BZRNotificationTableViewController.h"
#import "BZRSuccessfulTradeViewController.h"

@interface BZRInitiatorTradeViewController ()
@property (nonatomic, strong) NSArray* itemImageViews;
@end

@implementation BZRInitiatorTradeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemImageViews = @[self.itemImage1, self.itemImage2, self.itemImage3];
    //load item image the first time
    [BZRTradeUtils loadImage:self.itemImage fromItem:[self.trade objectForKey:@"item"]];
    PFUser* owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    PFFile *ownerImageFile = [owner objectForKey:@"imageFile"];
    PFFile *initiatorImageFile = [initiator objectForKey:@"imageFile"];
    [ownerImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.ownerImage.image = [UIImage imageWithData:data];
            self.ownerImage.layer.cornerRadius = self.ownerImage.frame.size.width / 2;
            self.ownerImage.clipsToBounds = YES;
        }
        else {
            NSLog(@"error fetching owner image");
        }
    }];
    [initiatorImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.initiatorImage.image = [UIImage imageWithData:data];
            self.initiatorImage.layer.cornerRadius = self.initiatorImage.frame.size.width / 2;
            self.initiatorImage.clipsToBounds = YES;
        }
        else {
            NSLog(@"error fetching initiator image");
        }
    }];
    self.bidLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:15];
    [self setUsersLabel];
    [self setFont];
    self.greyOverlay.hidden = true;
    self.greyOverlay.backgroundColor = [[UIColor alloc] initWithRed:0 green:0
                                                               blue:0 alpha:0.5];
}

- (void) setUsersLabel {
    PFUser* owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    NSString *ownerName = [BZRTradeUtils getFirstName:owner];
    NSString *initiatorName = [BZRTradeUtils getFirstName:initiator];
    NSString *combined = [NSString stringWithFormat:@"%@ & %@", initiatorName, ownerName];
    self.usersLabel.text = combined;
    self.usersLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:17];
}

- (void) updateDisplay {
  NSString* status = [self.trade objectForKey:@"status"];
  // *** responded status
  if ([status isEqualToString:@"responded"]) {
    [self.acceptButton setHidden:NO];
    [self.bidStatusLabel setHidden:YES];
    [self.bidMessageLabel setText:@"Bid request received"];
  }
  // *** initiated status
  else if ([status isEqualToString:@"initiated"]) {
    [self.bidStatusLabel setHidden:NO];
    NSUInteger limit = [[self.trade objectForKey:@"numItems"] intValue];
    NSString* firstName = [BZRTradeUtils getFirstName:[self.trade objectForKey:@"owner"]];
    NSString* baseStr = @"%@ can choose upto %d items from your marketplace";
    [self.bidMessageLabel setText:[NSString stringWithFormat:baseStr, firstName, limit]];
    [self.acceptButton setHidden:YES];
  }
  // trade is complete or cancelled, irrelevant
  else {
    [self.cancelTradeButton setHidden:YES];
    [self.acceptButton setHidden:YES];
    if ([status isEqualToString: @"cancelled"]) {
      [self.greyOverlay setHidden:NO];
      [self.greyOverlay setText:@"This trade has been cancelled"];
      [self.view setUserInteractionEnabled:NO];
    }
  }
}


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateContent];
}


- (void) updateContent {
  [self.tradeLabel setText:self.tradeMessage];
  [self updateDisplay];
  //load return item images
  if ([self.trade[@"status"] isEqualToString:@"responded"]) {
      [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
  }
  else if ([self.trade[@"status"] isEqualToString:@"complete"]) {
      
  }
  else {
      //display no images yet
      self.acceptButton.enabled = false;
      self.acceptButton.hidden = true;
//      self.cancelTradeButton.enabled = false;
//      self.cancelTradeButton.hidden = true;
  }
}

- (void) setFont {
  self.cancelTradeButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.acceptButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTrade:(id)sender {
  self.greyOverlay.hidden = false;
  [BZRTradeUtils cancelTrade:self.trade];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptTrade:(id)sender {
    self.trade[@"status"] = @"complete";
    [self.trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved updated trade status");
            [self changeTradedItemsStatus];
        }
        else {
            NSLog(@"error changing trade status");
        }
    }];
    [self.acceptButton setHidden:YES];
    [self.cancelTradeButton setHidden:YES];
    
    //Updating the numTrades for owner and initiator
    PFUser *owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    
    PFQuery *ownerQuery = [PFQuery queryWithClassName:@"numTrades"];
    [ownerQuery whereKey:@"user" equalTo:owner];
    PFQuery *initiatorQuery = [PFQuery queryWithClassName:@"numTrades"];
    [initiatorQuery whereKey:@"user" equalTo:initiator];
    PFQuery *numTradesQuery = [PFQuery orQueryWithSubqueries:@[initiatorQuery, ownerQuery]];
    [numTradesQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        for (PFObject *user in users) {
            [user incrementKey:@"numTrades"];
            [user saveInBackground];
            NSLog(@"new numtrades: %@", [user objectForKey:@"numTrades"]);
        }
    }];
    
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    
    //cancel all trades involving traded items
    PFObject *item = self.trade[@"item"];
    NSArray *returnItems = self.trade[@"returnItems"];
    PFQuery *query = [PFQuery queryWithClassName:@"Trade"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *otherTrades, NSError *error) {
        if (!error) {
            for (PFObject *otherTrade in otherTrades) {
                PFObject *tradeItem = otherTrade[@"item"];
                NSArray *tradeReturnItems = otherTrade[@"returnItems"];
                if (![[otherTrade objectId] isEqualToString:[self.trade objectId]]) {
                    if ([tradeItem isEqual: item]) {
                        otherTrade[@"status"] = @"unavailable";
                    }
                    else {
                        for (PFObject* returnItem in returnItems) {
                            if ([returnItem isEqual:tradeItem]) {
                                otherTrade[@"status"] = @"unavailable";
                            }
                            for (PFObject* tradeReturnItem in tradeReturnItems) {
                                if ([returnItem isEqual:tradeReturnItem]) {
                                    otherTrade[@"status"] = @"unavailable";
                                }
                            }
                        }
                    }
                    [otherTrade saveInBackground];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"error cancelling other trades after accept");
        }
    }];

    
    //create the trade complete view
    BZRSuccessfulTradeViewController* tradeCompleteView = (BZRSuccessfulTradeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"tradeCompleteView"];
    tradeCompleteView.trade = self.trade;
    [navController pushViewController:tradeCompleteView animated:YES];
}


- (void) changeTradedItemsStatus {
  PFObject* item = self.trade[@"item"];
  item[@"status"] = @"traded";
  [item saveInBackground];
  NSArray *items = self.trade[@"returnItems"];
  for (PFObject* item in items) {
    item[@"status"] = @"traded";
    [item saveInBackground];
  }
}


@end
