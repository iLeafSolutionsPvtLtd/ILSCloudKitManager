<img src="./Asset/art.png?raw=true">


# ILSCloudKitManager

ILSCloudKitManager is wrapper for managing apple's CloudKit operations like create, update, fetch and delete records.

CloudKit, Apple’s remote data storage service, provides a possibility to store app data using users’ iCloud accounts as a back-end storage service.

## Requirements
iOS 8.0


## How To Get Started

- Set up Cloud/CloudKit at iOS Developer Portal.
- Insert a bundle identifier and choose a corresponding Team.
- Select Capabilities tab in the target editor, and then switch ON the iCloud.

## Usage

### Create a new record

```objective-c 
[ILSCloudKitManager createRecord:recordDic WithRecordType:@"Enter Record Type Here" WithRecordId:@"Enter Record Id Here" completionHandler:^(NSArray *results, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"Saved successfully");
        }
    }];
```

### Retrieve existing records
```objective-c
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"#Enter Condition Here#"];
    [ILSCloudKitManager fetchAllRecordsWithType:@"#Enter Record Type Here#" withPredicate:@"#Enter Predicate Here#" CompletionHandler:^(NSArray *results, NSError *error) {
        
        if (error) {
            // Error handling for failed fetch from public database
        }
        else {
            // Display the fetched records
        }
    }];
```

### Update the record
```objective-c
[ILSCloudKitManager updateRecord:@"Enter Record Id Here" withRecord:@"Pass record that needs to be updated" completionHandler:^(NSArray *results, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"Saved successfully");
        }
    }];
```
### Remove the record
```objective-c
[ILSCloudKitManager removeRecordWithId:@"Enter Record Id Here" completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"error");
        }else{
            NSLog(@"deleted");
        }
    }];
```

## Author
iLeaf Solutions
 [http://www.ileafsolutions.com](http://www.ileafsolutions.com)


## License

    MIT License

	Copyright (c) 2018 iLeaf Solutions Pvt. Ltd.

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

    

