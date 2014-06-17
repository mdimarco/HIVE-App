//
//  HIVEProfileViewController.h
//  HIVE
//
//  Created by Mason Dimarco on 6/15/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>



@interface HIVEProfileViewController : UIViewController


@property (nonatomic, strong) IBOutlet UITextView *resultsField;
@property (nonatomic, strong) IBOutlet UITextField *stepsField;
@property (nonatomic, strong) IBOutlet UITextField *minsField;
@property (nonatomic, strong) IBOutlet UITextField *milesField;

@property WFBikeSpeedCadenceData* realData;



-(IBAction)uploadSteps:(id)sender;



@end
