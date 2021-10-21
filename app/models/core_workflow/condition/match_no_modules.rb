# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class CoreWorkflow::Condition::MatchNoModules < CoreWorkflow::Condition::Backend
  def match
    result = true
    value.each do |_current_value|
      condition_value.each do |current_condition_value|
        custom_module = current_condition_value.constantize.new(condition_object: @condition_object, result_object: @result_object)

        check = custom_module.send(:"#{@condition_object.check}_attribute_match?")
        next if !check

        result = false

        break
      end
    end
    result
  end
end
