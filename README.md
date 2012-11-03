fig_leaf
========

Private inheritance for Ruby classes.

FigLeaf enables us to selectively make public methods inherited from other classes and modules private. The objects can still call these methods internally, but external classes are prevented from doing so.


##Installation
``` sh
gem install fig_leaf
```
or add to Gemfile
``` ruby
gem 'fig_leaf'
```

##Usage  
``` ruby
class Post < ActiveRecord::Base
  include FigLeaf
  
  hide ActiveRecord::Base, ancestors: true, except: [
    Object, :init_with, :new_record?, :errors, :valid?, :save ]
    
  hide_singletons ActiveRecord::Calculations,
    ActiveRecord::FinderMethods, ActiveRecord::Relation

  # ...
```
      
In this code, we hide the entire `ActiveRecord::Base` interface, with just a few carefully chosen exceptions like `#valid?` and `#save`. We also hide a bunch of the more common class-level methods that ActiveRecord adds, like `.find`, `.all`, and `#count` by calling `#hide_singleton` with the modules which define those methods.

Now, if we jump into the console and try to call common ActiveRecord methods on it, we are denied access:

```
ruby-1.9.2-p0 > Post.find(1)
NoMethodError: private method `find' called for #<Class:0xa1a4a50>
    
ruby-1.9.2-p0 > Post.new.destroy
NoMethodError: Attempt to call private method
```
    
FigLeaf is not intended as a hammer to keep your coworkers or your library clients in line. It's not as if that would work, anyway; the strictures that it adds are easy enough to circumvent.

FigLeaf's intended role is more along the lines of the "rumble strips" along highways which give you a jolt when you veer off into the shoulder. It provides a sharp reminder when you've unthinkingly introduced a new bit of coupling to an interface you are trying to keep isolated from the rest of the codebase. Then, you can consciously make the decision whether to make that method public, or find a different way of going about what you were doing.