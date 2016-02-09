//
//  BLEMananger.m
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "SensorModel.h"
#import "AnteaterREST.h"
#import "SettingsModel.h"


static id _instance;
@implementation SensorModel {
}



-(id) init {
    self = [super init];
    if (self) {
    }
    return self;
}



-(void)startScanning {
    
}

-(void)stopScanning {
}

-(BOOL)isConnected {
    return FALSE;
}

-(NSString *)currentSensorId {
    return @"NONE";
}



+(SensorModel *) instance {
    if (!_instance) {
        _instance = [[SensorModel alloc] init];
    }
    return _instance;
}


@end
