//
//  HIVERegisterViewController.m
//  HIVE
//
//  Created by Mason Dimarco on 6/15/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//

#import "HIVERegisterViewController.h"
#import "UIImage+animatedGIF.h"
#import <RestKit/RestKit.h>
#import "Token.h"
#import "Upload.h"

#define kCLIENTID "hive"
#define kCLIENTSECRET "foo"

@interface HIVERegisterViewController ()

@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) NSString *authToken;

@end

@implementation HIVERegisterViewController

@synthesize usernameField, ageField, emailField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitForm:(id)sender {
    [self loadWithUsername:usernameField.text andEmail:emailField.text andAge:ageField.text];
    [self.usernameField resignFirstResponder];
    [self.ageField resignFirstResponder];
}

//- (void)configureRestKit {
//    // initialize AFNetworking HTTPClient
//    NSURL *baseURL = [NSURL URLWithString:@"http://localhost:3000/"];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
//    
//    // initialize RestKit
//    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
//    
//    
//    RKObjectMapping *stepsMapping = [RKObjectMapping mappingForClass:[Upload class]];
//    [stepsMapping addAttributeMappingsFromArray:@[@"status"]];
//    
//    RKResponseDescriptor *stepsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stepsMapping method:RKRequestMethodPOST pathPattern:@"api/register" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
//    
//    [objectManager addResponseDescriptor:stepsDescriptor];
//    [RKObjectManager setSharedManager:objectManager];
//}

- (void)loadWithUsername:(NSString *)username andEmail:(NSString *)email andAge:(NSString *)age{
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:age, @"age", username, @"username", email, @"email", nil];
    
    [[RKObjectManager sharedManager] postObject:nil path:@"api/register" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                Token *token = [mappingResult.array objectAtIndex:0];
        NSLog(token.status);
//        _authToken = token.access_token;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:usernameField.text forKey:@"username"];
//        [defaults setObject:passwordField.text forKey:@"password"];
//        [defaults setObject:token.access_token forKey:@"auth_token"];
//        
//        [defaults synchronize];
//        NSLog(@"Saved to user session to defaults");
//        [self performSegueWithIdentifier:@"mainSegue" sender:self];
        
        NSLog(@"We are logged in");
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error was ': %@", error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

