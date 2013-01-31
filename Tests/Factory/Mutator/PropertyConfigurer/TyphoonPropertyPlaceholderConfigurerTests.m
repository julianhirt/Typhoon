////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "Typhoon.h"
#import "Knight.h"

@interface TyphoonPropertyPlaceholderConfigurerTests : SenTestCase
@end

@implementation TyphoonPropertyPlaceholderConfigurerTests
{
    TyphoonPropertyPlaceholderConfigurer* _configurer;
}

- (void)setUp
{
    id<TyphoonResource> propertyFile1 = [TyphoonBundleResource withName:@"SomeProperties.properties"];
    _configurer = [TyphoonPropertyPlaceholderConfigurer configurerWithResources:propertyFile1, nil];

}

- (void)test_parses_property_name_value_pairs
{
    NSDictionary* properties = [_configurer properties];
    NSLog(@"Properties: %@", properties);
}

- (void)test_mutates_property_values
{
    TyphoonComponentFactory* factory = [[TyphoonComponentFactory alloc] init];
    TyphoonDefinition* knightDefinition = [[TyphoonDefinition alloc] initWithClass:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@selector(damselsRescued) withValueAsText:@"${damsels.rescued}"];
    [factory register:knightDefinition];

    [_configurer mutateComponentDefinitionsIfRequired:[factory registry]];

    Knight* knight = [factory componentForType:[Knight class]];
    assertThatUnsignedLongLong(knight.damselsRescued, equalToUnsignedLongLong(12));

}

@end