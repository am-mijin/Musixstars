//
//  Perk+CoreDataProperties.h
//  Musixstars
//
//  Created by Mijin Cho on 28/12/2015.
//  Copyright © 2015 Musixstars. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Perk.h"

NS_ASSUME_NONNULL_BEGIN

@interface Perk (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *objectid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *createdat;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *delivery;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
