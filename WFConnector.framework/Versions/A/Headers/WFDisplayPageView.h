//
//  WFDisplayPageView.h
//  WFConnector
//
//  Created by Murray Hughes on 30/07/13.
//  Copyright (c) 2013 Wahoo Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/hardware_connector_types.h>

@class WFDisplayPage;

@interface WFDisplayPageView : UIView

@property (nonatomic, retain) WFDisplayPage* page;
@property (nonatomic, assign) WFSensorSubType_t sensorSubType;

@property (nonatomic, assign) BOOL invert;


+ (UIImage*) imageWithPage:(WFDisplayPage*) page forSensorSubType:(WFSensorSubType_t) sensorSubType inverted:(BOOL) inverted;

@end
