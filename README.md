Ruby Features
=============
[![Version](https://badge.fury.io/rb/ruby-features.svg)](http://badge.fury.io/rb/ruby-features)
[![Build](https://travis-ci.org/stokarenko/ruby-features.svg?branch=master)](https://travis-ci.org/stokarenko/ruby-features)
[![Climate](https://codeclimate.com/github/stokarenko/ruby-features/badges/gpa.svg)](https://codeclimate.com/github/stokarenko/ruby-features)
[![Coverage](https://codeclimate.com/github/stokarenko/ruby-features/badges/coverage.svg)](https://codeclimate.com/github/stokarenko/ruby-features/coverage)

Ruby Features allow the extending of Ruby classes and modules to become easy, safe and controlled.

## Why?
Lets ask, is that good to write the code like this:
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

The matter is in motivation to write such things. Lets skip the well-known reasons like
> Because I can! That is Ruby baby, lets make some anarchy!

but say:
> I want to implement the functionality, which I expected to find right in the box.

In fact, the cool things can be injected right in core programming entities in this way.
They are able to improve the development speed, to make the sources to be more readable and light.

From the other side, the project's behavior loses the predictability once it requires the third-party
library, infected by massive patches to core entities.

Ruby Features goal is to take that under control.

The main features are:
* No dependencies;
* Built-in lazy load;
* Supports ActiveSupport lazy load as well;
* Stimulates the clear extending, but prevents monkey patching;
* Gives the control what core extensions to apply;
* Gives the understading who and how exactly affected to programming entities.

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
Feature file name should end with `_feature.rb`.

Lets define the feature in `lib/features/something_useful_feature.rb`:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  apply_to 'ActiveRecord::Base' do

    applied do
      # will be evaluated on target class
      attr_accessor :useful_variable
    end

    rewrite_instance_methods do
      # rewrite instance methods
      # call `super` to reach the rewritten method
      def existing_instance_method
        # some code before super
        super
        # some code after super
      end
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
  end

  apply_to 'ActiveRecord::Relation' do
    # feature can contain several apply_to definition
  end

end
```

### Dependencies
The dependencies on other Ruby Features can be defined like:
```ruby
RubyFeatures.define 'main_feature' do
  dependency 'dependent_feature1'
  dependencies 'dependent_feature2', 'dependent_feature3'
end
```

### Conditions
Sometimes it`s required to apply different things, depending on some criteria:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  apply_to 'ActiveRecord::Base' do

    class_methods do
      if ActiveRecord::VERSION::MAJOR > 3
        def useful_method
          # Implementation for newest ActiveRecord
        end
      else
        def useful_method
          # Implementation for ActiveRecord 3
        end
      end
    end
  end
end
```

It's bad to do like that, because the mixin applied by Ruby Features became to be not static.
That causes unpredictable behavior.

Ruby Features provides the `conditions` mechanism to avoid such problem:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  condition(:newest_activerecord){ ActiveRecord::VERSION::MAJOR > 3 }

  apply_to 'ActiveRecord::Base' do

    class_methods if: :newest_activerecord do
      def useful_method
        # Implementation for newest ActiveRecord
      end
    end

    class_methods unless: :newest_activerecord do
      def useful_method
        # Implementation for ActiveRecord 3
      end
    end

  end
end
```

All DSL methods support the conditions:
```ruby
apply_to 'ActiveRecord::Base', if: :first_criteria do; end

applied if: :second_criteria do; end

class_methods if: :third_criteria do; end

instance_methods if: :fourth_criteria do; end
```

It's possible to define not boolean condition:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  condition(:activerecord_version){ ActiveRecord::VERSION::MAJOR }

  apply_to 'ActiveRecord::Base' do

    class_methods unless: {activerecord_version: 3} do
      def useful_method
        # Implementation for newest ActiveRecord
      end
    end

    class_methods if: {activerecord_version: 3} do
      def useful_method
        # Implementation for ActiveRecord 3
      end
    end

  end
end
```

It's possible to combine the conditions:
```ruby
class_methods {
  if: [
    :boolean_condition,
    :other_boolean_condition,
    {
      string_condition: 'some_string',
      symbol_condition: :some_symbol
    }
  ],
  unless: :unless_boolean_condition
} do; end
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
Feature can be applied immediately after its definition:
```ruby
RubyFeatures.define 'some_namespace/something_useful' do
  # definition
end.apply
```

Features can be applied immediately after loading from path:
```ruby
RubyFeatures.find_in_path(File.expand_path('../lib/features', __FILE__)).apply_all
```

Feature can be applied by name, if such feature is already loaded:
```ruby
require `lib/features/something_useful_feature`

RubyFeatures.apply 'some_namespace/something_useful'
```

## Changes
### v1.2.0
* Added rewrite_instance_methods.

### v1.1.0
* Added conditions.
* Added dependencies.

## License
MIT License. Copyright (c) 2015 Sergey Tokarenko
