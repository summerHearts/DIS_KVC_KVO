//
//  NSKeyValueFastMutableArray.m
//  DIS_KVC_KVO
//
//  Created by renjinkui on 2017/2/16.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "NSKeyValueFastMutableArray.h"
#import "NSKeyValueMutatingArrayMethodSet.h"
#import "NSKeyValueNonmutatingArrayMethodSet.h"
#import "NSObject+NSKeyValueCodingPrivate.h"
#import "NSKeyValueCodingCommon.h"
#import <objc/message.h>

@implementation NSKeyValueFastMutableArray

- (id)_proxyInitWithContainer:(id)container getter:(NSKeyValueGetter *)getter {
    if ((self = [super _proxyInitWithContainer:container getter:getter])) {
        _mutatingMethods = [[getter mutatingMethods] retain];
    }
    return self;
}

- (void)_proxyNonGCFinalize {
    [_mutatingMethods release];
    [super _proxyNonGCFinalize];
    _mutatingMethods = nil;
}

- (void)addObject:(id)anObject {
    [self insertObject:anObject atIndex:self.count];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (_mutatingMethods.insertObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.insertObjectAtIndex, anObject, index);
    }
    else {
        NSArray *objects = [[NSArray alloc] initWithObjects:&anObject count:1];
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:index];
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.insertObjectsAtIndexes, objects, indexes);
        [indexes release];
    }
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (_mutatingMethods.insertObjectsAtIndexes) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.insertObjectsAtIndexes, objects, indexes);
    }
    else {
        [super insertObjects:objects atIndexes:indexes];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    if (_mutatingMethods.removeObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.removeObjectAtIndex, index);
    }
    else {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:index];
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.removeObjectsAtIndexes, indexes);
        [indexes release];
    }
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
    if (_mutatingMethods.removeObjectsAtIndexes) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.removeObjectsAtIndexes, indexes);
    }
    else {
        [super removeObjectsAtIndexes:indexes];
    }
}

- (void)removeLastObject {
    [self removeObjectAtIndex:self.count - 1];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (_mutatingMethods.replaceObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.replaceObjectAtIndex, index, anObject);
    }
    else if(_mutatingMethods.replaceObjectsAtIndexes){
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:index];
        NSArray *objects = [[NSArray alloc] initWithObjects:&anObject count:1];
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.replaceObjectsAtIndexes,indexes, objects);
        [objects release];
        [indexes release];
    }
    else {
        [self removeObjectAtIndex:index];
        [self insertObject:anObject atIndex:index];
    }
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    if(_mutatingMethods.replaceObjectsAtIndexes){
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.replaceObjectsAtIndexes,indexes, objects);
    }
    else {
        [super replaceObjectsAtIndexes:indexes withObjects:objects];
    }
}


@end


@implementation NSKeyValueFastMutableArray1

- (id)_proxyInitWithContainer:(id)container getter:(NSKeyValueGetter *)getter {
    if ((self = [super _proxyInitWithContainer:container getter:getter])) {
        _nonmutatingMethods = [[getter nonmutatingMethods] retain];
    }
    return self;
}

- (void)_proxyNonGCFinalize {
    [_nonmutatingMethods release];
    [super _proxyNonGCFinalize];
    _nonmutatingMethods = nil;
}

+ (NSKeyValueProxyNonGCPoolPointer *)_proxyNonGCPoolPointer {
    static NSKeyValueProxyNonGCPoolPointer proxyPool;
    return &proxyPool;
}

- (NSUInteger)count {
    return ((NSUInteger (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.count);
}

- (void)getObjects:(id  _Nonnull *)objects range:(NSRange)range {
    if (_nonmutatingMethods.getObjectsRange) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.getObjectsRange, objects, range);
    }
    else {
        [super getObjects:objects range:range];
    }
}

- (id)objectAtIndex:(NSUInteger)index {
    if (_nonmutatingMethods.objectAtIndex) {
        return ((id (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.objectAtIndex, index);
    }
    else {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:index];
        NSArray *objects = ((NSArray * (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.objectsAtIndexes,indexes);
        [indexes release];
        return [objects objectAtIndex:index];
    }
}

- (NSArray<id> *)objectsAtIndexes:(NSIndexSet *)indexes {
    if (_nonmutatingMethods.objectsAtIndexes) {
        return ((id (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.objectsAtIndexes, indexes);
    }
    else {
        return [super objectsAtIndexes:indexes];
    }
}

@end

@implementation NSKeyValueFastMutableArray2
- (id)_proxyInitWithContainer:(id)container getter:(NSKeyValueGetter *)getter {
    if ((self = [super _proxyInitWithContainer:container getter:getter])) {
        _valueGetter = [[getter baseGetter] retain];
    }
    return self;
}

- (void)_proxyNonGCFinalize {
    [_valueGetter release];
    [super _proxyNonGCFinalize];
    _valueGetter = nil;
}

- (id)_nonNilArrayValueWithSelector:(SEL)selector {
    id value = _NSGetUsingKeyValueGetter(self.container, _valueGetter);
    if (!value) {
        [NSException raise:NSInternalInconsistencyException format:@"%@: value for key %@ of object %p is nil", _NSMethodExceptionProem(self, selector), self.key, self.container];
    }
    return value;
}

+ (NSKeyValueProxyNonGCPoolPointer *)_proxyNonGCPoolPointer {
    static NSKeyValueProxyNonGCPoolPointer proxyPool;
    return &proxyPool;
}

- (NSUInteger)count {
    return [[self _nonNilArrayValueWithSelector:_cmd] count];
}

- (void)getObjects:(id  _Nonnull *)objects range:(NSRange)range {
    [[self _nonNilArrayValueWithSelector:_cmd] getObjects:objects range:range];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [[self _nonNilArrayValueWithSelector:_cmd] objectAtIndex:index];
}

- (NSArray<id> *)objectsAtIndexes:(NSIndexSet *)indexes {
    return [[self _nonNilArrayValueWithSelector:_cmd] objectsAtIndexes:indexes];
}

@end
