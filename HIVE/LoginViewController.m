//
//  MasterViewController.m
//  CoffeeKit
//
//  Created by Scott McAlister on 1/21/14.
//  Copyright (c) 2014 4 Arrows Media, LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "Token.h"
#import "Upload.h"
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
    [usernameField setDelegate:self];
    [passwordField setDelegate:self];
    [stepsField setDelegate:self];
    [minsField setDelegate:self];
    [milesField setDelegate:self];


    [self configureRestKit];
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

-(IBAction)uploadSteps:(id)sender {
    [self addSteps:stepsField.text mins:minsField.text miles:milesField.text];
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
-(void)addSteps:(NSString *)steps mins:(NSString *)mins miles:(NSString *)miles {
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:steps, @"steps", mins, @"mins", miles, @"miles", nil];
    
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", _authToken]];
    [[RKObjectManager sharedManager] postObject:nil path:@"upload/json" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Upload *steps = [mappingResult.array objectAtIndex:0];
        resultsField.text = [NSString stringWithFormat:@"%@ steps upload to %@.\n %@ had %@ steps, %@ mins, %@ miles", stepsField.text, steps.username, steps.username, steps.steps, steps.mins, steps.miles];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        resultsField.text = @"Invalid upload";
        NSLog(@"Error was ': %@", error);
    }];
    
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
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        resultsField.text = @"Invalid login";
        NSLog(@"Error was ': %@", error);
    }];
}

@end
