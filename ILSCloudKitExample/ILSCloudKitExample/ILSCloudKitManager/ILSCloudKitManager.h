//
//  ILSCloudKitManager.h
//  ILSCloudKitExample
//
//  Created by Hiran on 2/7/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

//Completion Handler
typedef void(^CloudKitCompletionHandler)(NSArray *results, NSError *error);

@interface ILSCloudKitManager : NSObject

/**
 * Fetch all records of particular record type from iCloud
 * @author Hiran Stephan
 *
 * @param recordType record type that should be fetched from iCloud
 * @param predicate condition on which records should be fetched
 * @param handler Completion handler
 */

+ (void)fetchAllRecordsWithType:(NSString*)recordType
                  withPredicate:(NSPredicate*)predicate
              CompletionHandler:(CloudKitCompletionHandler)handler;

/**
 * Create a record for a specified record type
 * @author Hiran Stephan
 *
 * @param recordType Type of the record that should be created in iCloud
 * @param fields fields and vlues for that record as a dictionary
 * @param recordId Id of the record
 * @param handler Completion handler
 */

+ (void)createRecord:(NSDictionary *)fields
      WithRecordType:(NSString*)recordType
        WithRecordId:(NSString*)recordId
   completionHandler:(CloudKitCompletionHandler)handler;


/**
 * Update record with a given record id
 * @author Hiran Stephan
 *
 * @param recordId id of the record that should be updated
 * @param recordDic fields and vlues for that record as a dictionary
 * @param handler Completion handler
 */

+ (void)updateRecord:(NSString *)recordId
          withRecord:(NSDictionary *)recordDic
   completionHandler:(CloudKitCompletionHandler)handler;

/**
 * remove record with a given record id
 * @author Hiran Stephan
 *
 * @param recordId id of the record that should be deleted
 * @param handler Completion handler
 */
+ (void)removeRecordWithId:(NSString *)recordId
         completionHandler:(CloudKitCompletionHandler)handler;

@end
