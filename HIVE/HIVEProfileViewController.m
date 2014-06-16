//
//  HIVEProfileViewController.m
//  HIVE
//
//  Created by Mason Dimarco on 6/15/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//



#import "HIVELoginViewController.h"
#import "Token.h"
#import "Upload.h"
#import "HIVEProfileViewController.h"
#import <RestKit/RestKit.h>

#define kCLIENTID "hive"
#define kCLIENTSECRET "foo"

@interface HIVEProfileViewController ()


@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) NSString *authToken;


@end

@implementation HIVEProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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




-(IBAction)uploadSteps:(id)sender {
    [self addSteps:_stepsField.text mins:_minsField.text miles:_milesField.text];
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
        _resultsField.text = [NSString stringWithFormat:@"%@ steps upload to %@.\n %@ had %@ steps, %@ mins, %@ miles", _stepsField.text, steps.username, steps.username, steps.steps, steps.mins, steps.miles];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        _resultsField.text = @"Invalid upload";
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
