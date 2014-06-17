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
#import "UIImage+animatedGIF.h"
#import <RestKit/RestKit.h>

#define kCLIENTID "hive"
#define kCLIENTSECRET "foo"

@interface LoginViewController()

@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) NSString *authToken;

@end

@implementation LoginViewController

@synthesize usernameField, passwordField, dataImageView;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"giphy" withExtension:@"gif"];
    self.dataImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        NSLog(@"User is already logged in");
        
        [self performSegueWithIdentifier:@"mainSegue" sender:self];
//        [self presentModalViewController:NULL animated:YES];
    } else {
        [self configureRestKit];
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



- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://hive.gt/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
//    // setup object mappings
    RKObjectMapping *tokenMapping = [RKObjectMapping mappingForClass:[Token class]];
    [tokenMapping addAttributeMappingsFromArray:@[@"access_token", @"expires_in", @"refresh_token", @"token_type"]];

//    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tokenMapping method:RKRequestMethodPOST pathPattern:@"oauth/token" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKObjectMapping *stepsMapping = [RKObjectMapping mappingForClass:[Upload class]];
    [stepsMapping addAttributeMappingsFromArray:@[@"username", @"steps", @"mins", @"miles"]];
    
    RKResponseDescriptor *stepsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stepsMapping method:RKRequestMethodPOST pathPattern:@"upload/json" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];

    NSArray *arr = @[responseDescriptor, stepsDescriptor];
    [objectManager addResponseDescriptorsFromArray:arr];

}

- (void)loadWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];

    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:@"password", @"grant_type", clientID, @"client_id", clientSecret, @"client_secret", username, @"username", password, @"password", nil];
    
    [[RKObjectManager sharedManager] postObject:nil path:@"oauth/token" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Token *token = [mappingResult.array objectAtIndex:0];
        _authToken = token.access_token;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:usernameField.text forKey:@"username"];
        [defaults setObject:passwordField.text forKey:@"password"];
        [defaults setObject:token.access_token forKey:@"auth_token"];

        [defaults synchronize];
        NSLog(@"Saved to user session to defaults");
        [self performSegueWithIdentifier:@"mainSegue" sender:self];

        NSLog(@"We are logged in");
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error was ': %@", error);
    }];
}

@end
