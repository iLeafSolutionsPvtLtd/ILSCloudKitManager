//
//  DetailViewController.m
//  ILSCloudKitExample
//
//  Created by Hiran on 2/6/18.
//  Copyright © 2018 iLeaf Solutions pvt ltd. All rights reserved.
//

#import "DetailViewController.h"
#import <CloudKit/CloudKit.h>
#import "ILSCloudKitManager.h"

static NSString * const kCKRecordName = @"STUDENT";


@interface DetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIImageView *pictureImageView;

@property (nonatomic, strong) NSURL *pictureImageURL;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pictureImageView.layer.cornerRadius = _pictureImageView.frame.size.height/2;
    _pictureImageView.clipsToBounds = YES;
    
    [self addPaddingInFrontOfTextField:_emailField];
    [self addPaddingInFrontOfTextField:_passwordField];
    [self addPaddingInFrontOfTextField:_nameField];

    
    // If editing a record, populate data in textfields
    if(_student){
        _nameField.text = _student.name;
        _emailField.text = _student.email;
        _passwordField.text = _student.password;
        UIImage *image = _student.picture ? _student.picture : [UIImage imageNamed:@"placeholder"];
        _pictureImageURL = [self urlFromImage:_student.picture];
        _pictureImageView.image = image;
        
        //Email is not changable once entered since it is the key to find the record
        _emailField.userInteractionEnabled = NO;
        
    }
}

- (void)addPaddingInFrontOfTextField:(UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Take photo


- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (chosenImage != nil)
    {
        _pictureImageURL = [self urlFromImage:chosenImage];
    }
    
    self.pictureImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (NSURL*)urlFromImage:(UIImage*)image{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    NSURL *imageUrl = [[NSURL alloc]initFileURLWithPath:path];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
    return imageUrl;
}


#pragma mark Save or update student record in iCloud

- (IBAction)saveStudent:(id)sender {
    
    
    NSMutableDictionary *recordDic = [[NSMutableDictionary alloc]init];
    
//  Name
    NSString *name = [self.nameField.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    [recordDic setObject:name forKey:@"name"];
    
//  Email
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
    [recordDic setObject:email forKey:@"email"];
    
//  Password
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    [recordDic setObject:password forKey:@"password"];
//  Category
    [recordDic setObject:kCKRecordName forKey:@"category"];
    
//    Picture
    if(_pictureImageURL){
        CKAsset *picture = [[CKAsset alloc]initWithFileURL:_pictureImageURL];
        [recordDic setObject:picture forKey:@"picture"];
    }
    
    
    if(!_student){
        [ILSCloudKitManager createRecord:recordDic WithRecordType:kCKRecordName WithRecordId:[self.emailField.text stringByTrimmingCharactersInSet:
                                                                                              [NSCharacterSet whitespaceCharacterSet]] completionHandler:^(NSArray *results, NSError *error) {
            
            if(error) {
                NSLog(@"%@", error);
            } else {
                NSLog(@"Saved successfully");
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }];
        
    }else{
        
        [ILSCloudKitManager updateRecord:_student.email withRecord:recordDic completionHandler:^(NSArray *results, NSError *error) {
            if(error) {
                NSLog(@"%@", error);
            } else {
                NSLog(@"Saved successfully");
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if(_pictureImageURL.path.length > 0)
                        [[NSFileManager defaultManager]removeItemAtURL:_pictureImageURL error:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
        
    }
}



@end
