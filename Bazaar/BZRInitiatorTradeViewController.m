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
    [self setFont];
}

- (void) setBidMessage {
  NSString* status = [self.trade objectForKey:@"status"];
  // *** responded status
  if ([status isEqualToString:@"responded"]) {
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
  else {
    [self.acceptButton setEnabled:NO];
    [self.cancelTradeButton setHidden:YES];
    if ([status isEqualToString:@"accepted"]) {
      [self.acceptButton setTitle:@"Trade Success!" forState:UIControlStateDisabled];
    }
    else {
      [self.acceptButton setTitle:@"Trade Cancelled" forState:UIControlStateDisabled];
    }
  }
}


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateContent];
}


- (void) updateContent {
  [self.tradeLabel setText:self.tradeMessage];
  [self setBidMessage];
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
  [BZRTradeUtils cancelTrade:self.trade];
    [self.navigationController popToRootViewControllerAnimated:YES];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParent" object:nil];
}
- (IBAction)acceptTrade:(id)sender {
    self.trade[@"status"] = @"complete";
    [self.trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved updated trade status");
        }
        else {
            NSLog(@"error changing trade status");
        }
    }];
    self.acceptButton.enabled = false;
    self.acceptButton.hidden = true;
    self.cancelTradeButton.hidden = true;
    self.cancelTradeButton.enabled = false;
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
