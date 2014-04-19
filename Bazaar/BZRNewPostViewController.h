//
//  BZRNewPostViewController.h
//  Bazaar
//
//  Created by Brian Oldak on 4/6/14.
//  Copyright (c) 2014 cmu.barter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZRNewPostViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)editPicture:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *itemPic;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) IBOutlet UITextField *categoryTF;
- (IBAction)resign:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UITextField *titleField;


@end
