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
	// Do any additional setup after loading the view.
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
  [self.navigationController pushViewController:profileView animated:YES];
  
}
@end
