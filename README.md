# HasCounterOn

ActiveRecord `counter_cache` has been reborn, with ability to specify conditions. Inspired by [counter_cache_with_conditions](https://github.com/skojin/counter_cache_with_conditions) gem.

## Installation

To use it, add it to your Gemfile:

```ruby
gem 'has_counter_on'
```

and bundle:

```
$ bundle install
```

### After Installation

Install migrations

```
rake has_counter_on:setup
```

Review the generated migrations then migrate:

```
rake db:migrate
```

## Usage

Let's say you have a User model and an Article model.

```ruby
class User < ActiveRecord::Base
  has_many :articles
  has_many :published_articles, -> { where(has_published: true) }, class_name: :Article
end

class Article < ActiveRecord::Base
  belongs_to :user
end
```

By using ActiveRecord's `counter_cache`, articles_count can be created as follows: (However, you cannot handle `published_articles_count`)

```ruby
class User < ActiveRecord::Base
  has_many :articles
  has_many :published_articles, -> { where(has_published: true) }, class_name: :Article
end

class Article < ActiveRecord::Base
  belongs_to :user, counter_cache: true
end
```

**with has_counter_on**, you can handle both of counters like this:

```ruby
class User < ActiveRecord::Base
  has_many :articles
  has_many :published_articles, -> { where(has_published: true) }, class_name: :Article

  has_counter_on :articles
  has_counter_on :articles, :published_articles_count, has_published: true
end

class Article < ActiveRecord::Base
  belongs_to :user
end
```

Each counter will be updated automatically like that of the ActiveRecord.

### Complex Conditions

Complex conditions can be expressed as lambda.

```ruby
class User < ActiveRecord::Base
  has_many :articles
  has_many :published_articles, -> { where.not(published_at: nil) }, class_name: :Article

  has_counter_on :articles
  has_counter_on :articles, :published_articles_count, published_at: -> (value) { value.present? }
end

class Article < ActiveRecord::Base
  belongs_to :user
end
```

Of course, multiple conditions are available.

```ruby
class User < ActiveRecord::Base
  has_counter_on :articles, :featured_articles_count, has_featured: true, has_published: true
end
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/mu29/has_counter_on).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
