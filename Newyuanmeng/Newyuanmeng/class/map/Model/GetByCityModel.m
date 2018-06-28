//
//Created by ESJsonFormatForMac on 17/12/13.
//

#import "GetByCityModel.h"
@implementation GetByCityModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"child" : [Child class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

@implementation Child


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


