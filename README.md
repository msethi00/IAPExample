IAPExample
==========

Copyright (c) 2014 Muneesh Sethi / Advance Micro Consulting

 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 
1) IAPExample is a demonstration of how to implement Apple IAP in your iOS App.
 There are two examples of consumables and one example of non-consumable. There is also
 an example of Restoring a non-consumable purchase which is a requirement by Apple.
 Finally all purchases are put through Apple's receipt verification flow which I 
 highly recommend as I have personally seen a great benefit of preventing pirated
 purchases.
 
2) In my example I have 2 levels of helper/wrappers.
    a) IAPHelper is the lower level helper wrapper which provides the essentials for any apple IAP flow.
    b) IAPHelperWrapper is a bit application specific but can be used for multiple apps. For demonstration purposes
    this class does not need to be modified. However will ened modification when putting into your own app specific
    product purchase flow.

3) To get started Simply modify the AppConfig.h. You will need to enter in the following
    a) Your own kIAP_SECRETKEY
    b) A product id for kIAP_9KEYS, & kIAP_27Keys consumable (please refer to apple documentation on how to create this)
    c) A product id for kIAP_UNLOCK_PAID_VERSION_PRODUCT non-consumable. (please refer to apple documentation on how to create this)
    
4) Once you have the above. Build & Run and you should be able to purchase test products.
  
5) Questions, feedback, and bug reporting can be sent to msethi@gamicks.com. Enjoy.  
    
    
    
    
