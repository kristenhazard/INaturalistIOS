//
//  ObservationFieldValue.m
//  iNaturalist
//
//  Created by Ken-ichi Ueda on 9/12/12.
//  Copyright (c) 2012 iNaturalist. All rights reserved.
//

#import "ObservationFieldValue.h"
#import "Observation.h"
#import "ObservationField.h"

static RKManagedObjectMapping *defaultMapping = nil;
static RKObjectMapping *defaultSerializationMapping = nil;

@implementation ObservationFieldValue

@dynamic recordID;
@dynamic observationID;
@dynamic observationFieldID;
@dynamic value;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic syncedAt;
@dynamic localCreatedAt;
@dynamic localUpdatedAt;
@dynamic observationField;
@dynamic observation;

+ (RKManagedObjectMapping *)mapping
{
    if (!defaultMapping) {
        defaultMapping = [RKManagedObjectMapping mappingForClass:[ObservationFieldValue class]];
        [defaultMapping mapKeyPathsToAttributes:
         @"id",                     @"recordID",
         @"created_at_utc",         @"createdAt",
         @"updated_at_utc",         @"updatedAt",
         @"value",                  @"value",
         @"observation_id",         @"observationID",
         @"observation_field_id",   @"observationFieldID",
         nil];
        [defaultMapping mapKeyPath:@"observation_field" 
                    toRelationship:@"observaionField" 
                       withMapping:[ObservationField mapping]
                         serialize:NO];
        defaultMapping.primaryKeyAttribute = @"recordID";
    }
    return defaultMapping;
}

+ (RKObjectMapping *)serializationMapping
{
    if (!defaultSerializationMapping) {
        defaultSerializationMapping = [[RKManagedObjectMapping mappingForClass:[ObservationFieldValue class]] inverseMapping];
        [defaultSerializationMapping mapKeyPathsToAttributes:
         @"recordID",           @"observation_field_value[id]",
         @"value",              @"observation_field_value[value]",
         @"observationID",      @"observation_field_value[observation_id]",
         @"observationFieldID", @"observation_field_value[observation_field_id]",
         nil];
    }
    return defaultSerializationMapping;
}

- (NSString *)defaultValue
{
    if (self.observationField.allowedValuesArray.count > 0) {
        return [self.observationField.allowedValuesArray objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSNumber *)observationFieldID
{
    [self willAccessValueForKey:@"observationFieldID"];
    if (!self.primitiveObservationFieldID || [self.primitiveObservationFieldID intValue] == 0) {
        [self setPrimitiveObservationFieldID:self.observationField.recordID];
    }
    [self didAccessValueForKey:@"observationFieldID"];
    return [self primitiveObservationFieldID];
}

- (NSNumber *)observationID
{
    [self willAccessValueForKey:@"observationID"];
    if (!self.primitiveObservationID || [self.primitiveObservationID intValue] == 0) {
        [self setPrimitiveObservationID:self.observation.recordID];
    }
    [self didAccessValueForKey:@"observationID"];
    return [self primitiveObservationID];
}

- (void)setValue:(NSString *)newValue
{
    [self willAccessValueForKey:@"value"];
    [self setPrimitiveValue:[newValue stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]]];
    [self didAccessValueForKey:@"value"];
}

@end