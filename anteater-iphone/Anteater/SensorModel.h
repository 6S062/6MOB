//
//  BLEMananger.h
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLE.h"
#import "BLESensorReading.h"

@protocol SensorModelDelegate <NSObject>

-(void) bleDidConnect;
-(void) bleDidDisconnect;
-(void) bleGotSensorReading:(BLESensorReading*)reading;

@end

@interface SensorModel : NSObject <BLEDelegate>

+(SensorModel *)instance;

@property(atomic,strong) id<SensorModelDelegate> delegate;
@property(atomic,readonly) NSArray *sensorReadings;
-(void)startScanning;
-(void)stopScanning;
-(BOOL)isConnected;
-(NSString *)currentSensorId;

@end

