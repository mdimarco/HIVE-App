//
//  HIVERegisterViewController.h
//  HIVE
//
//  Created by Mason Dimarco on 6/15/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIVERegisterViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *ageField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;

-(IBAction)submitForm:(id)sender;

@end
