//
//  XYZMainViewController.m
//  HIVE
//
//  Created by Mason Dimarco on 6/9/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//

#import "XYZMainViewController.h"

@interface XYZMainViewController ()

@end

@implementation XYZMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//ToDo: begin bluetooth connection here
- (IBAction)DoActualDeviceConnection:(id)sender {
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

-(IBAction)logoutUser:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
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
