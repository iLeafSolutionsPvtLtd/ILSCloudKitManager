//
//  Student.h
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const struct CloudKitStudentFields {
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *email;
    __unsafe_unretained NSString *password;
    __unsafe_unretained NSString *picture;
    
} CloudKitStudentFields;

@interface Student : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, strong) UIImage *picture;

- (instancetype)initWithInputData:(id)inputData;

@end
