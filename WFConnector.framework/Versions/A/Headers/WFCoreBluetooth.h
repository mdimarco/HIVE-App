//
//  WFCoreBluetooth.h
//  WFConnector
//
//  Created by Murray Hughes on 18/12/2013.
//  Copyright (c) 2013 Wahoo Fitness. All rights reserved.
//

#ifdef MAC_OSX_BUILD
#import <IOBluetooth/IOBluetooth.h>
#else
#import <CoreBluetooth/CoreBluetooth.h>
#endif