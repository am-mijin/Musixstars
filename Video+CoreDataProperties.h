//
//  Video+CoreDataProperties.h
//  Musixstars
//
//  Created by Mijin Cho on 28/12/2015.
//  Copyright © 2015 Musixstars. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Video.h"

NS_ASSUME_NONNULL_BEGIN

@interface Video (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *objectid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *videoid;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSDate *expirydate;
@property (nullable, nonatomic, retain) NSDate *createdat;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *artist;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) Perk *perk;

@end

NS_ASSUME_NONNULL_END
