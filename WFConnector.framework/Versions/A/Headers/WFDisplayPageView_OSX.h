//
//  WFDisplayPageView.h
//  WFConnector
//
//  Created by Murray Hughes on 30/07/13.
//  Copyright (c) 2013 Wahoo Fitness. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WFConnector/hardware_connector_types.h>

@class WFDisplayPage;

@interface WFDisplayPageView : NSView

@property (nonatomic, retain) WFDisplayPage* page;
@property (nonatomic, assign) WFSensorSubType_t sensorSubType;
@property (nonatomic, retain) NSColor* backgroundColor;

@property (nonatomic, assign) BOOL invert;

@end
