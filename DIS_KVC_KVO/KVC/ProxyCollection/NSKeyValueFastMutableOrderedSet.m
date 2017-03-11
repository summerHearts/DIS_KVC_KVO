//
//  NSKeyValueFastMutableOrderedSet.m
//  DIS_KVC_KVO
//
//  Created by renjinkui on 2017/3/10.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "NSKeyValueFastMutableOrderedSet.h"
#import "NSObject+NSKeyValueCodingPrivate.h"
#import "NSKeyValueMutatingOrderedSetMethodSet.h"
#import "NSKeyValueNonmutatingOrderedSetMethodSet.h"
#import "NSKeyValueGetter.h"
#import "NSKeyValueCodingCommon.h"
#import <objc/message.h>

@implementation NSKeyValueFastMutableOrderedSet

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

- (void)insertObject:(id)object atIndex:(NSUInteger)idx {
    if (_mutatingMethods.insertObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.insertObjectAtIndex, object, idx);
    }
    else {
        NSArray *objects = [[NSArray alloc] initWithObjects:&object count:1];
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:idx];
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.insertObjectsAtIndexes, objects, indexes);
        [objects release];
        [indexes release];
    }
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (_mutatingMethods.insertObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.insertObjectAtIndex, objects, indexes);
    }
    else {
        [super insertObjects:objects atIndexes:indexes];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)idx {
    if (_mutatingMethods.removeObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.removeObjectAtIndex, idx);
    }
    else {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:idx];
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

- (void)replaceObjectAtIndex:(NSUInteger)idx withObject:(id)object {
    if (_mutatingMethods.replaceObjectAtIndex) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.replaceObjectAtIndex, idx, object);
    }
    else if (_mutatingMethods.replaceObjectsAtIndexes){
        NSArray *objects = [[NSArray alloc] initWithObjects:&objects count:1];
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:idx];
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.replaceObjectsAtIndexes, indexes);
        [objects release];
        [indexes release];
    }
    else {
        [self removeObjectAtIndex:idx];
        [self insertObject:object atIndex:idx];
    }
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    if (_mutatingMethods.replaceObjectsAtIndexes) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _mutatingMethods.replaceObjectsAtIndexes, indexes,objects);
    }
    else {
        [super replaceObjectsAtIndexes:indexes withObjects:objects];
    }
}

@end

@implementation NSKeyValueFastMutableOrderedSet1

- (id)_proxyInitWithContainer:(id)container getter:(NSKeyValueGetter *)getter {
    if((self = [super _proxyInitWithContainer:container getter:getter])) {
        _nonmutatingMethods = [[getter nonmutatingMethods] retain];
    }
    return self;
}

+ (NSKeyValueProxyNonGCPoolPointer *)_proxyNonGCPoolPointer {
    static NSKeyValueProxyNonGCPoolPointer proxyPool;
    return &proxyPool;
}

- (void)_proxyNonGCFinalize {
    [_nonmutatingMethods release];
    [super _proxyNonGCFinalize];
    _nonmutatingMethods = nil;
}

- (NSUInteger)count {
    return ((NSUInteger (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.count);
}

- (void)getObjects:(id  _Nonnull *)objects range:(NSRange)range {
    if(_nonmutatingMethods.getObjectsRange) {
        ((void (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.getObjectsRange, objects,range);
    }
    else {
        [super getObjects:objects range:range];
    }
}

- (NSUInteger)indexOfObject:(id)object {
    return ((NSUInteger (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.indexOfObject, object);
}

- (id)objectAtIndex:(NSUInteger)idx {
    if(_nonmutatingMethods.objectAtIndex) {
        return ((id (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.objectAtIndex, idx);
    }
    else {
        NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:idx];
        NSArray *objects = ((NSArray * (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.objectsAtIndexes, idx);
        [indexes release];
        return [objects objectAtIndex:0];
    }
}

- (NSArray<id> *)objectsAtIndexes:(NSIndexSet *)indexes {
    if(_nonmutatingMethods.objectsAtIndexes) {
        return ((NSArray * (*)(id,Method,...))method_invoke)(self.container, _nonmutatingMethods.objectsAtIndexes, indexes);
    }
    else {
        return [super objectsAtIndexes:indexes];
    }
}

@end


@implementation NSKeyValueFastMutableOrderedSet2

- (id)_proxyInitWithContainer:(id)container getter:(NSKeyValueGetter *)getter {
    if((self = [super _proxyInitWithContainer:container getter:getter])) {
        _valueGetter = [[getter baseGetter] retain];
    }
    return self;
}

+ (NSKeyValueProxyNonGCPoolPointer *)_proxyNonGCPoolPointer {
    static NSKeyValueProxyNonGCPoolPointer proxyPool;
    return &proxyPool;
}

- (void)_proxyNonGCFinalize {
    [_valueGetter release];
    [super _proxyNonGCFinalize];
    _valueGetter = nil;
}

- (id)_nonNilOrderedSetValueWithSelector:(SEL)selector {
    id value = _NSGetUsingKeyValueGetter(self.container, _valueGetter);
    if(!value) {
        [NSException raise:NSInternalInconsistencyException format:@"%@: value for key %@ of object %p is nil", _NSMethodExceptionProem(self,selector), self.key, self.container];
    }
    return value;
}

- (NSUInteger)count {
    return [[self _nonNilOrderedSetValueWithSelector:_cmd] count];
}

- (void)getObjects:(id  _Nonnull *)objects range:(NSRange)range {
    [[self _nonNilOrderedSetValueWithSelector:_cmd] getObjects:objects range:range];
}

- (NSUInteger)indexOfObject:(id)object {
    return [[self _nonNilOrderedSetValueWithSelector:_cmd] indexOfObject:object];
}

- (id)objectAtIndex:(NSUInteger)idx {
    return [[self _nonNilOrderedSetValueWithSelector:_cmd] objectAtIndex:idx];
}

- (NSArray<id> *)objectsAtIndexes:(NSIndexSet *)indexes {
    return [[self _nonNilOrderedSetValueWithSelector:_cmd] objectsAtIndexes:indexes];
}

@end
