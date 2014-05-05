//
//  BZRNotificationTableViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRNotificationTableViewController.h"
#import "BZRReceiverTradeViewController.h"
#import "BZRInitiatorTradeViewController.h"
#import <Parse/Parse.h>

@interface BZRNotificationTableViewController ()
@property (nonatomic, strong) NSArray* trades;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
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
      NSLog(@" %d notification trades", [self.trades count]);
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

- (NSString *) getFirstName: (NSString*) name {
  NSArray *words = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  return [words objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
    UIImageView *itemImageView = (UIImageView *)[cell.contentView viewWithTag:301];
    UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:302];
  

    PFObject* trade = [self.trades objectAtIndex:indexPath.row];
    PFUser *initiator = [trade objectForKey:@"initiator"];
    PFUser *receiver = [trade objectForKey:@"owner"];
    PFObject* item = [trade objectForKey:@"item"];
  
    //load message
    NSString *message = @"%@ requested %@ from %@";
    NSString *messageText = @"";
    //you initiated the trade
    if ([self isInitiator:trade]) {
      messageText = [NSString stringWithFormat:message, @"You", [item objectForKey:@"name"],
                           [receiver objectForKey:@"username"]];
    }
    //you received the trade
    else {
      messageText = [NSString stringWithFormat:message, [initiator objectForKey:@"username"],
                             [item objectForKey:@"name"], @"you"];
    }
    [messageLabel setText:messageText];
  
    //load image
    PFFile *imageFile = [item objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        itemImageView.image = [UIImage imageWithData:data];
      }
      else {
        NSLog(@"error fetching image");
      }
    }];
    return cell;
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  self.selectedIndexPath = indexPath;
  PFObject* trade = [self.trades objectAtIndex:indexPath.row];
  if ([self isInitiator:trade]) {
      [self performSegueWithIdentifier:@"initiatorTradeDetail" sender:self];
  }
  else {
     [self performSegueWithIdentifier:@"receiverTradeDetail" sender:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"receiverTradeDetail"]) {
      BZRReceiverTradeViewController *receiverTradeView =
        (BZRReceiverTradeViewController *) segue.destinationViewController;
      receiverTradeView.trade = [self.trades objectAtIndex:self.selectedIndexPath.row];
  }
  else if([segue.identifier isEqualToString:@"initiatorTradeDetail"]) {
      BZRInitiatorTradeViewController *initiatorTradeView = (BZRInitiatorTradeViewController *) segue.destinationViewController;
      initiatorTradeView.trade = [self.trades objectAtIndex:self.selectedIndexPath.row];
  }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
