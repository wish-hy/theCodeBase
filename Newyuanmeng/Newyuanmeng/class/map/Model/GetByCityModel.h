//
//Created by ESJsonFormatForMac on 17/12/13.
//

#import <Foundation/Foundation.h>

@class Child;
@interface GetByCityModel : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *parent_id;

@property (nonatomic, copy) NSString *short_name;

@property (nonatomic, strong) NSArray<Child *> *child;

@property (nonatomic, copy) NSString *name;

@end
@interface Child : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *parent_id;

@property (nonatomic, copy) NSString *short_name;

@property (nonatomic, copy) NSString *name;

@end

