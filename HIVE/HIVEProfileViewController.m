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
#import "HIVEProfileViewController.h"
#import "HIVEProfileViewController.m"
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
    
    [self configureRestKit];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)uploadSteps:(id)sender {
    
    if( self.realData != nil){
        [self addSteps:[NSString stringWithFormat:@"%lu",self.realData.accumCrankRevolutions] mins:_minsField.text
                 miles:_milesField.text];
        
        NSLog(@"Uploaded %3.3f cadence!",self.realData.accumCadenceTime);
        
    }
    else{
    [self addSteps:_stepsField.text mins:_minsField.text miles:_milesField.text];
    }
}



- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://hive.gt/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *stepsMapping = [RKObjectMapping mappingForClass:[Upload class]];
    [stepsMapping addAttributeMappingsFromArray:@[@"username", @"steps", @"mins", @"miles"]];
    
    RKResponseDescriptor *stepsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:stepsMapping method:RKRequestMethodPOST pathPattern:@"upload/json" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:stepsDescriptor];
    
}


-(void)addSteps:(NSString *)steps mins:(NSString *)mins miles:(NSString *)miles {
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:steps, @"steps", mins, @"mins", miles, @"miles", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", [defaults objectForKey:@"auth_token"]]];
    [[RKObjectManager sharedManager] postObject:nil path:@"upload/json" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        Upload *steps = [mappingResult.array objectAtIndex:0];
        
        if(self.realData == nil){
        
        _resultsField.text = [NSString stringWithFormat:@"%@ steps upload to %@.\n %@ had %@ steps, %@ mins, %@ miles", _stepsField.text, steps.username, steps.username, steps.steps, steps.mins, steps.miles];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        _resultsField.text = @"Invalid upload";
        NSLog(@"Error was ': %@", error);
    }];
    
    if(self.realData){
        self.resultsField.text=[NSString stringWithFormat:@"Got actual data uploaded of accumulated %lu cadences from meter",self.realData.accumCrankRevolutions];
    }
    
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


@end
