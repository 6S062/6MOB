//
//  SensorDataPlotViewController.h
//  Anteater
//
//  Created by Sam Madden on 1/19/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SensorDataPlotViewController : UIViewController <CPTScatterPlotDataSource>
-(id)initWithReadings:(NSArray *)readings;
-(void)reloadData;

@end
