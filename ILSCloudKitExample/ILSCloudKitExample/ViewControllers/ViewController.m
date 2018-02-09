//
//  ViewController.m
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>
#import "StudentTableViewCell.h"
#import "DetailViewController.h"
#import "ILSCloudKitManager.h"

static NSString * const kCKRecordName = @"STUDENT";


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

//UITableview Datasource array
@property (nonatomic, strong) NSArray *Students;

//Refresh control for updating students list
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Setting up refresh control
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshStudentList) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //Fetch students list from iCloud when view loads
    [self fetchStudents];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Refresh control action, updating students list
- (void)refreshStudentList {
    [_refreshControl endRefreshing];
    [self fetchStudents];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.Students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[StudentTableViewCell reuseIdentifier]];
    [cell setStudent:[self.Students objectAtIndex:indexPath.item]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDetail" sender:[self.Students objectAtIndex:indexPath.item]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteStudent:indexPath];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        // Get destination view
        DetailViewController *vc = [segue destinationViewController];
        if([sender isKindOfClass:[Student class]])
            vc.student = sender;
    }
}

#pragma mark - Fetch students list from iCloud

- (void)fetchStudents {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", kCKRecordName];
    [ILSCloudKitManager fetchAllRecordsWithType:kCKRecordName withPredicate:predicate CompletionHandler:^(NSArray *results, NSError *error) {
        
        if (error) {
            // Error handling for failed fetch from public database
        }
        else {
            // Display the fetched records
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSArray *students = [self mapStudents:results];
                self.Students = students;
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Delete a student record from iCloud

- (void)deleteStudent:(NSIndexPath *)indexPath{
    Student *student = [self.Students objectAtIndex:indexPath.item];
    [ILSCloudKitManager removeRecordWithId:student.email completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"error");
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSMutableArray *studentsArray = [[NSMutableArray alloc]initWithArray:self.Students];
                [studentsArray removeObjectAtIndex:indexPath.row];
                self.Students = studentsArray;
                [_tableView reloadData];
            });
        }
    }];
}

#pragma mark - Map fetch result to student model object

- (NSArray *)mapStudents:(NSArray *)students {
    
    if (students.count == 0) return nil;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [students enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Student *student = [[Student alloc] initWithInputData:obj];
        [temp addObject:student];
    }];
    
    return [NSArray arrayWithArray:temp];
}

@end
