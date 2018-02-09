//
//  CloudKitManager.h
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CloudKitCompletionHandler)(NSArray *results, NSError *error);

@interface CloudKitManager : NSObject

+ (void)fetchAllCitiesWithCompletionHandler:(CloudKitCompletionHandler)handler;

+ (void)createRecord:(NSDictionary *)recordDic
   completionHandler:(CloudKitCompletionHandler)handler;

+ (void)updateRecordTextWithId:(NSString *)recordId
                          text:(NSString *)text
             completionHandler:(CloudKitCompletionHandler)handler;

+ (void)removeRecordWithId:(NSString *)recordId
         completionHandler:(CloudKitCompletionHandler)handler;

@end
