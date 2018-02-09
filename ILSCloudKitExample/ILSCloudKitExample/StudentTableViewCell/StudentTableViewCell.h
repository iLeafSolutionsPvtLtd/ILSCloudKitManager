//
//  StudentTableViewCell.h
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface StudentTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)setStudent:(Student *)student;

@end
