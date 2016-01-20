//
//  BLESensorReading.h
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kTemperatureReading = 1,
    kHumidityReading = 2
} SensorReadingType;

@interface BLESensorReading : NSObject

@property(readonly) float value;
@property(readonly) SensorReadingType type;
@property(readonly) NSDate *time;

-(id)initWithReadingValue:(float)value andType:(SensorReadingType)type atTime:(NSDate *)time;
-(NSString *)formattedValue;

@end
