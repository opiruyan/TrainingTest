//
//  HTOrderedMutableDictionary.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 05/05/2017.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTOrderedMutableDictionary.h"

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
    NSString *objectString;
    if ([object isKindOfClass:[NSString class]])
    {
        objectString = (NSString *)object;
    }
    else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
    {
        objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
    }
    else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
    {
        objectString = [(NSSet *)object descriptionWithLocale:locale];
    }
    else
    {
        objectString = [object description];
    }
    return objectString;
}

@interface HTOrderedMutableDictionary ()

@property (nonatomic ,strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation HTOrderedMutableDictionary

- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        self.dict = [[NSMutableDictionary alloc] initWithCapacity:numItems];
        self.array = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (![self.dict objectForKey:aKey])
    {
        [self.array addObject:aKey];
    }
    [self.dict setObject:anObject forKey:aKey];
}

- (NSUInteger)count
{
    return [self.dict count];
}

- (id)objectForKey:(id)aKey
{
    return [self.dict objectForKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [self.array removeObject:aKey];
    [self.dict removeObjectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
    return [self.array objectEnumerator];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *indentString = [NSMutableString string];
    NSUInteger i, count = level;
    for (i = 0; i < count; i++)
    {
        [indentString appendFormat:@"    "];
    }
    
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@{\n", indentString];
    for (NSObject *key in self)
    {
        [description appendFormat:@"%@    %@ = %@;\n",
         indentString,
         DescriptionForObject(key, locale, level),
         DescriptionForObject([self objectForKey:key], locale, level)];
    }
    [description appendFormat:@"%@}\n", indentString];
    return description;
}

@end
