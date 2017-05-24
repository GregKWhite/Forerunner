[![CircleCI](https://circleci.com/gh/GregKWhite/Forerunner.svg?style=svg)](https://circleci.com/gh/GregKWhite/Forerunner)
[![codecov](https://codecov.io/gh/GregKWhite/Forerunner/branch/master/graph/badge.svg)](https://codecov.io/gh/GregKWhite/Forerunner)

# Forerunner
Forerunner defines a simple, familiar DSL for definining callbacks above
controller actions instead of defining them at the top of the class using
`before_action`. Instead of constantly going back to the top of your controllers
to see which methods should be called before a controller action, just look
above the controller action's definition!

Using `before_action` works well for most cases, but it falls short when you
have methods that should only be run for one method, or when your controllers
grow large. It becomes  a pain to know exactly what happens before each
controller action, and that's exactly the problem that `Forerunner` intends to
solve.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'forerunner'
```

And then execute:
```bash
$ bundle
```

Or install it yourself by running:
```bash
$ gem install forerunner
```

## Getting Started

Using `Forerunner` is quite easy. In your `ApplicationController`, just `include
Forerunner`. That's it!

Here's a barebones implementation:

```ruby
class ApplicationController < ActionController::Base
  include Forerunner
end
```

Now you have the `Forerunner` library available to you in all controllers that
subclass `ApplicationController`.  You can also include this on a controller by
controller basis, if you don't anticipate needing it everywhere.

## Usage

`Forerunner` provides you with a new method called `precede_with` that defines
allows you to specify a method to get called before the next defined controller
action.

Essentially, these two things are equivalent:
```ruby
# Normal implementation
class ExampleController < ApplicationController
  before_action :do_a_thing, only: %i(index)
  
  def index
    # index logic goes here
  end
end

# Forerunner implementation
class ExampleController < ApplicationController
  precede_with :do_a_thing
  def index
    # index logic goes here
  end
end
```

Let's say you have a `PostsController` that allows anyone to view posts, but
only allows authorized users to create new posts. Here's how your controller
would likely look:

```ruby
class PostsController < ApplicationController
  before_action :authorize_user, only: %i(create)
  before_action :another_action, only: %i(create)
  
  def index
    # index logic goes here
  end
  
  def create
    # create logic goes here
  end
end
```

The problem with this is that at a glance, you don't know what happens before
`create` is called.  The methods are in two separate lines at the top of the
class, far away from the actual `create` definition.  Instead, what if you could
know what happens before each action at a glance?

Here's how that controller would look if it utilized `Forerunner`:

```ruby
class PostsController < ApplicationController
  def index
    # index logic goes here
  end

  precede_with :authorize_user, :another_action
  def create
    # create logic goes here
  end
end
```

In this implementation, you don't have to worry about what happens before
`create` is called; it's readily apparent! You can immediately tell that
`authorize_user` is called, immediately followed by `another_action`.

## Other Goodies

`Forerunner` exposes two additional methods not mentioned above: 
`Forerunner#follow_with` and `Forerunner#surround_with`. These methods correspond
to `after_action` and `around_action`, respectively. These methods are used in the same
way that `precede_with` is used; define the callback above the target controller
action, and they get executed just like you'd expect!

Here are some examples:

```ruby
class PostsController < ApplicationController
  follow_with :after_create_action
  def create
    # create logic goes here
  end
  
  def after_create_action
    
  end
end
```

The above is pretty straightforward — the `after_create_action` is executed immediately
after the finishing of `create`.

```ruby
class PostsController < ApplicationController
  surround_with :log_exceptions
  def create
    # create logic goes here
  end
  
  def log_exceptions
    yield
  rescue => exception
    Rails.logger.error("Oh no, an exception was caught! That's not good.")
  end
end
```

This, for example, would log any errors that occurred within the controller action. You probably shouldn't
use this in favor of a better error handling approach though.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Coming Soon
* Support for `prepend_#{type}_action`

## Notes
This gem is only guaranteed to be compatible with Rails `~> 5.0`. Better
compatibility is coming soon.
