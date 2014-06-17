//
//  XYZConnectViewController.h
//  HIVE
//
//  Created by Mason Dimarco on 6/11/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>

@interface XYZConnectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (weak, nonatomic) IBOutlet UILabel *serialLabel;

@property (weak, nonatomic) IBOutlet UILabel *bsLabel;

@property (weak, nonatomic) IBOutlet UISwitch *wildcardSwitch;

@property WFBikeSpeedCadenceData* bsData;

- (IBAction)connectButtonTouched:(id)sender;


- (WFBikeSpeedCadenceData *) getData;

@end
