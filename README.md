BHEasyKeyboard - iOS 6/7 (iPad/iPhone)
==============

Allow you to handle text inputs in iOS easily, without the need to modify or move every parent view of the text inputs, which would be hassle for my part.


How
---------------
1. Just add/drag the BHEasyKeyboard folder into your project navigator
2. Add the QuartzCore.framework
3. Add the UITextField/UITextView as outlets in your ViewController and connect it with the inputs in your ViewController in interface builder. Or you can do it your own way, as long as it will still gonna work.
4. Create an IBAction that has a "Editing Did Begin" event, and connect your UITextField. (note. you cannot connect UITextView in the IBAction, we'll handle that later)
5. And in your implementation file
    - import the BHEasyKeyboard header file - ```#import "BHEasyKeyboard.h"```
    - Create a class variable of ```BHEasyKeyboard```
    - instantiate it in viewDidLoad if it is nil. Here we set all the UITextView delegate to the instance of our ```BHEasyKeyboard```.
    - And don't forget to set the sender of the "textTouchDown" of our library


Refer to the Sample Project
---------------


Happy Coding!!!  XD
---------------


License
---------------
The MIT License (MIT)

Copyright (c) 2014 

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
