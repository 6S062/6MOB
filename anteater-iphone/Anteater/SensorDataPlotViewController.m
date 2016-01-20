//
//  SensorDataPlotViewController.m
//  Anteater
//
//  Created by Sam Madden on 1/19/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "SensorDataPlotViewController.h"
#import "BLESensorReading.h"

#define kTempPlotName @"Temperature"
#define kHumPlotName @"Humidity"

@implementation SensorDataPlotViewController {
    NSArray *_readings;
    NSMutableArray *_tempData;
    NSMutableArray *_humData;
    CPTXYGraph *_g;
    int _minTime, _maxTime;
}

-(id)initWithReadings:(NSArray *)readings {
    self = [super init];
    if (self) {
        _readings = readings;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CPTXYGraph *g = [[CPTXYGraph alloc] initWithFrame:self.view.frame];
    [g applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    g.paddingBottom = g.paddingLeft = g.paddingRight = g.paddingTop = 10.0;
    g.paddingBottom = 40;
    CPTGraphHostingView *gview = [[CPTGraphHostingView alloc] initWithFrame:self.view.frame];
    gview.hostedGraph =g;
    [self.view addSubview:gview];

    CPTScatterPlot *p1 = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    CPTMutableLineStyle *style = [[CPTMutableLineStyle alloc] init];
    style.miterLimit = 1.0;
    style.lineWidth = 3.0;
    style.lineColor  = [CPTColor blueColor];
    p1.dataLineStyle = style;
    p1.identifier = kHumPlotName;
    p1.dataSource = self;
    [g addPlot:p1];
    
    CPTScatterPlot *p2 = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    CPTMutableLineStyle *style2 = [[CPTMutableLineStyle alloc] init];
    style2.miterLimit = 1.0;
    style2.lineWidth = 3.0;
    style2.lineColor  = [CPTColor redColor];
    p2.dataLineStyle = style2;
    p2.identifier = kTempPlotName;
    p2.dataSource = self;
    [g addPlot:p2];

    [g.plotAreaFrame setPaddingLeft:30.0f];
    [g.plotAreaFrame setPaddingBottom:30.0f];

    _g = g;
    [self reloadData];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];

}

-(void) configAxes {
    
    
    CPTXYPlotSpace *ps = (CPTXYPlotSpace *)[_g defaultPlotSpace];
    ps.allowsUserInteraction = true;
    float wid = _maxTime - _minTime;
    
    ps.xRange = [[CPTPlotRange alloc] initWithLocation:@(_minTime - wid*.1) length:@(wid + wid*.2)];
    ps.yRange = [[CPTPlotRange alloc] initWithLocation:@0 length:@100];
    
    CPTXYAxisSet *a = (CPTXYAxisSet *)_g.axisSet;
    a.xAxis.majorIntervalLength = @((_maxTime - _minTime)/10.0);
    a.yAxis.majorIntervalLength = @10;

}


-(void)reloadData {
    BLESensorReading *r;
    _humData = [[NSMutableArray alloc] init];
    _tempData = [[NSMutableArray alloc] init];
    int first = -1;
    _minTime = 1000000000;
    _maxTime = -1000000000;
    for (r in _readings) {
        if (first == -1) {
            first =[r.time timeIntervalSince1970];
        }
        int x = [r.time timeIntervalSince1970] - first;
        if ([r type] == kHumidityReading) {
            [_humData addObject:@[@(r.value),@(x)]];
        } else if ([r type] == kTemperatureReading) {
            [_tempData addObject:@[@(r.value),@(x)]];
        }
        if (x < _minTime)
            _minTime = x;
        else if (x > _maxTime)
            _maxTime = x;
    }
    [self configAxes];
    [_g reloadData];
}


-(NSUInteger)numberOfRecordsForPlot:(nonnull CPTPlot *)plot {
    if ([plot.identifier  isEqual: kHumPlotName]) {
        return [_humData count];
    } else if ([plot.identifier  isEqual: kTempPlotName]) {
        return [_tempData count];
    }
    else return 0;
}

-(nullable id)numberForPlot:(nonnull CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSArray *plotData = [plot.identifier  isEqual: kHumPlotName]?_humData:_tempData;
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [[plotData objectAtIndex:idx] objectAtIndex:1];
            break;
        default: //Y
            return [[plotData objectAtIndex:idx] objectAtIndex:0];
            break;
    }
}


@end
