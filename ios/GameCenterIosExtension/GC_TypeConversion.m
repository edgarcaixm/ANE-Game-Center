//
//  TypeConversion.m
//  GameCenterIosExtension
//
//  Created by Richard Lord on 18/06/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "GC_TypeConversion.h"

#define ASPlayer "com.sticksports.nativeExtensions.gameCenter.GCPlayer"
#define ASScore "com.sticksports.nativeExtensions.gameCenter.GCScore"
#define ASAchievement "com.sticksports.nativeExtensions.gameCenter.GCAchievement"

@implementation TypeConversion

- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

- (FREResult) FREGetString:(NSString*)string asObject:(FREObject*)asString
{
    const char* utf8String = string.UTF8String;
    unsigned long length = strlen( utf8String );
    return FRENewObjectFromUTF8( length + 1, (uint8_t*) utf8String, asString );
}

- (FREResult) FREGetDate:(NSDate*)date asObject:(FREObject*)asDate
{
    NSTimeInterval timestamp = date.timeIntervalSince1970 * 1000;
    FREResult result;
    FREObject time;
    result = FRENewObjectFromDouble( timestamp, &time );
    if( result != FRE_OK ) return result;
    result = FRENewObject( "Date", 0, NULL, asDate, NULL );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( *asDate, "time", time, NULL);
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toString:(NSString*)value
{
    FREResult result;
    FREObject asValue;
    result = [self FREGetString:value asObject:&asValue];
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toBool:(uint32_t)value
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromBool( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toInt:(int32_t)value
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromInt32( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toDouble:(double)value
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromDouble( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toDate:(NSDate*)value
{
    FREResult result;
    FREObject asValue;
    result = [self FREGetDate:value asObject:&asValue];
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FREGetGKPlayer:(GKPlayer*)player asObject:(FREObject*)asPlayer
{
    FREResult result;
    
    result = FRENewObject( ASPlayer, 0, NULL, asPlayer, NULL);
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asPlayer property:"id" toString:player.playerID];
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asPlayer property:"alias" toString:player.alias];
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asPlayer property:"isFriend" toBool:player.isFriend];
    if( result != FRE_OK ) return result;
    
    return FRE_OK;
}

- (FREResult) FREGetGKScore:(GKScore*)score forPlayer:(GKPlayer*)player asObject:(FREObject*)asScore
{
    FREResult result;
    FREObject asPlayer;
    
    result = FRENewObject( ASScore, 0, NULL, asScore, NULL);
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asScore property:"category" toString:score.category];
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asScore property:"value" toInt:score.value];
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asScore property:"formattedValue" toString:score.formattedValue];
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asScore property:"date" toDate:score.date];
    if( result != FRE_OK ) return result;
    
    result = [self FREGetGKPlayer:player asObject:&asPlayer];
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( *asScore, "player", asPlayer, NULL );
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asScore property:"rank" toInt:score.rank];
    if( result != FRE_OK ) return result;
    
    return FRE_OK;
}

- (FREResult) FREGetGKAchievement:(GKAchievement*)achievement asObject:(FREObject*)asAchievement
{
    FREResult result;
    
    result = FRENewObject( ASAchievement, 0, NULL, asAchievement, NULL);
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asAchievement property:"id" toString:achievement.identifier];
    if( result != FRE_OK ) return result;
    
    result = [self FRESetObject:*asAchievement property:"value" toDouble:achievement.percentComplete / 100.0];
    if( result != FRE_OK ) return result;
    
    return FRE_OK;
}

@end
