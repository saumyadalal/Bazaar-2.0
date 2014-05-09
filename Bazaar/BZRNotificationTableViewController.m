//
//  BZRNotificationTableViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRNotificationTableViewController.h"
#import "BZRReceiverTradeViewController.h"
#import "BZRSuccessfulTradeViewController.h"
#import "BZRInitiatorTradeViewController.h"
#import "BZRTradeUtils.h"
#import "BZRDesignUtils.h"
#import <Parse/Parse.h>

@interface BZRNotificationTableViewController ()
@property (nonatomic, strong) NSArray* trades;
@end

static NSString * const cellIdentifier = @"NotificationCell";

@implementation BZRNotificationTableViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotifications) name:@"updateParent" object:nil];
    [super viewWillAppear:animated];
    [self loadNotifications];
    self.title = @"Trades";
}

- (void)loadNotifications
{
  PFQuery *initiatorQuery = [PFQuery queryWithClassName:@"Trade"];
  [initiatorQuery whereKey:@"initiator" equalTo:[PFUser currentUser]];
  PFQuery *ownerQuery = [PFQuery queryWithClassName:@"Trade"];
  [ownerQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
  PFQuery *query = [PFQuery orQueryWithSubqueries:@[initiatorQuery, ownerQuery]];
  //load item data too
  [query includeKey:@"item"];
  [query includeKey:@"owner"];
  [query includeKey:@"initiator"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      self.trades = objects;
      [self.tableView reloadData];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.trades count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
    UIImageView *itemImageView = (UIImageView *)[cell.contentView viewWithTag:301];
    UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:302];

    PFObject* trade = [self.trades objectAtIndex:indexPath.row];
    PFObject* item = [trade objectForKey:@"item"];
    NSDictionary* seen = [trade objectForKey:@"seen"];
    NSString* wasSeen = [seen objectForKey:[[PFUser currentUser] objectId]];
    if ([wasSeen isEqualToString:@"no"]) {
      [BZRDesignUtils showSeenStatus:NO forCell:cell];
    }
    [self setMessage:messageLabel forTrade:trade];
    [BZRTradeUtils loadImage:itemImageView fromItem:item];
  
    return cell;
}

- (void) setMessage:(UILabel*) messageLabel forTrade:(PFObject*)trade {
  PFUser* user = [PFUser currentUser];
  NSString* message = [BZRTradeUtils getStatusMessage:trade forUser:user];
  [messageLabel setText:message];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject* trade = [self.trades objectAtIndex:indexPath.row];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //notification has been read
    [BZRTradeUtils updateSeenStatus:YES forTrade:trade forSelf:YES];
    [BZRDesignUtils showSeenStatus:YES forCell:cell];
    NSString *status = [trade objectForKey:@"status"];
    if([status isEqualToString:@"complete"]) {
        [self performSegueWithIdentifier:@"successfulTradeDetail" sender:self];
    }
    else if ([BZRTradeUtils isInitiator:[PFUser currentUser] forTrade:trade]) {
      [self performSegueWithIdentifier:@"initiatorTradeDetail" sender:self];
    }
    else {
     [self performSegueWithIdentifier:@"receiverTradeDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSIndexPath *selectedIndexPath = [[self.tableView indexPathsForSelectedRows] objectAtIndex:0];
  PFObject* trade = [self.trades objectAtIndex:selectedIndexPath.row];
  PFUser* user = [PFUser currentUser];
  if ([segue.identifier isEqualToString:@"receiverTradeDetail"]) {
      BZRReceiverTradeViewController *receiverTradeView =
        (BZRReceiverTradeViewController *) segue.destinationViewController;
      receiverTradeView.trade = [self.trades objectAtIndex:selectedIndexPath.row];
      receiverTradeView.tradeMessage = [BZRTradeUtils getTradeInitiatedMessage:trade forUser:user];
  }
  else if([segue.identifier isEqualToString:@"initiatorTradeDetail"]) {
      BZRInitiatorTradeViewController *initiatorTradeView = (BZRInitiatorTradeViewController *) segue.destinationViewController;
      initiatorTradeView.trade = [self.trades objectAtIndex:selectedIndexPath.row];
      initiatorTradeView.tradeMessage = [BZRTradeUtils getTradeInitiatedMessage:trade forUser:user];
  }
    else if([segue.identifier isEqualToString:@"successfulTradeDetail"]) {
        BZRSuccessfulTradeViewController *successfulTradeView = (BZRSuccessfulTradeViewController *) segue.destinationViewController;
        successfulTradeView.trade = [self.trades objectAtIndex:selectedIndexPath.row];
    }
}

@end
