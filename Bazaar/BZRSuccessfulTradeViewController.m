//
//  BZRSuccessfulTradeViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 5/7/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRSuccessfulTradeViewController.h"
#import "BZRTradeUtils.h"

@interface BZRSuccessfulTradeViewController ()
@property (nonatomic, strong) NSArray* itemImageViews;

@end

@implementation BZRSuccessfulTradeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser* owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    NSNumber *numItems = [self.trade objectForKey:@"numItems"];
    if([numItems isEqualToNumber:@1]) {
        self.itemImageViews = @[self.returnItemImage_1];
        [BZRTradeUtils loadImage:self.keyItemImage_1 fromItem:[self.trade objectForKey:@"item"]];
    }
    else if ([numItems isEqualToNumber:@2]) {
        self.itemImageViews = @[self.itemImage2_1, self.itemImage2_2];
        [BZRTradeUtils loadImage:self.keyItemImage fromItem:[self.trade objectForKey:@"item"]];
    }
    else if ([numItems isEqualToNumber:@3]) {
        self.itemImageViews = @[self.itemImage1, self.itemImage2, self.itemImage3];
        [BZRTradeUtils loadImage:self.keyItemImage fromItem:[self.trade objectForKey:@"item"]];
    }
    [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
  
    self.successLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:35];
    //set user profile pictures
    [BZRTradeUtils loadCircularImage:self.ownerImage fromObject:owner];
    [BZRTradeUtils loadCircularImage:self.initiatorImage fromObject:initiator];
    [self setUsersLabel];
    [self setFont];
}

- (void) setUsersLabel {
    self.usersLabel.text = [BZRTradeUtils getStatusMessage:self.trade forUser:[PFUser currentUser]];
}

- (void) setFont {
    self.usersLabel.font = [UIFont fontWithName:@"Gotham-Book" size:14];
    self.successLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:30];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)launchMessenger:(id)sender {
 // NSString* url = "fb-messenger://user-thread/{user-id}
  NSLog(@"launch messenger");
  NSURL *url = [NSURL URLWithString:@"fb://messaging/compose"];
  [[UIApplication sharedApplication] openURL:url];
}


@end
