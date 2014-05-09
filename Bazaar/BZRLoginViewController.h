//
//  BZRLoginViewController.h
//  Bazaar
//
//  Created by Shikhara Nalla on 4/1/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZRLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginUser:(id)sender;

@end
