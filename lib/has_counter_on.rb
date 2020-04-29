require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'

module HasCounterOn
  extend ActiveSupport::Autoload

  autoload :Countable
  autoload :CounterMethods
  autoload :Counter
  autoload :VERSION
end

ActiveSupport.on_load(:active_record) do
  extend HasCounterOn::Countable
end
