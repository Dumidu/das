#Das

---

Browser [modal](#modals), [subscriber](#subscribers), and [bounce protection](#bounce-protection)
utilities. All in one handy place.

## Usage

<code>[examples/](https://github.com/acumenbrands/das/tree/master/examples)</code>
will probably be most helpful to get you going and to see how all the features
can work together. Both complex and simple examples are within.

Here is a step-by step for the simplest execution of all Das utilities.

### Modals

You don't have to do it this way; however, best practice is to start by loading
das.js asynchronously within an anonymous function and assign an onload function
to handle modal creation:

    (function(){
      var s    = document.createElement('script');
      s.src    = '../build/das.js';
      s.onload = onDasLoad;
      document.body.appendChild(s);
    })();

Use your spankin new onload function to create a window-level <code>var</code>
that will hold modals for easy use by events:

    (function(){
      //...

      var onDasLoad = function(){
        window.myBunchOModals  = window.myBunchOModals || {};
        myBunchOModals.myModal = makeMeAModal();
      };

    })();

Create your modal. You can assign the modal's content to a dom element or to a
URL. Make sure the server you specify allows [CORS](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
access or it will be blocked by your browser.

    (function(){
      //...

      var makeMeAModal = function(){
        return new DasModal({
          id              : 'mymodal',
          content         : document.getElementById('#modal_content'),
          stylesheet      : './css/das.css'
        });
      };

    })();

You can optionally **use your modal as a content gate**. This often-requested
feature may be enabled with the argument parameter <code>behavior: 'gate'</code>.
Gate modals will <code>trigger()</code> when constructed, but may not show if
the cookie parameters are not met. If more aggressive gate behavior is desired,
you may use the <code>myModal.open()</code> function;

**Callbacks** are triggered when the modal acts like it do. To assign your own
functions, use the argument parameters <code>onopen:</code>, <code>onclose:</code>,
<code>onready:</code>, <code>onContentLoaded:</code>, and <code>ontrigger:</code>.

### Subscribers

Let's say you have a <code>&lt;form&gt;</code>,
an <code>&lt;input&gt;</code> for email, and a <code>&lt;input type="submit"&gt;</code>
 -- congrats! You've got everything you need to make an AJAX subscriber.

    (function(){
      //...

      var makeMeASubscriber = function(){
        return new DasSubscriber({
          form : window.document.querySelector('#signup_form')
        });
      };

    })();

You'll probably want to do something with the UI when the user submits the form,
so you can use the argument parameters <code>oncomplete:</code>, <code>onsubmit:</code>,
and <code>onerror:</code> for that.

    (function(){
      //...

      var myCompleteHandler = function() {
        // this == Subscriber instance
      };

      var mySubmitHandler = function() {
        // this == Subscriber instance
      };

      var myErrorHandler = function() {
        // this == Subscriber instance
      };

      var makeMeASubscriber = function(){
        return new DasSubscriber({
          form       : window.document.querySelector('#giveaway_onexit form'),
          oncomplete : myCompleteHandler,
          onsubmit   : mySubmitHandler,
          onerror    : myErrorHandler
        });
      };

    })();

### Bounce Protection

**Bounce Protectors Have What Marketers Crave!<sup>TM</sup>** Bounce protectors
are basically listeners that respond when the user clicks the back button or
behaves like they want to leave the page. They're a last line of defense for
serving content to a user that is about to bounce. Don't make a waste of the
Internet. Please use responsibly with the callback parameters
<code>onforwardbutton:</code>, <code>onbackbutton:</code>, and <code>onmouseleave:</code>.

    (function(){
      //...

      window.bounceProtection = new DasBounceProtection({
        onforwardbutton : function(){
          // doSomething();
        },
        onbackbutton    : function(){
          // doSomethingElse();
        },
        onmouseleave    : function(){
          // doSomethingElseElse();
        }
      });
    })();


## Dev/Build Environment

Of course you want to make changes, because of course you do.

### Setup

To get started making changes, <code>cd</code> into the directory where you
cloned this repo and do thusly to install dependencies:

    npm install



### Build and Run Tests

    grunt

### Create releases

@wip

## To Deploy to S3

**To configure,** copy <code>config/aws-config.json.example</code> to
<code>config/aws-config.json</code> and edit with your AWS credentials.

**Deploy** from the terminal:

    grunt deploy:production

Tests will run and will abort deploy on error.
