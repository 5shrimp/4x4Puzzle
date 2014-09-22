//
//  Puzzle.m
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import "Puzzle.h"

const PuzzleValue kPuzzleValueEmpty = 0;

const PuzzlePoint PuzzlePointInvalid = {
    .row = -1,
    .column = -1
};

// Private
NSUInteger PuzzleBaseFieldOffsetForPoint(const PuzzleBase base, const PuzzlePoint point);


#pragma mark - PuzzleField Implementation

const PuzzleField CreatePuzzleFieldWithSize(const PuzzleSize size)
{
    PuzzleField field = (PuzzleField)malloc(size * size);
    memset(field, 0, size * size);
    return field;
}

void PuzzleFieldRelease(const PuzzleField field)
{
    free(field);
}

#pragma mark - PuzzlePoint Implementation

PuzzlePoint PuzzlePointMake(const NSUInteger row, const NSUInteger column)
{
    PuzzlePoint point = {
        .row = row,
        .column = column
    };
    
    return point;
}

BOOL PuzzlePointIsValid(const PuzzlePoint point)
{
    return point.row != -1 && point.column != -1;
}

#pragma mark - PuzzleBase Implementation

const PuzzleBase CreatePuzzleBaseWithSize(const NSUInteger size)
{
    PuzzleBase puzzleBase = (PuzzleBase)malloc(size * size);
    puzzleBase->size = size;
    puzzleBase->field = CreatePuzzleFieldWithSize(size);
    return puzzleBase;
}

void PuzzleBaseRelease(const PuzzleBase puzzle)
{
    PuzzleFieldRelease(puzzle->field);
    free(puzzle);
}

PuzzleSize PuzzleBaseGetSize(const PuzzleBase base)
{
    return base->size;
}

PuzzleSize PuzzleBaseGetFieldSize(const PuzzleBase base)
{
    PuzzleSize baseSize = PuzzleBaseGetSize(base);
    return baseSize * baseSize;
}

NSUInteger PuzzleBaseFieldOffsetForPoint(const PuzzleBase base, const PuzzlePoint point)
{
    return point.row * base->size + point.column;
}

PuzzleValue PuzzleBaseValueAtOffset(const PuzzleBase base, const NSUInteger offset)
{
    return base->field[offset];
}

PuzzleValue PuzzleBaseValueForPoint(const PuzzleBase base, const PuzzlePoint point)
{
    return PuzzleBaseValueAtOffset(base, PuzzleBaseFieldOffsetForPoint(base, point));
}

void PuzzleBaseSetValueAtOffset(const PuzzleBase base, const NSUInteger offset, const PuzzleValue value)
{
    base->field[offset] = value;
}

void PuzzleBaseSetValueForPoint(const PuzzleBase base, const PuzzlePoint point, const PuzzleValue value)
{
    PuzzleBaseSetValueAtOffset(base, PuzzleBaseFieldOffsetForPoint(base, point), value);
}

void PuzzleBaseFillWithInitialValues(const PuzzleBase base)
{
    for (NSUInteger i=0; i<PuzzleBaseGetFieldSize(base)-1; i++) {
        PuzzleBaseSetValueAtOffset(base, i, (PuzzleValue)i+1);
    }
    
    PuzzleBaseSetValueAtOffset(base, PuzzleBaseGetFieldSize(base)-1, kPuzzleValueEmpty);
}

PuzzlePoint PuzzleBasePointForOffset(const PuzzleBase base, const NSUInteger offset)
{
    PuzzleSize size = PuzzleBaseGetSize(base);
    return PuzzlePointMake(offset/size, offset%size);
}

PuzzlePoint PuzzleBasePointWithValue(const PuzzleBase base, const PuzzleValue value)
{
    for (NSUInteger i=0; i<PuzzleBaseGetFieldSize(base); i++) {
        if (PuzzleBaseValueAtOffset(base, i) == value) {
            return PuzzleBasePointForOffset(base, i);
        }
    }
    
    return PuzzlePointInvalid;
}


@interface Puzzle()
@property (nonatomic) PuzzleBase base;
@end

@implementation Puzzle

- (instancetype)initWithSize:(NSUInteger)size
{
    self = [super init];
    if (self) {
        _base = CreatePuzzleBaseWithSize(size);
        PuzzleBaseFillWithInitialValues(_base);
    }
    return self;
}

- (void)dealloc
{
    PuzzleBaseRelease(_base), _base = NULL;
}

- (NSUInteger)size
{
    return PuzzleBaseGetSize(self.base);
}

/**
 * Here I choose one of the "moveble" pieces of puzzle as random, move it into empty space and repeat it (n) times.
 */
-(void)shuffle:(int)n
{
    for (int i = 0; i < n; i++) {
        PuzzlePoint point;
        do {
            point = (PuzzlePoint){
                .row = arc4random() % [self size],
                .column = arc4random() % [self size]
            };
        } while(![self canMovePieceAtPoint:point]);
        [self movePieceAtPoint:point];
    }
}

/**
 * If puzzle is sorted in correct order.
 */
- (BOOL)isCorrect
{
    const NSUInteger baseSize = PuzzleBaseGetSize(self.base);
    const NSUInteger piecesMaxIndex = baseSize * baseSize - 1; // last piece must be empty
    
    for (NSUInteger i=0; i<piecesMaxIndex; i++) {
        BOOL isCorrectValue = PuzzleBaseValueAtOffset(self.base, i) == i;
        if (!isCorrectValue) {
            return NO;
        }
    }

    return YES;
}

- (PuzzlePoint)convertPoint:(PuzzlePoint)point toDirection:(PuzzleMovementDirection)direction
{
    switch (direction) {
        case PuzzleMovementDirectionUp:
            point.row -= 1;
            break;
        case PuzzleMovementDirectionDown:
            point.row += 1;
            break;
        case PuzzleMovementDirectionLeft:
            point.column -= 1;
            break;
        case PuzzleMovementDirectionRight:
            point.column += 1;
            break;
        case PuzzleMovementDirectionNone:
            break;
    }
    
    return point;
}

- (BOOL)pointIsValid:(PuzzlePoint)point
{
    return point.row >= 0 && point.row < [self size] && point.column >= 0 && point.column < [self size];
}

- (PuzzleMovementDirection)availableDirectionToMovePoint:(PuzzlePoint)point
{
#define CHECK_DIRECTION(DIRECTION)\
    {\
        PuzzlePoint convertedPoint = [self convertPoint:point toDirection:DIRECTION];\
        if ([self pointIsValid:convertedPoint] && [self valueAtPoint:convertedPoint] == kPuzzleValueEmpty) {\
            return DIRECTION;\
        }\
    }
    
    CHECK_DIRECTION(PuzzleMovementDirectionUp)
    CHECK_DIRECTION(PuzzleMovementDirectionDown)
    CHECK_DIRECTION(PuzzleMovementDirectionLeft)
    CHECK_DIRECTION(PuzzleMovementDirectionRight)
    
#undef CHECK_DIRECTION
    
    return PuzzleMovementDirectionNone;
}

- (BOOL)canMovePieceAtPoint:(PuzzlePoint)point
{
    return [self availableDirectionToMovePoint:point] != PuzzleMovementDirectionNone;
}

- (PuzzleMovementDirection)movePieceAtPoint:(PuzzlePoint)point
{
    PuzzleMovementDirection direction = [self availableDirectionToMovePoint:point];
    
    if (direction != PuzzleMovementDirectionNone) {
        PuzzlePoint movementPoint = [self convertPoint:point toDirection:direction];
        PuzzleValue currentValue = PuzzleBaseValueForPoint(self.base, point);
        PuzzleBaseSetValueForPoint(self.base, point, kPuzzleValueEmpty);
        PuzzleBaseSetValueForPoint(self.base, movementPoint, currentValue);
    }
    
    return direction;
}

- (PuzzleValue)valueAtPoint:(PuzzlePoint)point
{
    return PuzzleBaseValueForPoint(self.base, point);
}

- (PuzzlePoint)pointForValue:(PuzzleValue)value
{
    return PuzzleBasePointWithValue(self.base, value);
}

@end
