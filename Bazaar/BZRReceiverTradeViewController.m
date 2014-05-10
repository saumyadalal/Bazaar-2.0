//
//  BZRReceiverTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRReceiverTradeViewController.h"
#import "BZRSelectionViewController.h"
#import "BZRTradeUtils.h"
#import "BZRDesignUtils.h"
#import "BZRNotificationTableViewController.h"

@interface BZRReceiverTradeViewController ()
@property (strong, nonatomic) UIAlertView *sentBidView;
@property (strong, nonatomic) UIAlertView *validBidView;
@property (nonatomic, strong) NSArray* itemImageViews;
@end

@implementation BZRReceiverTradeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemImageViews = @[self.itemImage1, self.itemImage2, self.itemImage3];
    [self loadContent];
    [self.itemImage1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.itemImage1 setTintColor:[UIColor grayColor]];
    self.sentBidView = [[UIAlertView alloc] initWithTitle:@"Bid Sent" message:@"You have sent your bid!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    self.validBidView = [[UIAlertView alloc] initWithTitle:@"Please edit your bid" message:@"One or more items are no longer available for trade" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
  self.sendButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:13];
  self.selectButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.bidLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:15];
  self.bidLabel.textColor = [BZRDesignUtils placeHolderLightGrey];
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

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateContent];
}

- (void) updateContent {
  [self.tradeLabel setText:self.tradeMessage];
  //load return item images
  [self updateDisplay];
  [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
}

/************************
 *** Begin: Update content
 ************************/


//update bid message and button display
- (void) updateDisplay {
  NSString* status = [self.trade objectForKey:@"status"];
  if ([status isEqualToString:@"responded"]) {
    [self.bidMessageLabel setText:@"Bid request sent"];
    [self.sendButton setHidden:YES];
    [self.selectButton setHidden:YES];
  }
  else {
    NSUInteger limit = [[self.trade objectForKey:@"numItems"] intValue];
    NSString* firstName = [BZRTradeUtils getFirstNameOwnerFormat:[self.trade objectForKey:@"initiator"]];
    NSString* baseStr = @"You can choose upto %d items from %@ marketplace";
    [self.bidMessageLabel setText:[NSString stringWithFormat:baseStr, limit, firstName]];
    [self configureSendAndSelectButton];
  }
  //hide the send button since trade is completed or cancelled
  if ([status isEqualToString:@"cancelled"]) {
    [self inactivateTrade:@"Trade has been cancelled"];
  }
  else if ([status isEqualToString:@"unavailable"]) {
    [self inactivateTrade:@"Item(s) no longer available"];
  }
}

- (void) inactivateTrade:(NSString*)message {
  [self.sendButton setHidden:YES];
  [self.cancelTradeButton setHidden:YES];
  [self.selectButton setHidden:YES];
  [self.greyOverlay setHidden:NO];
  [self.greyOverlay setBackgroundColor:[BZRDesignUtils greyOverlayColor]];
  [self.greyOverlay setText:message];
  [self.view setUserInteractionEnabled:NO];
}

- (void) configureSendAndSelectButton {
  [self.sendButton setHidden:NO];
  if ([self.trade[@"returnItems"] count] == 0) {
    [self.sendButton setEnabled:NO];
    [self.sendButton setBackgroundColor:[BZRDesignUtils buttonDisabledColor]];

  }
  else {
    [self.sendButton setEnabled:YES];
    [self.sendButton setBackgroundColor:[BZRDesignUtils purpleColor]];
  }
}



/******************
 *** End: Update content
 ******************/



/*
- (void) uploadGesture {
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
  singleTap.numberOfTapsRequired = 1;
  for (int i = 0; i < [self.itemImageViews count]; i++) {
    UIImageView* imageView = [self.itemImageViews objectAtIndex:i];
    if (imageView.image != nil) {
      [imageView removeGestureRecognizer:singleTap];
    }
    else {
      imageView.userInteractionEnabled = YES;
      [imageView addGestureRecognizer:singleTap];
      break;
    }
  }
}

- (void) tapDetected{
  NSLog(@"single Tap on imageview");
  
} */



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"selectionViewSegue"]) {
    UINavigationController* navigationController = (UINavigationController *) segue.destinationViewController;
    BZRSelectionViewController *selectionView = (BZRSelectionViewController *)navigationController.topViewController;
    selectionView.user = [self.trade objectForKey:@"initiator"];
    selectionView.trade = self.trade;
  }
}

- (IBAction)cancelTrade:(id)sender {
  self.greyOverlay.hidden = false;
  [BZRTradeUtils cancelTrade:self.trade];
  [BZRTradeUtils updateSeenStatus:NO forTrade:self.trade forSelf:NO];
  [self inactivateTrade:@"Trade has been cancelled"];
}

- (IBAction)sendBid:(id)sender {
    BOOL isAvailable = [self isAvailableReturnItems];
    if (isAvailable) {
      [self sendSuccessfulBid];
    }
    else {
      [self.validBidView show];
      [self updateContent];
    }
}

- (void) sendSuccessfulBid {
  self.trade[@"status"] = @"responded";
  [BZRTradeUtils updateSeenStatus:NO forTrade:self.trade forSelf:NO];
  [self.trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      NSLog(@"saved updated trade status");
    }
    else {
      NSLog(@"error changing trade status");
    }
  }];
  self.sendButton.hidden = true;
  self.selectButton.hidden = true;
  [self.sentBidView show];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

//*** call [item fetch] to make sure we have the most up to date
//information on the item!!!!!
- (BOOL) isAvailableReturnItems {
  BOOL available = YES;
  NSMutableArray* returnItems = [self.trade objectForKey:@"returnItems"];
  for (PFObject* item in returnItems) {
    [item fetch];
    if ([[item objectForKey:@"status"] isEqualToString:@"traded"]) {
      [returnItems removeObject:item];
      available = NO;
    }
  }
  return available;
}




@end
