//
//  MasterViewController.m
//  CoffeeKit
//
//  Created by Scott McAlister on 1/21/14.
//  Copyright (c) 2014 4 Arrows Media, LLC. All rights reserved.
//

#import "HIVELoginViewController.h"
#import "Token.h"
#import "Upload.h"
#import "HIVEProfileViewController.h"
#import <RestKit/RestKit.h>

#define kCLIENTID "hive"
#define kCLIENTSECRET "foo"

@interface LoginViewController()

@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) NSString *authToken;

@end

@implementation LoginViewController

@synthesize usernameField, passwordField, resultsField, stepsField, minsField, milesField;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user is already Login
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        
        
        NSLog(@"User is already logged in");
    }
    


}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitForm:(id)sender {
    [self loadWithUsername:usernameField.text andPassword:passwordField.text];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)loadWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];

    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:@"password", @"grant_type", clientID, @"client_id", clientSecret, @"client_secret", username, @"username", password, @"password", nil];
    
    [[RKObjectManager sharedManager] postObject:nil path:@"oauth/token" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Token *token = [mappingResult.array objectAtIndex:0];
        _authToken = token.access_token;
        resultsField.text = [NSString stringWithFormat:@"Token Type: %@\nAccess Token: %@\nExpires In: %@\nRefresh Token: %@", token.token_type, token.access_token, token.expires_in, token.refresh_token];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:usernameField.text forKey:@"username"];
        [defaults setObject:passwordField.text forKey:@"password"];
        [defaults synchronize];
        NSLog(@"Saved to user session to defaults");
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        resultsField.text = @"Invalid login";
        NSLog(@"Error was ': %@", error);
    }];
}

@end
