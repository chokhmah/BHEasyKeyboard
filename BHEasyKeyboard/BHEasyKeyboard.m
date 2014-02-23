//
//  BHEasyKeyboard.m
//  BHEasyKeyboard
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "BHEasyKeyboard.h"

@implementation BHEasyKeyboard {
    UIView *iView;
}

@synthesize responder;

- (id)initWithView:(UIView *) view
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BHEasyKeyboard" owner:self options:nil] objectAtIndex:0];
        iView = view;
        
        double yHide = [self getScreenDimensions].height;
        [self setFrame:CGRectMake(0, yHide, self.frame.size.width, self.frame.size.height)];

        [self.textView setDelegate:self];
        [self.textView.layer setCornerRadius:7.0];
        [self.textView.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [self.textView.layer setBorderWidth:1.0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

    }
    return self;
}

- (void) keyboardWillHide:(NSNotification *) notification{// andView:(UIView *) view {

    CGSize screenSize = [self getScreenDimensions];
    CGRect lf = CGRectMake(0, screenSize.height, screenSize.width, self.bounds.size.height);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [self setFrame:lf];
	[UIView commitAnimations];
    
    [self removeFromSuperview];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // if the responder lost focus,
    // we still have to reflect what is written to the responder
    if ([textView isEqual:self.textView]) {
        [((UITextView *)self.responder) setText:textView.text];
    } else {
        [self.textView setText:textView.text];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    // responder must not be equal to our own textView
    if (![textView isEqual:self.textView]) {
        self.responder = textView;
    }
    
    [self newFocus];
    
    return YES;
}
#pragma mark End UITextViewDelegate

- (void) textDidChange:(id) c{
    if ([c isKindOfClass:[UITextField class]]) {
        [self.textView setText:((UITextField *)c).text];
    }
}

- (void) textTouchDown:(id) sender {
    self.responder = sender;

    [self newFocus];
}

// Listen for inputs that will be focused
// and show the text to our textView
- (void) newFocus {
    
    // Get rid of the bug that Can't find keyplane that supports type 8
    // when in ipad ios 6/6.1
    if ([responder keyboardType] == UIKeyboardTypeDecimalPad) {
        [responder setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
    
    if ([self.responder isKindOfClass:[UITextView class]]) {
        [self.textView setText:[((UITextView *)self.responder) text]];
        [((UITextView *)self.responder) setAutocorrectionType:UITextAutocorrectionTypeNo];
    } else if ([self.responder isKindOfClass:[UITextField class]]) {
        [self.textView setText:[((UITextField *)self.responder) text]];
        [((UITextField *)self.responder) setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    
    // listen for textfield values changes
    if ([self.responder isKindOfClass:[UITextField class]]) {
        [self.responder addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void) keyboardWillShow:(NSNotification *) notification{
    
    // textview keyboard type must be the same to the one who initiate the call
    [self.textView setKeyboardType:[responder keyboardType]];
//    NSLog(@"%d - %d", [responder keyboardType], UIKeyboardTypeDecimalPad);

    [self newFocus];
    
    CGRect keyboardFrame;
    double animationDuration;
    UIViewAnimationCurve curve;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardFrame];
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue: &animationDuration];
    [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue: &curve];
    
    // Listen to orientation change
    keyboardFrame = [iView convertRect:keyboardFrame toView:nil];

    // attach this view to the parent view.
    [iView addSubview:self];

    CGSize screenSize = [self getScreenDimensions];

    CGRect lf = CGRectMake(0, iView.frame.size.height - keyboardFrame.size.height - 100, screenSize.width, 100);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:curve];
    [self setFrame:lf];
	[UIView commitAnimations];

}

- (CGSize) getScreenDimensions {
    CGSize size;
    CGRect dimension = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        size = CGSizeMake(dimension.size.width, dimension.size.height);
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(dimension.size.height, dimension.size.width);
    }
    return size;
}

- (IBAction)btnDone:(id)sender {
    // dismiss the keyboard
    if ([self.responder isFirstResponder]) {
        [self.responder resignFirstResponder];
    } else {
        [self.textView resignFirstResponder];
    }
    
    // write to the caller what is typed
    if ([self.responder isKindOfClass:[UITextView class]]) {
        [((UITextView *)self.responder) setText:[self.textView text]];
    } else if ([self.responder isKindOfClass:[UITextField class]]) {
        [((UITextField *)self.responder) setText:[self.textView text]];
    }
}
@end
