//
//  Student.m
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import "Student.h"
#import <CloudKit/CloudKit.h>

const struct CloudKitStudentFields CloudKitStudentFields = {
    .name = @"name",
    .email = @"email",
    .password = @"password",
    .picture = @"picture"
};

@implementation Student

#pragma mark - Lifecycle

- (instancetype)initWithInputData:(id)inputData {
    self = [super init];
    if (self) {
        [self mapObject:inputData];
    }
    
    return self;
}

#pragma mark - Private

- (void)mapObject:(CKRecord *)object {
    
    _name = [object valueForKeyPath:CloudKitStudentFields.name];
    _email = [object valueForKeyPath:CloudKitStudentFields.email];
    
    //Converting CKAsset to UIImage
    CKAsset *asset = (CKAsset *)[object valueForKeyPath:CloudKitStudentFields.picture];
    NSData *data = [[NSData alloc]initWithContentsOfURL:asset.fileURL];
    _picture = [UIImage imageWithData:data];
    
    _password = [object valueForKeyPath:CloudKitStudentFields.password];
    
}


@end
