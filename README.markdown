Methodphitamine
===============

The Methodphitamine is a library for syntactically cleaner list comprehensions and an interesting approach to monads in Ruby.

For more information, read my [blog post](http://jicksta.com/posts/the-methodphitamine) covering the Methodphitamine.

Cleaner Symbol#to_proc
----------------------

One of the beautiful things the Ruby community has informally built into the language is Symbol#to_proc. The Methodphitamine takes beauty one step further.

Below are code examples which show the Methodphitamine's syntactical improvements over vanilla Ruby and Symbol#to_proc:

First, the pure-Ruby way:

    User.find(:all).map{|x| x.contacts.map{|y| y.last_name.capitalize }}

And now with Symbol#to_proc:

    User.find(:all).map{|x|x.contacts.map(&:last_name).map(&:capitalize)}

And now with the Methodphitamine once more:

    User.find(:all).map &its.contacts.map(&its.last_name.capitalize)

Notice how even with Symbol#to_proc a block literal is still necessary because it simply can’t do nested arguments. The Methodphitamine fixes this by preserving all arguments and being more readable to boot.

New: Monads
-----------

You can now do something like this:

    my_array.maybe &it.first.reverse.upcase

If the `my_array` variable were equal to `["foo", "bar", "qaz"]`, the result of the expression above would be `"OOF"`. However, if `my_array` were equal to `[]`, the result of the expression would be `nil`. This `maybe` method will execute the chain of methods if and only if all were successful. If one failed, `nil` is returned.

So how does The Methodphitamine work?
-------------------------------------

The `it()` and `its()` protected methods are added to `Kernel` so it can be called from anywhere in a Ruby script but not on any particular `Object` instance. They each simply return a new `It` instance.

The `It` class has all instance methods stripped from it (except the ones Ruby complains about) to ensure `method_missing()` catches everything. In the example `[1,"2",3].map &its.class.name`, the `It` object first receives the `class()` method with no arguments via `method_missing()`. This gets enqueued in the `@methods` `Array` and it returns itself to receive any more methods. It then receives the next method, namely `name()`, and enqueues that alongside the previous method. When no more methods exist, Ruby determines if the `It` instance has a `to_proc()` method by calling `respond_to?(:to_proc)` so this has to be ignored and self suffices as a Ruby true boolean.

Then the magic happens. Because `map()` takes a block (essentially a `Proc` argument), this can be substituted with a variable or method that returns a block as long as an ampersand prepends it to let the Ruby interpreter know to call `to_proc()` on it. The `It#to_proc()` method is invoked, building a custom, dynamic `Proc`. Because these enumerations yield a variable, the dynamic `Proc` is executed for each item in the collection and `obj` consequentially becomes a reference to the current item in the collection. We then run through the enqueued methods with `inject()`, passing along the return value of executing each method in the order received with arguments intact. When `inject()` is done, it simply returns the grand product which becomes the return value of the `Proc` itself. Simple, right? :)

I chose to define both `it()` and `its()` since methods in Ruby can semantically either mean “the result of this action” or the possessive “this attribute.” For example, `it.to_s` and `it.sort_by` are both conceptual actions and `its.class.name` and `its.last` are both conceptual attributes.

The idea of an it implied block argument comes from the Groovy guys. For example, this is valid Groovy:

    [1,2,3,4].each { println it }

From the Groovy documentation on closures, “A closure always has at least one argument, which will be available within the body of the closure via the implicit parameter it if no explicit parameters are defined. The developer never has to declare the it variable – like the this parameter within objects, it is implicitly available.”
