//
//  BZRInitiatorTradeViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 5/4/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRInitiatorTradeViewController.h"

@interface BZRInitiatorTradeViewController ()

@end

@implementation BZRInitiatorTradeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cancelTradeButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13]; //cancel trade button font
    self.acceptButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13]; //accept button font
    NSLog(@"trade: %@",self.trade);
    PFFile *imageFile = [[self.trade objectForKey:@"item"] objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.itemImage.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"error fetching image");
        }
    }];
    NSString *status = [self.trade objectForKey:@"status"];
    NSArray *items = [self.trade objectForKey:@"returnItems"];
    if([status isEqualToString:(@"responded")] && (sizeof(items) > 0))
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

- (IBAction)cancelTrade:(id)sender {
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
