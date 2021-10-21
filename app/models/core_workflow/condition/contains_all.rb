# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class CoreWorkflow::Condition::ContainsAll < CoreWorkflow::Condition::Backend
  def match
    result = false
    value.each do |current_value|
      current_match = 0
      condition_value.each do |current_condition_value|
        next if current_condition_value.exclude?(current_value)

        current_match += 1
      end

      next if current_match != condition_value.count

      result = true

      break
    end
    result
  end
end
