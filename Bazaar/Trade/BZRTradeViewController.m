//
//  BZRTradeViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/19/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRTradeViewController.h"

@interface BZRTradeViewController ()
@property (nonatomic, assign) NSInteger numItems;
@end

@implementation BZRTradeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numReturn.text = @"1";
    self.numItems = 1;
    [self loadTradeData];
}

- (void) loadTradeData {
  PFUser* owner = [self.item objectForKey:@"owner"];
  [owner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (!error) {
        self.itemOwner.text = [owner objectForKey:@"username"];
    }
    else {
      NSLog(@"item owner fetch error");
    }
  }];
  PFFile* imageFile = [self.item objectForKey:@"imageFile"];
  [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    if (!error) {
      self.itemImage.image = [UIImage imageWithData:data];
      self.itemTitle.text = [self.item objectForKey:@"name"];
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

- (IBAction)stepperValueChanged:(id)sender {
    int value = (int) [(UIStepper*)sender value];
    [self.numReturn setText:[NSString stringWithFormat:@"%d", value]];
    self.numItems = value;
}

- (IBAction)sendButton:(id)sender {
  PFObject *trade = [PFObject objectWithClassName:@"Trade"];
  trade[@"item"] = self.item;
  trade[@"owner"] = [self.item objectForKey:@"owner"];
  trade[@"initiator"] = [PFUser currentUser];
  trade[@"status"] = @"initiated";
  trade[@"numItems"] = [NSNumber numberWithInt:self.numItems];
  trade[@"returnItems"] = @[];
  self.sendButtonItem.hidden = true;
  self.sendButtonItem.enabled = false;
  [trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      NSLog(@"saved new initiated trade");
    }
    else {
      NSLog(@"error setting up trade");
    }
  }];

}
@end
