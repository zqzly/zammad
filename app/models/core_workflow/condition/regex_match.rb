# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class CoreWorkflow::Condition::RegexMatch < CoreWorkflow::Condition::Backend
  def match
    result = false
    value.each do |current_value|
      current_match = false
      condition_value.each do |current_condition_value|
        next if !%r{#{current_condition_value}}.match?(current_value)

        current_match = true

        break
      end

      next if !current_match

      result = true

      break
    end
    result
  end
end
