# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class CoreWorkflow::Condition::NotSet < CoreWorkflow::Condition::Backend
  def match
    return true if value.blank?
    return true if value == ['']
    return true if object?(Ticket) && @key == 'ticket.owner_id' && value == ['1']

    false
  end
end
