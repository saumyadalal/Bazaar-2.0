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
#import "BZRNotificationTableViewController.h"

@interface BZRReceiverTradeViewController ()
@property (strong, nonatomic) UIAlertView *sentBidView;
@property (nonatomic, strong) NSArray* itemImageViews;
@end

@implementation BZRReceiverTradeViewController

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
    [self setBidMessage];
    [self setFont];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateContent];
    if ([[self.trade objectForKey:@"status"] isEqual: @"cancelled"]) {
        UIAlertView* cancelledView = [[UIAlertView alloc] initWithTitle:@"Trade Cancelled" message:@"This trade has been cancelled." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [cancelledView show];
    }
}

- (void) updateContent {
  
  [self.tradeLabel setText:self.tradeMessage];
  //load return item images
  [self setBidMessage];
  [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
}

/******************
 *** Update content
 ******************/
- (void) setUsersLabel {
    PFUser* owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    NSString *ownerName = [BZRTradeUtils getFirstName:owner];
    NSString *initiatorName = [BZRTradeUtils getFirstName:initiator];
    NSString *combined = [NSString stringWithFormat:@"%@ & %@", initiatorName, ownerName];
    self.usersLabel.text = combined;
    self.usersLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:17];
}

- (void) setBidMessage {
  NSString* status = [self.trade objectForKey:@"status"];
  if ([status isEqualToString:@"responded"]) {
    [self.bidMessageLabel setText:@"Bid request sent"];
    [self.sendButton setHidden:YES];
    self.selectButton.enabled = false;
    self.selectButton.hidden = true;
  }
  else if ([status isEqualToString:@"initiated"]) {
    NSUInteger limit = [[self.trade objectForKey:@"numItems"] intValue];
    NSString* firstName = [BZRTradeUtils getFirstNameOwnerFormat:[self.trade objectForKey:@"initiator"]];
    NSString* baseStr = @"You can choose upto %d items from %@ marketplace";
    [self.bidMessageLabel setText:[NSString stringWithFormat:baseStr, limit, firstName]];
    [self configureSendButton];
  }
  //hide the send button since trade is completed or cancelled
  else {
    [self.sendButton setHidden:YES];
  }
}

- (void) configureSendButton {
  [self.sendButton setHidden:NO];
  if ([self.trade[@"returnItems"] count] == 0) {
    [self.sendButton setEnabled:NO];
    [self.sendButton setBackgroundColor:[UIColor grayColor]];
  }
  else {
    [self.sendButton setEnabled:YES];
    [self.sendButton setBackgroundColor:[UIColor purpleColor]];
  }
}



/******************
 *** End: Update content
 ******************/

- (void) setFont {
  self.cancelTradeButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.sendButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
  self.selectButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
}

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
  [BZRTradeUtils cancelTrade:self.trade];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParent" object:nil];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)sendBid:(id)sender {
    self.trade[@"status"] = @"responded";
    [self.trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved updated trade status");
        }
        else {
            NSLog(@"error changing trade status");
        }
    }];
    self.sendButton.enabled = false;
    self.sendButton.hidden = true;
    self.selectButton.enabled = false;
    self.selectButton.hidden = true;
    self.sentBidView = [[UIAlertView alloc] initWithTitle:@"Bid Sent" message:@"You have sent your bid!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [self.sentBidView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
