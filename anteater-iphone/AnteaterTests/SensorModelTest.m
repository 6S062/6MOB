//
//  SensorModelTest.m
//  Anteater
//
//  Created by Sam Madden on 1/23/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SensorModel.h"

@interface SensorModelTest : XCTestCase

@end

@implementation SensorModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBleData {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    SensorModel *m = [[SensorModel alloc] init];
    unsigned char *str = (unsigned char *)"H22.0D";
    [m bleDidReceiveData:str length:(int)strlen((char *)str)];
    NSArray *rs = [m sensorReadings];
    XCTAssert([rs count] == 1);
    BLESensorReading *r = [rs objectAtIndex:0];
    XCTAssert([r type] == kHumidityReading);
    
    str = (unsigned char *)"ECT22.0D";
    m = [[SensorModel alloc] init];
    [m bleDidReceiveData:str length:(int)strlen((char *)str)];
    rs = [m sensorReadings];
    XCTAssert([rs count] == 1);
    r = [rs objectAtIndex:0];
    XCTAssert([r type] == kTemperatureReading);
 
    str = (unsigned char *)"ECT22.0";
    m = [[SensorModel alloc] init];
    [m bleDidReceiveData:str length:(int)strlen((char *)str)];
    str = (unsigned char*)"DECH25.00DT25DEC";
    [m bleDidReceiveData:str length:(int)strlen((char *)str)];

    rs = [m sensorReadings];
    XCTAssert([rs count] == 3);
    r = [rs objectAtIndex:0];
    XCTAssert([r type] == kTemperatureReading);
    r = [rs objectAtIndex:1];
    XCTAssert([r type] == kHumidityReading);
    r = [rs objectAtIndex:2];
    XCTAssert([r type] == kTemperatureReading);

}


@end
