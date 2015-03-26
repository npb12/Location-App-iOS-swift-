//
//  Location.h
//  ms
//
//  Created by Neil Ballard on 1/20/15.
//  Copyright (c) 2015 Missed Social. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * timestamp;

@end
