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
    if([numItems isEqualToNumber:@1])
        self.itemImageViews = @[self.itemImage2];
    else if ([numItems isEqualToNumber:@2])
        self.itemImageViews = @[self.itemImage2_1, self.itemImage2_2];
    else if ([numItems isEqualToNumber:@3])
        self.itemImageViews = @[self.itemImage1, self.itemImage2, self.itemImage3];
    [BZRTradeUtils loadReturnItemImages:self.itemImageViews forTrade:self.trade];
    [BZRTradeUtils loadImage:self.keyItemImage fromItem:[self.trade objectForKey:@"item"]];
    self.successLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:35];
    self.tradedLabel.font = [UIFont fontWithName:@"Gotham-Book" size:20];
    //set user profile pictures
    [BZRTradeUtils loadCircularImage:self.ownerImage fromObject:owner];
    [BZRTradeUtils loadCircularImage:self.initiatorImage fromObject:initiator];
    [self setUsersLabel];
    [self setFont];
}

- (void) setUsersLabel {
    PFUser* owner = [self.trade objectForKey:@"owner"];
    PFUser *initiator = [self.trade objectForKey:@"initiator"];
    NSString *ownerName = [BZRTradeUtils getFirstName:owner];
    NSString *initiatorName = [BZRTradeUtils getFirstName:initiator];
    NSString *combined = [NSString stringWithFormat:@"%@ & %@", ownerName, initiatorName];
    self.usersLabel.text = combined;
}

- (void) setFont {
    self.usersLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:17];
    self.successLabel.font = [UIFont fontWithName:@"Gotham-Book" size:30];
    self.tradedLabel.font = [UIFont fontWithName:@"Gotham-Book" size:17];
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
