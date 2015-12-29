//
//  User+CoreDataProperties.h
//  Musixstars
//
//  Created by Mijin Cho on 28/12/2015.
//  Copyright © 2015 Musixstars. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstname;
@property (nullable, nonatomic, retain) NSString *lastname;
@property (nullable, nonatomic, retain) NSString *objectid;
@property (nullable, nonatomic, retain) NSString *bankname;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *role;
@property (nullable, nonatomic, retain) NSString *sortcode;
@property (nullable, nonatomic, retain) NSString *account_name;
@property (nullable, nonatomic, retain) NSString *account_number;
@property (nullable, nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END
