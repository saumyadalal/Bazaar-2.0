//
//  BZRLoginViewController.m
//  Bazaar
//
//  Created by Shikhara Nalla on 4/1/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import "BZRLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "BZRFilterViewController.h"
#import "BZRTabBarController.h"

@interface BZRLoginViewController () <FBLoginViewDelegate, NSURLConnectionDelegate>
@property (strong, nonatomic) SWRevealViewController *revealController;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *facebookID;
@end

static NSString* const URLformat = @"https://graph.facebook.com/%@/picture?&height=200&type=normal&width=200";

@implementation BZRLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle: nil];
    self.revealController = (SWRevealViewController *)[mainStoryboard
                            instantiateViewControllerWithIdentifier:@"revealViewController"];
}

//Place this in viewDidAppear since the reveal controller cannot be presented yet in
//viewDidLoad
- (void)viewDidAppear:(BOOL)animated {
  /* After a user logs in, Parse will automatically cache the Facebook and Parse sessions in the currentUser object.
   By pass login screen if logged in*/
  if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
    [self presentViewController:self.revealController animated:NO completion:nil];
  }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUser:(id)sender {
  NSArray *permissionsArray = @[ @"user_about_me"];
  //initialize facebook
  [PFFacebookUtils initializeFacebook];
  // Login PFUser using Facebook
  [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    if (!user) {
      if (!error) {
        NSLog(@"The user cancelled the Facebook login.");
      } else {
        NSLog(@"An error occurred: %@", error);
      }
    }
    else {
      if (user.isNew) {
          NSLog(@"User with facebook signed up and logged in!");
          user[@"favorites"] = [NSMutableArray array];
          [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              if (!error) {
                  NSLog(@"favorites initialized");
              }
              else {
                  NSLog(@"error initializing favorites");
              }
          }];
      } else {
        NSLog(@"User with facebook logged in!");
      }
      [self presentViewController:self.revealController animated:YES completion:nil];
      [self setUserInfo];
    }
  }];
}

- (void) setUserInfo {
  //create request for data
  FBRequest *request = [FBRequest requestForMe];
  // Send request to Facebook to fetch user data and store into database
  [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      NSDictionary *userData = (NSDictionary *)result;
      //store name and image data
      self.username = userData[@"name"];
      self.facebookID = userData[@"id"];
      self.imageData = [[NSMutableData alloc] init];
      NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:URLformat, self.facebookID]];
      NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:imageURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:2.0f];
      // Run network request asynchronously
      NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    }
    else{
      NSLog(@"%@", error);
    }
  }];
  PFObject *numTrades = [PFObject objectWithClassName:@"TradeUser"];
  numTrades[@"user"]=[PFUser currentUser];
  numTrades[@"numTrades"]=@0;
  [numTrades saveInBackground];
}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  // Set the image in the header imageView
  PFUser *user = [PFUser currentUser];
  PFFile *imageFile = [PFFile fileWithName:@"profilePicture.png" data:self.imageData];
  user[@"imageFile"] = imageFile;
  user[@"username"] = self.username;
  user[@"facebookID"] = self.facebookID;
  user[@"numTrades"] = @0;
    user[@"numItems"] = @0;
  [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      NSLog(@"successfully saved new user info");
    }
    else {
      NSLog(@"error saving new user info");
    }
  }];
}



@end