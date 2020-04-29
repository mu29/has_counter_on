module HasCounterOn
  class Counter < ActiveRecord::Base
    belongs_to :countable, polymorphic: true
  end
end
