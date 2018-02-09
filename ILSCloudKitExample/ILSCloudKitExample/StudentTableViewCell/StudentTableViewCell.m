//
//  StudentTableViewCell.m
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import "StudentTableViewCell.h"

static NSString * const kStudentCellReuseId = @"StudentTableViewCellReuseId";


@interface StudentTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *passwordLabel;
@property (nonatomic, weak) IBOutlet UIImageView *pictureImageView;


@end


@implementation StudentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code+
    self.pictureImageView.layer.cornerRadius = _pictureImageView.frame.size.height/2;
    self.pictureImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return kStudentCellReuseId;
}

#pragma mark - Public

- (void)setStudent:(Student *)student {
    
    self.nameLabel.text = student.name;
    self.emailLabel.text = student.email;
    self.passwordLabel.text = student.password;
    
    self.pictureImageView.alpha = 0.f;
    UIImage *image = student.picture ? student.picture : [UIImage imageNamed:@"placeholder"];
    self.pictureImageView.image = image;
    
    [UIView animateWithDuration:.3 animations:^{
        self.pictureImageView.alpha = 1.f;
    }];
    
}


@end
