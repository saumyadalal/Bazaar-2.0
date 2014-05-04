//
//  BZRReceiverTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRReceiverTradeViewController.h"
#import "BZRUserProfileViewController.h"

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

- (IBAction)selectReturnItems:(id)sender {
  BZRUserProfileViewController* profileView = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil]
                                         instantiateViewControllerWithIdentifier:@"userProfileView"];
  profileView.user = [self.trade objectForKey:@"initiator"];
  profileView.inSelectionMode = YES;
  [self.navigationController pushViewController:profileView animated:YES];
  
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
