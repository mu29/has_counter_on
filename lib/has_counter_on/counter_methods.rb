module HasCounterOn
  module CounterMethods
    private

    def has_counter_on_after_create
      self.has_counter_on_options.each do |get_counter, foreign_key, conditions|
        next unless satisfy_present?(conditions: conditions)

        association_id = send(foreign_key)
        counter = get_counter.call(id: association_id)

        counter.increment!(:value)
      end
    end

    def has_counter_on_before_update
      self.has_counter_on_options.each do |get_counter, foreign_key, conditions|
        if satisfy_present?(conditions: conditions)
          before, after = send("#{foreign_key}_change")

          if before != after
            get_counter.call(id: before).decrement!(:value)
            get_counter.call(id: after).increment!(:value)

            next
          end
        end

        before = satisfy_before?(conditions: conditions)
        after = satisfy_after?(conditions: conditions)

        next if before == after

        association_id = send(foreign_key)
        counter = get_counter.call(id: association_id)

        if before
          counter.decrement!(:value)
        elsif after
          counter.increment!(:value)
        end
      end
    end

    def has_counter_on_before_destroy
      self.has_counter_on_options.each do |klass, foreign_key, counter_name, conditions|
        next unless satisfy_present?(conditions: conditions)

        association_id = send(foreign_key)
        counter = get_counter.call(id: association_id)
        
        counter.decrement!(:value)
      end
    end

    def satisfy_before?(conditions:)
      conditions.each.all? do |attr, value|
        if value.is_a? Proc
          send("#{attr}_changed?") && value.call(attribute_was(attr))
        else
          send("#{attr}_changed?", from: value)
        end
      end
    end

    def satisfy_present?(conditions:)
      conditions.each.all? do |attr, value|
        if value.is_a? Proc
          value.call(send(attr))
        else
          send(attr) == value
        end
      end
    end

    def satisfy_after?(conditions:)
      conditions.each.all? do |attr, value|
        if value.is_a? Proc
          send("#{attr}_changed?") && value.call(send(attr))
        else
          send("#{attr}_changed?", to: value)
        end
      end
    end
  end
end
