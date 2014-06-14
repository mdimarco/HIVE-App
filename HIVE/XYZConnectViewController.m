//
//  XYZConnectViewController.m
//  HIVE
//
//  Created by Mason Dimarco on 6/11/14.
//  Copyright (c) 2014 Mason Dimarco. All rights reserved.
//

#import "XYZConnectViewController.h"
#import <WFConnector/WFConnector.h>

@interface XYZConnectViewController () <WFHardwareConnectorDelegate,WFSensorConnectionDelegate>

@property (nonatomic,retain) WFSensorConnection* sensorConnection;

@end

@implementation XYZConnectViewController

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
    
    //Set up le hardware connector
    WFHardwareConnector* hardwareConnector = [WFHardwareConnector sharedConnector];
    hardwareConnector.delegate = self;
    [hardwareConnector setSampleTimerDataCheck:FALSE];
    [hardwareConnector setSampleRate:1.0];
    
    //Enable le bluetooth
    [hardwareConnector enableBTLE:YES];
    
    NSLog(@"API VERSION:  %@", hardwareConnector.apiVersion);
    NSLog(@"Has BTLE: %@", hardwareConnector.hasBTLESupport ? @"YES" : @"NO");
    [self updateConnectButton];
    [self updateData];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - UI

-(void) updateConnectButton

{
    //get current connection status
    WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
    if( self.sensorConnection != nil )
    {
        connState = self.sensorConnection.connectionStatus;
    }
    
    switch(connState)
    {
        case WF_SENSOR_CONNECTION_STATUS_IDLE:
            [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
            [self.connectButton setTitle:@"Connecting...." forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
            [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
            [self.connectButton setTitle:@"Disconnecting..." forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
            [self.connectButton setTitle:@"Interrupted!" forState:UIControlStateNormal];
            break;
    }
    
    
}


- (void) updateData
{
    bool isValid = NO;
    
    if([self.sensorConnection isKindOfClass:[WFBikeSpeedCadenceConnection class]])
    {
        WFBikeSpeedCadenceConnection* bsConnection = (WFBikeSpeedCadenceConnection*)self.sensorConnection;

        WFBikeSpeedCadenceData* bsData = [bsConnection getBikeSpeedCadenceData];
        
        if(bsConnection.connectionStatus == WF_SENSOR_CONNECTION_STATUS_CONNECTED){
            isValid = YES;
            self.serialLabel.text = @"Connected!";
            self.bsLabel.text =  [NSString stringWithFormat:@"%3.3f", bsData.accumCadenceTime];;
        }
        
    }
    if(!isValid)
    {
        self.serialLabel.text = @"--";
        self.bsLabel.text = @"--";
    }
    
    
}

- (void)connectButtonTouched:(id)sender{
    
    [self toggleConnection];
}

#pragma mark
#pragma mark - Connection Management

//TODO whatisapragmamark
//TODO what is wildcard?


- (void) toggleConnection
{
    //Sensor Type
    WFSensorType_t sensorType = WF_SENSORTYPE_BIKE_SPEED_CADENCE;
    
    WFNetworkType_t networkType = WF_NETWORKTYPE_UNSPECIFIED;
    
    //Made simpler than demo
    networkType = WF_NETWORKTYPE_ANY;
    
    bool isWildcard = self.wildcardSwitch.on;
    
    //Current connection status
    WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
    WFHardwareConnector* hardwareConnector = [WFHardwareConnector sharedConnector];
    
    if ( self.sensorConnection != nil){
        connState = self.sensorConnection.connectionStatus;
    }
    
    //-----------------------------------
    switch ( connState )
    {
        case WF_SENSOR_CONNECTION_STATUS_IDLE:
        {    //create connection parameters
            WFConnectionParams* params = nil;
            
            if( isWildcard )
            {
                //if wildcard? search is specified, create empty connection params
                params = [[WFConnectionParams alloc] init];
                params.sensorType = sensorType;
                params.networkType = networkType;
            }
            
            else{
                params = [hardwareConnector.settings connectionParamsForSensorType:sensorType];
            }
            
            if( params != nil)
            {
                NSError* error = nil;
                //if the connection request is a wildcard, you could use proximity switch
                
                
                if(isWildcard)
                {
                    WFProximityRange_t range = WF_PROXIMITY_RANGE_DISABLED;
                    self.sensorConnection = [hardwareConnector requestSensorConnection:params withProximity:range error:&error];
                    
                    UIAlertView* alert = [[UIAlertView alloc]
                                          initWithTitle:@"" message:[NSString stringWithFormat:@"Sensor connected.\n\n\n\nLet's get it.",self.sensorConnection,error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    //otherwise use normal connection request/
                    self.sensorConnection = [hardwareConnector requestSensorConnection:params];
                }
                
                if(error!=nil){
                    NSLog(@"ERROR %@", error);
                }
                self.sensorConnection.delegate = self;
                
            }
            break;
        }
        case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
        case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
            // disconnect the sensor.
            NSLog(@"Disconnecting sensor connection");
            [self.sensorConnection disconnect];
            break;
            
        case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
            //do nothing
            break;
    
    }
    
    [self updateConnectButton];
}


#pragma mark WFHardwareConnectorDelegate Implementation

//-----------------------------------------------------
- (void) hardwareConnector:(WFHardwareConnector *)hwConnector stateChanged:(WFHardwareConnectorState_t)currentState
{
    
}



//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector connectedSensor:(WFSensorConnection*)connectionInfo
{
    NSString* logMsg = [NSString stringWithFormat:@"Sensor Connected: %@ on Network: %@",
                        [self nameFromSensorType:connectionInfo.sensorType],
                        [self nameFromNetworkType:connectionInfo.networkType]];
    
    NSLog(@"%@", logMsg);
    
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector disconnectedSensor:(WFSensorConnection*)connectionInfo
{
    NSString* logMsg = [NSString stringWithFormat:@"Sensor Disconnected: %@ on Network: %@",
                        [self nameFromSensorType:connectionInfo.sensorType],
                        [self nameFromNetworkType:connectionInfo.networkType]];
    
    NSLog(@"%@", logMsg);
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector searchTimeout:(WFSensorConnection*)connectionInfo
{
    NSString* logMsg = [NSString stringWithFormat:@"Search Timeout: %@",
                        [self nameFromSensorType:connectionInfo.sensorType]];
    
    NSLog(@"%@", logMsg);
}

//--------------------------------------------------------------------------------
- (void)hardwareConnectorHasData
{
    [self updateData];
}

#pragma mark -
#pragma mark WFSensorConnectionDelegate Implementation

//--------------------------------------------------------------------------------
- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState
{
    // check for a valid connection.
    if (connectionInfo.isValid)
    {
        // update the stored connection settings.
        [[WFHardwareConnector sharedConnector].settings saveConnectionInfo:connectionInfo];
        
        // update the display.
        [self updateData];
    }
    
    // check for disconnected sensor.
    else if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // reset the display.
    }
	
	[self updateConnectButton];
}


#pragma mark - Helpful Methods

- (NSString*) nameFromSensorType:(WFSensorType_t)sensorType
{
	NSString* retVal;
	
	switch (sensorType)
	{
		case WF_SENSORTYPE_HEARTRATE:
			retVal = @"Heartrate";
			break;
		case WF_SENSORTYPE_BIKE_POWER:
			retVal = @"Power";
			break;
		case WF_SENSORTYPE_BIKE_SPEED_CADENCE:
			retVal = @"Speed & Cadence";
			break;
		default:
			retVal = @"Unknown";
			break;
	}
	
	return	retVal;
}

- (NSString*) nameFromNetworkType:(WFNetworkType_t)networkType
{
	NSString* retVal;
	
	switch (networkType)
	{
		case WF_NETWORKTYPE_BTLE:
			retVal = @"BTLE";
			break;
		case WF_NETWORKTYPE_ANTPLUS:
			retVal = @"ANT+";
			break;
		case WF_NETWORKTYPE_SUUNTO:
			retVal = @"Suunto";
			break;
		default:
			retVal = @"Unknown";
			break;
	}
	
	return	retVal;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
