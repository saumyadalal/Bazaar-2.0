//
//  BZRReceiverTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRReceiverTradeViewController.h"
#import "BZRSelectionViewController.h"

@interface BZRReceiverTradeViewController ()

@end

@implementation BZRReceiverTradeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemTitle.text =[[self.trade objectForKey:@"item"] objectForKey:@"name"];
    self.initiatorLabel.text = [[self.trade objectForKey:@"initiator"] username];
    self.initiatorLabel2.text = [[self.trade objectForKey:@"initiator"] username];
    self.numItems.text = [NSString stringWithFormat:@"%@", [self.trade objectForKey:@"numItems"]];
    PFFile *imageFile = [[self.trade objectForKey:@"item"] objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.itemImage.image = [UIImage imageWithData:data];
            }
            else {
                NSLog(@"error fetching image");
            }
        }];
}



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


- (IBAction)cancelButton:(id)sender {
    NSString *objectId = [self.trade objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"Trade"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"canceled trade");
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"error canceling trade");
        }
    }];
}
@end
