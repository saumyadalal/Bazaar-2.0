//
//  BZRNewPostViewController.h
//  Bazaar
//
//  Created by Brian Oldak on 4/6/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRNewPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)editPicture:(id)sender;
- (IBAction)resign:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UITextField *itemName;
@property (strong, nonatomic) IBOutlet UITextField *category;

- (IBAction)postPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@end
