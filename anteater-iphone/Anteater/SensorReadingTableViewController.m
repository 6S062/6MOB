//
//  SensorReadingTableViewController.m
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "SensorReadingTableViewController.h"
#import "SensorDataPlotViewController.h"

@interface SensorReadingTableViewController ()
@end

@implementation SensorReadingTableViewController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SensorModel instance].delegate = self;

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark ========== UITableViewDataSource methods ==========

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SensorModel *model = [SensorModel instance];
    if (![model isConnected])
        return 1;
    else
        return [[model sensorReadings] count] + 1;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    if (indexPath.row == 0 && [[SensorModel instance] isConnected]) {
        SensorDataPlotViewController *p = [[SensorDataPlotViewController alloc] initWithReadings:[[SensorModel instance] sensorReadings]];
        [self.navigationController pushViewController:p animated:YES];
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[SensorModel instance] isConnected]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noConnCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noConnCell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"No anthills currently connected"];
        return cell;
    }
    else {	
        NSArray *rs = [[SensorModel instance] sensorReadings];

        if (indexPath.row == 0) {
            //top cell contains some buttons to show a plot
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plotCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"plotCell"];
                cell.imageView.image = [UIImage imageNamed:@"anteater-logo.png"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%lu readings",(unsigned long)[rs count]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Tap top plot values"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;

        } else {
        
            BLESensorReading *r = [rs objectAtIndex:([rs count] -1) - (indexPath.row-1)];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sensorCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sensorCell"];
                cell.imageView.image = [UIImage imageNamed:@"anteater-logo.png"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[r formattedValue]];
            NSString *dateString = [NSDateFormatter localizedStringFromDate:r.time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dateString];
            return cell;
        }
    }
    
}

#pragma mark ======== SensorModelDelegate methods ==========


-(void) bleDidConnect {
    [self.tableView reloadData];
}

-(void) bleDidDisconnect {
    [self.tableView reloadData];
}

-(void) bleGotSensorReading:(BLESensorReading*)reading {
    [self.tableView reloadData];
}


@end
