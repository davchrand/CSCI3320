//
//  ViewController.m
//  Calculator
//
//  Created by David Andrews on 2/1/15.
//  Copyright (c) 2015 edu.ucdenver.csci3320.davidandrews. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL isDisplayAResult;
@property (nonatomic) int userHasPressedDecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) int digitCounter;
@end

@implementation ViewController

@synthesize display = _display;
@synthesize operationReview = _operationReview;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

/////////////////////////////////////////////////////////////////////
//digitPressed is the function that handles digits being pressed.
//In this function the global scoped variable digitCounter is being
//iterated to show that a digit has been pressed. This variable is
//used by the BKSPPressed function to know when it is allowed to
//backspace.
/////////////////////////////////////////////////////////////////////
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    _digitCounter += 1;
    self.operationReview.text = [self.operationReview.text stringByAppendingString:digit];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

/////////////////////////////////////////////////////////////////////
//enterPressed is the fuction that pushes a number onto the stack
//once it is done being typed. Because of the requirements it also
//modifies the operationReview display to place a space after the
//last number entered.
/////////////////////////////////////////////////////////////////////
- (IBAction)enterPressed
{
    self.operationReview.text = [self.operationReview.text stringByAppendingString:@" "];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasPressedDecimal = 0;
}

/////////////////////////////////////////////////////////////////////
//operationPressed is the function that handles operations. It has a
//if statement that helps control the special operators that do not
//behave like normal, for example π and +/- operators.
/////////////////////////////////////////////////////////////////////

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = [sender currentTitle];
    if([operation  isEqual: @"π"]){
        [self enterPressed];
        self.operationReview.text = [self.operationReview.text stringByAppendingString:@" "];
        self.operationReview.text = [self.operationReview.text stringByAppendingString:operation];
        self.operationReview.text = [self.operationReview.text stringByAppendingString:@" "];
        double piResult = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", piResult];
    }else if ([operation isEqual: @"+/-"]){
        if(self.userIsInTheMiddleOfEnteringANumber){
            NSString *negativeString = @"-";
            negativeString = [negativeString stringByAppendingString:self.display.text];
            self.display.text = negativeString;
            self.operationReview.text = self.display.text;
        }else{
            [self enterPressed];
        }
        
    }else {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            [self enterPressed];
        }
        self.operationReview.text = [self.operationReview.text stringByAppendingString:@" "];
        self.operationReview.text = [self.operationReview.text stringByAppendingString:operation];
        self.operationReview.text = [self.operationReview.text stringByAppendingString:@" = "];
        double result = [self.brain performOperation:operation];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    _digitCounter = 0;
    _isDisplayAResult = YES;
}

/////////////////////////////////////////////////////////////////////
//clearPressed is the function that handles clearing the Calculator.
//It clears the calculator by reseting the buttons pressed display
//as well as emptying the calculator stack.
/////////////////////////////////////////////////////////////////////
- (IBAction)clearPressed
{
    self.display.text = @"0";
    self.operationReview.text = @" ";
    [_brain performClear];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

/////////////////////////////////////////////////////////////////////
//decimalPointPressed is the function that handles decimal points.
//It performs checks to make sure that only one decimal can be used
//for any entry. It also utilizes userIsInTheMiddleOfEnteringANumber
//to start with a leading zero if a number is not currently being
//entered.
/////////////////////////////////////////////////////////////////////

- (IBAction)decimalPointPressed
{
    self.userHasPressedDecimal += 1;
    if(self.userIsInTheMiddleOfEnteringANumber && self.userHasPressedDecimal <= 1){
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.operationReview.text = [self.operationReview.text stringByAppendingString:@"."];
    }else if(self.userHasPressedDecimal >1){
        //do nothing
    }else if(!self.userIsInTheMiddleOfEnteringANumber){
        self.display.text =  @"0.";
        self.operationReview.text = [self.operationReview.text stringByAppendingString:@"0."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

/////////////////////////////////////////////////////////////////////
//BKSPPressed is the function that handles backspace. BKSP is an
//abbreviation for backspace.This function performs checks to make
//sure that a digit has been pressed before it tries to delete one.
//It also checks to see if the answer on screen is a result from an
//operation. If it is a result it will not change the screen. If all
//of the number is erased it will reset the displays to their
//starting values.
/////////////////////////////////////////////////////////////////////
- (IBAction)BKSPPressed {
    if(_digitCounter > 0){
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        _digitCounter--;
        self.operationReview.text = self.display.text;
        self.display.text = self.display.text;
        if (_digitCounter == 0){
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }else if (_digitCounter == 0){
        if (_isDisplayAResult){
            //do nothing but prevents going out of bounds when
            //backspace is pressed after a result.
        }else {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
        
    }
}

@end




