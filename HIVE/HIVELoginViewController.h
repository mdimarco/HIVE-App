//
//  MasterViewController.h
//  CoffeeKit
//
//  Created by Scott McAlister on 1/21/14.
//  Copyright (c) 2014 4 Arrows Media, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UIImageView *dataImageView;

-(IBAction)submitForm:(id)sender;

@end
