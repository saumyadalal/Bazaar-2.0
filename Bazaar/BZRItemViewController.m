//
//  BZRItemViewController.m
//  Bazaar
//
//  Created by Saumya Dalal on 4/20/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRItemViewController.h"

@interface BZRItemViewController ()

@end

@implementation BZRItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemTitle.text = [self.item objectForKey:@"name"]; //set item title
    NSLog(@" %@", [self.item objectForKey:@"name"]);
    PFUser *user = [self.item objectForKey:@"owner"]; //get user info
    
    self.itemDescription.text = [self.item objectForKey:@"description"]; //set item description
    PFFile *imageFile = [self.item objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSLog(@"fetched image");
            self.itemPicture.image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"error fetching image");
        }
    }];
    //[self setUserInfo];
}


- (void) setUserInfo {
//    NSLog(@"%@", [PFUser currentUser]);
    //create request for data
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            // Now add the data to the UI elements
            self.profilePicture.profileID = facebookID;
            //self.userName.text = name;
        }
        else{
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)initiateTrade:(id)sender {
}

- (IBAction)addToFavorites:(id)sender {
}
@end
