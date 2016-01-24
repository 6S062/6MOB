//
//  LeaderboardViewController.m
//  Anteater
//
//  Created by Sam Madden on 1/23/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "AnteaterREST.h"
#import "LeaderboardCell.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController {
    NSArray *_leaderboardData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _leaderboardData = [[NSArray alloc] init];
    [self doRefresh];
}


-(void) doRefresh {
    [AnteaterREST getLeaderboard:^(NSDictionary *d) {
        if (d) {
            _leaderboardData = [d objectForKey:@"users"];
            [self.tableView reloadData];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_leaderboardData count]+ 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
        LeaderboardCell *c = (LeaderboardCell *)cell;
        NSDictionary *d = [_leaderboardData objectAtIndex:indexPath.row-1];
        c.pointsField.text = [[d objectForKey:@"points"] stringValue];
        NSString *uuid = [d objectForKey:@"device_id"];
        if ([uuid isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]) {
            c.nameField.text = @"YOU";
        } else {
            c.nameField.text = [d objectForKey:@"user_id"];
        }
        c.rankField.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
