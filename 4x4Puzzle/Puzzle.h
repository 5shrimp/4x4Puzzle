//
//  Puzzle.h
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PuzzleMovementDirection)
{
    PuzzleMovementDirectionNone,
    PuzzleMovementDirectionUp,
    PuzzleMovementDirectionDown,
    PuzzleMovementDirectionLeft,
    PuzzleMovementDirectionRight
};


#pragma mark - Common

typedef int PuzzleValue;

extern const PuzzleValue kPuzzleValueEmpty;

typedef NSUInteger PuzzleSize;

#pragma mark - Field

typedef PuzzleValue* PuzzleField;

const PuzzleField CreatePuzzleFieldWithSize(const PuzzleSize size);
void PuzzleFieldRelease(const PuzzleField field);


#pragma mark - PuzzlePoint

typedef struct {
    NSInteger row;
    NSInteger column;
} PuzzlePoint;

extern const PuzzlePoint PuzzlePointInvalid;

BOOL PuzzlePointIsValid(const PuzzlePoint point);
PuzzlePoint PuzzlePointMake(const NSUInteger row, const NSUInteger column);

#pragma mark - PuzzleBase

typedef struct
{
    PuzzleField field;
    PuzzleSize size;
} * PuzzleBase;

const PuzzleBase CreatePuzzleBaseWithSize(const NSUInteger size);
void PuzzleBaseRelease(const PuzzleBase puzzle);
PuzzleSize PuzzleBaseGetSize(const PuzzleBase base);

PuzzleValue PuzzleBaseValueForPoint(const PuzzleBase base, const PuzzlePoint point);
void PuzzleBaseSetValueForPoint(const PuzzleBase base, const PuzzlePoint point, const PuzzleValue value);



@interface Puzzle: NSObject

@property (nonatomic, readonly) NSUInteger size;

- (instancetype)initWithSize:(NSUInteger)size NS_DESIGNATED_INITIALIZER;

- (BOOL)canMovePieceAtPoint:(PuzzlePoint)point;
- (PuzzleMovementDirection)movePieceAtPoint:(PuzzlePoint)point;
- (PuzzleValue)valueAtPoint:(PuzzlePoint)point;
- (PuzzlePoint)pointForValue:(PuzzleValue)value;

- (void)shuffle:(int)n;
- (BOOL)isCorrect;

@end
