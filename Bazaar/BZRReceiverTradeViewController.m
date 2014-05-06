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
    
    //self.itemTitle.text =[[self.trade objectForKey:@"item"] objectForKey:@"name"];
    //self.initiatorLabel.text = [[self.trade objectForKey:@"initiator"] username];
    self.initiatorLabel2.text = [[self.trade objectForKey:@"initiator"] username];
    NSNumber *numItems = [self.trade objectForKey:@"numItems"];
    //self.numItems.text = [NSString stringWithFormat:@"%@", numItems];
    PFFile *imageFile = [[self.trade objectForKey:@"item"] objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.itemImage.image = [UIImage imageWithData:data];
            }
            else {
                NSLog(@"error fetching image");
            }
        }];
    self.itemImage1.backgroundColor = [UIColor grayColor];
    if([numItems isEqual:@2]) {
        self.itemImage2.backgroundColor = [UIColor grayColor];
    }
    else if([numItems isEqual:@2]) {
        self.itemImage2.backgroundColor = [UIColor grayColor];
        self.itemImage3.backgroundColor = [UIColor grayColor];
    }
    NSArray *items = [self.trade objectForKey:@"returnItems"];;
    if(sizeof(items) > 0)
    {
        for (PFObject* item in items) {
            //call this to fetch image data
            [item fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    PFFile *imageFile = [item objectForKey:@"imageFile"];
                    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            if(self.itemImage1.image == nil) {
                                self.itemImage1.image = [UIImage imageWithData:data];
                            }
                            else if(self.itemImage2.image == nil) {
                                self.itemImage2.image = [UIImage imageWithData:data];
                            }
                            else if(self.itemImage3.image == nil) {
                                self.itemImage3.image = [UIImage imageWithData:data];
                            }
                        }
                        else {
                            NSLog(@"error fetching image");
                        }
                    }];
                }
                else {
                    NSLog(@"error fetching data");
                }
            }];        }
    }
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
