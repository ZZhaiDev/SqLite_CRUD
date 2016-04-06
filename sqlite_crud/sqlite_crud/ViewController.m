//
//  ViewController.m
//  sqlite_crud
//
//  Created by Zijia Zhai on 4/5/16.
//  Copyright © 2016 Zijia Zhai. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()
- (IBAction)createData;
- (IBAction)deleteData;
- (IBAction)updateData;
- (IBAction)searchData;

@property (nonatomic, assign) sqlite3 *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // path is in the document
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    

    
    int sucess = sqlite3_open(path.UTF8String, &_db);
    
    if (sucess == SQLITE_OK) {
        NSLog(@" dataBase created sucessful");
        

        NSString *sql = @"CREATE TABLE IF  NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT ,name TEXT NOT NULL , score REAL DEFAULT 60.0);";
        //UTF8String 把oc转为c
        int successT = sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, NULL  );
        
        if (successT == SQLITE_OK) {
            NSLog(@" table created sucessful");
            }else{
            NSLog(@"table created failed");
        }

        
    }else{
                NSLog(@"dataBase created failed");
    }
    
    

}

//random create 100 students with scores from 20 to 100
- (IBAction)createData {
    for (int i = 0; i < 100; i++) {
        NSString *name = [NSString stringWithFormat:@"jack---%d",i];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_student (name,score) VALUES ('%@',%f)",name,arc4random_uniform(8000)/100.0 + 20];
        
        int sucess = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL );
        if (sucess == SQLITE_OK) {
                    NSLog(@" DATA created sucessful");
        }else{
                    NSLog(@" DATA created FAILED");
        }
    }
    
    
    
}

// delete score from 90--100
- (IBAction)deleteData {
    
    NSString *sql = @"DELETE FROM t_student WHERE score > 90.0;";
    
    int success =  sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL);
    
    if (success == SQLITE_OK) {
        NSLog(@" DATA delete sucessful");
    }else{
        NSLog(@" DATA delete FAILED");
    }

}

- (IBAction)updateData {
    
    NSString *sql = @"UPDATE t_student SET score = 59.9 WHERE score < 60;";
    int success =  sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL);
    
    if (success == SQLITE_OK) {
        NSLog(@" DATA update sucessful");
    }else{
        NSLog(@" DATA update FAILED");
    }


}

- (IBAction)searchData {
    
    //新需求  模糊查询 名称包含 6的人
    NSString *sql = @"SELECT  id,name,score FROM t_student WHERE name LIKE '%8%'";
    
    
    //期望 结果保存在stmt里面
    sqlite3_stmt *stmt = nil; //10条记录

    //准备查询  其实 把查询结果保存在stmt指针区域中
    int success =  sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    
    if (success == SQLITE_OK) {
        //一步步获取每一条 step
        //拿一条数据 SQLITE_ROW  证明成功拿到数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // id 0  name 1  score  2
            const  char *name =  (const  char *)sqlite3_column_text(stmt, 1);
            double score =   sqlite3_column_double(stmt, 2);
            NSLog(@"name:%@  score:%f",[NSString stringWithUTF8String:name],score);
            
        }
        
    }else{
        NSLog(@"failed!");
    }
    
    

}
@end
