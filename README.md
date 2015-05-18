Ruby Features
=============
[![Version](https://badge.fury.io/rb/ruby-features.svg)](http://badge.fury.io/rb/ruby-features)
[![Build](https://travis-ci.org/stokarenko/ruby-features.svg?branch=master)](https://travis-ci.org/stokarenko/ruby-features)
[![Climate](https://codeclimate.com/github/stokarenko/ruby-features/badges/gpa.svg)](https://codeclimate.com/github/stokarenko/ruby-features)
[![Coverage](https://codeclimate.com/github/stokarenko/ruby-features/badges/coverage.svg)](https://codeclimate.com/github/stokarenko/ruby-features/coverage)

Ruby Features makes the extending of Ruby classes and modules to be easy, safe and controlled.

## Why?
Lets ask, is good to write the code like this:
```ruby
String.send :include, MyStringExtension
```

Or even like this:
```ruby
Object.class_eval do
  def my_object_method
    # some super code
  end
end
```

The question is about motivation to write such things. Lets skip well-known reason like
> Because I can! That is Ruby baby, lets make some anarchy!

but say:
> I want to implement the functionality, which I expected to find right in the box.

In fact, the cool things can be injected right in core programming entities in this way.
They are able to improve the development speed, to make the sources to be more readable and light.

From the other side, the project's behavior loses the predictability once it requires the third-party
library, infected by massive patches to core entities.

Ruby Features goal is to take that under control.

The main features are:
* No any dependencies;
* Built-in lazy load;
* Supports ActiveSupport lazy load as well;
* Stimulates the clear extending, but prevents monkey patching;
* Gives the control what core extensions to apply;
* Any moment gives the knowledge who and how exactly affected to programming entities.

## requirements
* Ruby >= 1.9.3

## Getting started

Add to your Gemfile:

```ruby
gem 'ruby-features'
```

Run the bundle command to install it.

For Rails projects, gun generator:
```console
rails generate ruby_features:install
```

Generator will add `ruby-features.rb` initializer, which loads the ruby features
from `{Rails.root}/lib/features` folder. Also such initializer is a good place
to apply third-party features.

## Usage
### Feature definition
Feature file name should ends with `_feature.rb`.

Lets define the feature in `lib/features/something_useful_feature.rb`:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  apply_to 'ActiveRecord::Base' do

    applied do
      # will be evaluated on target class
      attr_accessor :useful_variable
    end

    instance_methods do
      # instance methods
      def useful_instance_method
      end
    end

    class_methods do
      # class methods
      def useful_class_method
      end
    end

    apply_to 'ActiveRecord::Relation' do
      # feature can contain several apply_to definition
    end

  end
end
```

### Feature loading
Feature can be loaded by normal `require` call:
```ruby
require `lib/features/something_useful_feature`
```

All features within path can be loaded as follows:
```ruby
# require all "*_feature.rb" files within path, recursively:
RubyFeatures.find_in_path(File.expand_path('../lib/features', __FILE__))
```

### Feature applying
Feature can be applied immediately after it's definition:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  # definition
end.apply
```

Features can be applied right after loading from path:
```ruby
RubyFeatures.find_in_path(File.expand_path('../lib/features', __FILE__)).apply_all
```

Feature can be applied by name, if such feature is already loaded:
```ruby
require `lib/features/something_useful_feature`

RubyFeatures.apply 'some_namespace/something_useful'
```

## License
MIT License. Copyright (c) 2015 Sergey Tokarenko
