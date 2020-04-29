module HasCounterOn
  module Countable
    def has_counter_on(association_name, counter_name = nil, conditions = {})
      association = reflect_on_association(association_name)
      target = association.klass

      unless target.ancestors.include? HasCounterOn::CounterMethods
        target.include HasCounterOn::CounterMethods

        target.after_create :has_counter_on_after_create
        target.before_update :has_counter_on_before_update
        target.before_destroy :has_counter_on_before_destroy

        target.cattr_accessor :has_counter_on_options
        target.has_counter_on_options = [];
      end

      counter_name ||= "#{association.plural_name}_count".to_sym

      unless respond_to? counter_name
        has_many :counters, as: :countable, dependent: :destroy, class_name: '::HasCounterOn::Counter'

        define_method counter_name do
          counters.find_by(countable_name: counter_name)&.value or 0
        end
      end

      this = association.inverse_of
      target.has_counter_on_options << [
        -> (id:) {
          HasCounterOn::Counter.find_or_create_by(
            countable_type: this.klass,
            countable_id: id,
            countable_name: counter_name,
          )
        },
        this.foreign_key,
        conditions,
      ]
    end
  end
end
