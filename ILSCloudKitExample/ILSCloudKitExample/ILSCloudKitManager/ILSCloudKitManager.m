//
//  ILSCloudKitManager.m
//  ILSCloudKitExample
//
//  Created by Hiran on 2/7/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import "ILSCloudKitManager.h"
#import <CloudKit/CloudKit.h>


@implementation ILSCloudKitManager


+ (CKDatabase *)publicCloudDatabase {
    return [[CKContainer defaultContainer] publicCloudDatabase];
}

// Retrieve existing records
+ (void)fetchAllRecordsWithType:(NSString*)recordType
                  withPredicate:(NSPredicate*)predicate
              CompletionHandler:(CloudKitCompletionHandler)handler {
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        if (!handler) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            handler (results, error);
        });
        
    }];
    
}


// add a new record
+ (void)createRecord:(NSDictionary *)fields
      WithRecordType:(NSString*)recordType
        WithRecordId:(NSString*)recordId
   completionHandler:(CloudKitCompletionHandler)handler {
    
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordId];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:recordType recordID:recordID];
    
    [[fields allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        record[key] = fields[key];
    }];
    
    CKDatabase *publicCloudDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicCloudDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        
        if (!handler) return;
       
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler (nil, error);
            });
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"record saved successfully");
            handler (@[record], error);
        });
        
    }];
}


// updating the record by recordId
+ (void)updateRecord:(NSString *)recordId
          withRecord:(NSDictionary *)recordDic
   completionHandler:(CloudKitCompletionHandler)handler {
    
    // Fetch the record from the database
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordId];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *record, NSError *error) {
        if (!handler) return;
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler (nil, error);
            });
            return;
        }
        else {
            // Modify the record and save it to the database
            [[recordDic allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                record[key] = recordDic[key];
                
            }];
            
            [publicDatabase saveRecord:record completionHandler:^(CKRecord *savedRecord, NSError *saveError) {
                // Error handling for failed save to public database
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler (nil, error);
                    });
                    return;
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Saved successfully");
                        handler (@[record], error);
                    });
                }
            }];
        }
    }];
    
}



// remove the record
+ (void)removeRecordWithId:(NSString *)recordId
         completionHandler:(CloudKitCompletionHandler)handler {
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordId];
    [publicDatabase deleteRecordWithID:recordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        if (!handler) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler (nil, error);
        });
        
    }];
}


@end
