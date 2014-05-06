//
//  BZRNewPostViewController.h
//  Bazaar
//
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BZRNewPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)editPicture:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UITextField *itemName;
@property (strong, nonatomic) IBOutlet UITextField *category;
- (IBAction)resign:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *addObject;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postButton;

@end
