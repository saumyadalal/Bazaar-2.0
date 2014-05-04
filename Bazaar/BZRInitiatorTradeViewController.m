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
    NSLog(@"trade: %@",self.trade);
    self.itemTitle.text =[[self.trade objectForKey:@"item"] objectForKey:@"name"];
    self.ownerLabel1.text = [[self.trade objectForKey:@"owner"] username];
    self.ownerLabel2.text = [[self.trade objectForKey:@"owner"] username];
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

@end
