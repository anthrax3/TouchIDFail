//
//  ViewController.h
//  TouchIDTesting
//
//  Created by David Lindner on 9/28/15.
//  Copyright © 2015 David Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)textSubmit:(id)sender;
- (IBAction)authenticateButtonTapped1:(id)sender;
- (IBAction)authenticateButtonTapped2:(id)sender;
- (IBAction)authenticateButtonTapped3:(id)sender;
- (IBAction)keychainButtonTapped:(id)sender;

@end

