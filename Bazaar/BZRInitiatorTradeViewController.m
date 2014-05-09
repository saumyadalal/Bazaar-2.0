//
//  BZRInitiatorTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRInitiatorTradeViewController.h"
#import "BZRTradeUtils.h"
#import "BZRDesignUtils.h"
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
  [self loadContent];
  [self.itemImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.itemImage1 setTintColor:[UIColor grayColor]];
}

/******************
 *** Load content start
 ******************/

- (void) loadContent {
  [BZRTradeUtils loadImage:self.itemImage fromItem:[self.trade objectForKey:@"item"]];
  PFUser* owner = [self.trade objectForKey:@"owner"];
  PFUser *initiator = [self.trade objectForKey:@"initiator"];
  [BZRTradeUtils loadCircularImage:self.ownerImage fromObject:owner];
  [BZRTradeUtils loadCircularImage:self.initiatorImage fromObject:initiator];
  [self setUsersLabel];
  [self setFont];
  
}

- (void) setFont {
  self.cancelTradeButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.acceptButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.bidLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:15];
  self.bidStatusLabel.font = [UIFont fontWithName:@"Gotham-Book" size:14];
  self.greyOverlay.font = [UIFont fontWithName:@"Gotham-Medium" size:17];
  self.usersLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:17];
  [self.greyOverlay setHidden: YES];
}

- (void) setUsersLabel {
  PFUser* owner = [self.trade objectForKey:@"owner"];
  PFUser *initiator = [self.trade objectForKey:@"initiator"];
  NSString *ownerName = [BZRTradeUtils getFirstName:owner];
  NSString *initiatorName = [BZRTradeUtils getFirstName:initiator];
  NSString *combined = [NSString stringWithFormat:@"%@ & %@", initiatorName, ownerName];
  [self.usersLabel setText:combined];
}

/******************
 *** Load content end
 ******************/


/******************
 *** Start: Update content
 ******************/

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
  else {
    //display no images yet
    [self.acceptButton setHidden:YES];
  }
}

- (void) updateDisplay {
  NSString* status = [self.trade objectForKey:@"status"];
  if ([status isEqualToString:@"responded"]) {
    [self.acceptButton setHidden:NO];
    [self.bidStatusLabel setHidden:YES];
    [self.bidMessageLabel setText:@"Bid request received"];
  }
  else {
    //no bids available yet
    [self.bidStatusLabel setHidden:NO];
    NSUInteger limit = [[self.trade objectForKey:@"numItems"] intValue];
    NSString* firstName = [BZRTradeUtils getFirstName:[self.trade objectForKey:@"owner"]];
    NSString* baseStr = @"%@ can choose upto %d items from your marketplace";
    [self.bidMessageLabel setText:[NSString stringWithFormat:baseStr, firstName, limit]];
    [self.acceptButton setHidden:YES];
  }
  // trade is cancelled
  if ([status isEqualToString:@"cancelled"]) {
    [self inactivateTrade];
  }
}


- (void) inactivateTrade {
  [self.bidStatusLabel setHidden:YES];
  [self.acceptButton setHidden:YES];
  [self.cancelTradeButton setHidden:YES];
  [self.greyOverlay setHidden:NO];
  [self.greyOverlay setBackgroundColor:[BZRDesignUtils greyOverlayColor]];
  [self.greyOverlay setText:@"This trade has been cancelled"];
  [self.view setUserInteractionEnabled:NO];
}


/******************
 *** End: Update content
 ******************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTrade:(id)sender {
  self.greyOverlay.hidden = false;
  [BZRTradeUtils cancelTrade:self.trade];
  [BZRTradeUtils updateSeenStatus:NO forTrade:self.trade forSelf:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptTrade:(id)sender {
    self.trade[@"status"] = @"complete";
    [BZRTradeUtils updateSeenStatus:NO forTrade:self.trade forSelf:NO];
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
