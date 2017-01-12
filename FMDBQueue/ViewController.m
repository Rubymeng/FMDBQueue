//
//  ViewController.m
//  FMDBQueue
//
//  Created by tyhmeng on 17/1/12.
//  Copyright © 2017年 tyhmeng. All rights reserved.
//
#import "ViewController.h"

#import "FMDB.h"

@interface ViewController ()


@property (nonatomic,strong) FMDatabaseQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//1.获取数据库路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"per.sqlite"];
    
    NSLog(@"==%@",fileName);
//    2.获取数据队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    
//    打开数据库
    [queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_per (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);"];
        
        if (result) {
            NSLog(@"打开数据库成功");
        }else {
        
            NSLog(@"打开数据库失败");
        }
    }];
    
    self.queue = queue;
    
}
- (IBAction)insert:(id)sender {
[self.queue inDatabase:^(FMDatabase *db) {
    [db beginTransaction];
    [db executeUpdate:@"INSERT INTO t_per (name,age) VALUES (?,?);",@"嘉怡",@16];
    [db executeUpdate:@"INSERT INTO t_per (name,age) VALUES (?,?);",@"小丽",@23];
    [db executeUpdate:@"INSERT INTO t_per (name,age) VALUES (?,?);",@"小月",@22];
    [db executeUpdate:@"INSERT INTO t_per (name,age) VALUES (?,?);",@"小萌",@19];
    [db executeUpdate:@"INSERT INTO t_per (name,age) VALUES (?,?);",@"笑笑",@18];
    [db commit];
    
//    查询数据库
//    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT *FROM t_per"];
        while ([result next]) {
            int ID = [result intForColumn:@"id"];
            NSString *name = [result stringForColumn:@"name"];
            int age = [result intForColumn:@"age"];
            NSLog(@"%@,%d,%d",name,ID,age);
            
        }
//    }];
    
    

}];
    
    
    
    
    
    
}
//查询
- (IBAction)select:(id)sender {


    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT *FROM t_per"];
        while ([result next]) {
            int ID = [result intForColumn:@"id"];
            NSString *name = [result stringForColumn:@"name"];
            int age = [result intForColumn:@"age"];
            NSLog(@"%@,%d,%d",name,ID,age);
            
        }
    }];
 

}

- (IBAction)drop:(id)sender {

[self.queue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"DROP TABLE IF EXISTS t_per;"];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_per (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);"];
}];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
