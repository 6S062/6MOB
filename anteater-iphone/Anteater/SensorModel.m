//
//  BLEMananger.m
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "SensorModel.h"
#import "AnteaterREST.h"

#define kBLE_SCAN_TIMEOUT 5

static id _instance;
@implementation SensorModel {
    BLE *_ble;
    BOOL _scanActive;
    NSMutableString *_in;
    int _state;
    int _skip;
}

#define HUMID_STATE 0
#define TEMP_STATE 1
#define START_STATE 2
#define ERROR_STATE 3


-(id) init {
    self = [super init];
    if (self) {
        _ble = [[BLE alloc] init];
        [_ble controlSetup];
        _ble.delegate = self;
        _sensorReadings = [[NSMutableArray alloc] init];
        _in = [[NSMutableString alloc] init];
        _state = START_STATE;
    }
    return self;
}


-(void) processInput {
    NSMutableString *s = [[NSMutableString alloc] init];

    for (int i = _skip; i < [_in length]; i++) {
        unichar c = [_in characterAtIndex:i];
        switch (_state) {
            case ERROR_STATE:
                _in = [NSMutableString stringWithString:[_in stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""]];
                i = -1;
                _state = START_STATE;
                _skip = 0;
                break;
            case START_STATE:
                if (c == 'H') {
                    _state = HUMID_STATE;
                    _skip++;
                } else if (c == 'T') {
                    _state = TEMP_STATE;
                    _skip++;
                } else if (c == 'E') {
                    _state = ERROR_STATE;
                }
                break;
            default:
                if (c == 'D') {
                    float val = [s floatValue];
                    BLESensorReading *r;
                    if (_state == HUMID_STATE) {
                        r = [[BLESensorReading alloc] initWithReadingValue:val andType:kHumidityReading atTime:[NSDate date] andSensorId:[self currentSensorId]];
                        NSLog(@"Got reading of value %f, type HUMIDITY",val );

                    } else {
                        r = [[BLESensorReading alloc] initWithReadingValue:val andType:kTemperatureReading atTime:[NSDate date] andSensorId:[self currentSensorId]];
                        NSLog(@"Got reading of value %f, type TEMPERATURE",val );

                    }
                    [((NSMutableArray *)_sensorReadings) addObject:r];
                    [self.delegate bleGotSensorReading:r];
                    [AnteaterREST postListOfSensorReadings:@[r] andCallCallback:NULL];
                    _state = START_STATE;
                    _skip++;
                    _skip += [s length];
                    _in = [NSMutableString stringWithString:[_in stringByReplacingCharactersInRange:NSMakeRange(0, _skip) withString:@""]];
                    i = -1;
                    s = [[NSMutableString alloc] init];
                    _skip = 0;
                } else if (c == 'E') {
                        _state = ERROR_STATE;
                } else {
                    [s appendFormat:@"%c",c];
                }
        }
        
    }

}


-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    [_in appendString:s];
    [self processInput];
    //NSLog(@"%@", s);

}


-(void) connectionTimer:(NSTimer *)timer
{
    if(_ble.peripherals.count > 0)
    {
        [_ble connectPeripheral:[_ble.peripherals objectAtIndex:0]];
    } else {
        if (_scanActive) {
            [self doScan];
        }
    }
}

-(void) doScan {
    [_ble findBLEPeripherals:kBLE_SCAN_TIMEOUT];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)kBLE_SCAN_TIMEOUT target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}


-(void)startScanning {
    _scanActive = TRUE;
    if (_ble.activePeripheral)
        if(_ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[_ble CM] cancelPeripheralConnection:[_ble activePeripheral]];
            return;
        }
    
    if (_ble.peripherals)
        _ble.peripherals = nil;
    [self doScan];
    
    
}

-(void)stopScanning {
    _scanActive = FALSE;
}

-(BOOL)isConnected {
    return (_ble.activePeripheral && _ble.activePeripheral.state == CBPeripheralStateConnected);
}

-(NSString *)currentSensorId {
    if ([self isConnected])
        return _ble.activePeripheral.name;
    else return NULL;
}


NSTimer *rssiTimer;

-(void) readRSSITimer:(NSTimer *)timer
{
    [_ble readRSSI];
}

- (void) bleDidDisconnect
{
    NSLog(@"bleDidDisconnect");
    [self.delegate bleDidDisconnect];
    [self startScanning]; //restart scan
    
}

-(void) bleDidConnect
{
    NSLog(@"bleDidConnect");
    [self.delegate bleDidConnect];
}




+(SensorModel *) instance {
    if (!_instance) {
        _instance = [[SensorModel alloc] init];
    }
    return _instance;
}


@end
