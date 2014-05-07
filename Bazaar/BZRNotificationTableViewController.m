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
#import <Parse/Parse.h>

@interface BZRNotificationTableViewController ()
@property (nonatomic, strong) NSArray* trades;
@end

static NSString * const cellIdentifier = @"NotificationCell";

@implementation BZRNotificationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNotifications];
    self.title = @"Notifications";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"appear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotifications) name:@"updateParent" object:nil];
    [super viewWillAppear:animated];
    [self loadNotifications];
    self.title = @"Notifications";
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
  
    [self setMessage:messageLabel forTrade:trade];
    [BZRTradeUtils loadImage:itemImageView fromItem:item];
  
    return cell;
}

- (void) setMessage:(UILabel*) messageLabel forTrade:(PFObject*)trade {
  PFUser *initiator = [trade objectForKey:@"initiator"];
  PFUser *receiver = [trade objectForKey:@"owner"];
  PFObject* item = [trade objectForKey:@"item"];
  
  NSString *message = @"%@ requested %@ %@";
  NSString *messageText = @"";
  //you initiated the trade
  if ([self isInitiator:trade]) {
    messageText = [NSString stringWithFormat:message, @"You",
                   [BZRTradeUtils getFirstNameOwnerFormat:receiver],
                   [item objectForKey:@"name"]];
  }
  //you received the trade
  else {
    messageText = [NSString stringWithFormat:message, [initiator objectForKey:@"username"],
                   @"your", [item objectForKey:@"name"]];
  }
  [messageLabel setText:messageText];
}

- (BOOL) isInitiator:(PFObject*)trade {
  PFUser *initiator = [trade objectForKey:@"initiator"];
  PFUser *user = [PFUser currentUser];
  //[initator objectForKey: objectId does not work
  if ([[user objectId] isEqualToString:[initiator objectId]]) {
    return YES;
  }
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PFObject* trade = [self.trades objectAtIndex:indexPath.row];
    NSString *status = [trade objectForKey:@"status"];
    if([status isEqualToString:@"complete"]) {
        [self performSegueWithIdentifier:@"successfulTradeDetail" sender:self];
    }
  else if ([self isInitiator:trade]) {
      [self performSegueWithIdentifier:@"initiatorTradeDetail" sender:self];
  }
  else {
     [self performSegueWithIdentifier:@"receiverTradeDetail" sender:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSIndexPath *selectedIndexPath = [[self.tableView indexPathsForSelectedRows] objectAtIndex:0];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
  UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:302];
  if ([segue.identifier isEqualToString:@"receiverTradeDetail"]) {
      BZRReceiverTradeViewController *receiverTradeView =
        (BZRReceiverTradeViewController *) segue.destinationViewController;
      receiverTradeView.trade = [self.trades objectAtIndex:selectedIndexPath.row];
      receiverTradeView.tradeMessage = [messageLabel text];
      self.title = @"Back";
  }
  else if([segue.identifier isEqualToString:@"initiatorTradeDetail"]) {
      BZRInitiatorTradeViewController *initiatorTradeView = (BZRInitiatorTradeViewController *) segue.destinationViewController;
      initiatorTradeView.trade = [self.trades objectAtIndex:selectedIndexPath.row];
      initiatorTradeView.tradeMessage = [messageLabel text];
      self.title = @"Back";
  }
    else if([segue.identifier isEqualToString:@"successfulTradeDetail"]) {
        BZRSuccessfulTradeViewController *successfulTradeView = (BZRSuccessfulTradeViewController *) segue.destinationViewController;
        successfulTradeView.trade = [self.trades objectAtIndex:selectedIndexPath.row];
    }
}

@end
