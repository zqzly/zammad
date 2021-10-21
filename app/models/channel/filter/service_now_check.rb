# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Channel::Filter::ServiceNowCheck < Channel::Filter::BaseExternalCheck
  MAIL_HEADER        = 'x-servicenow-generated'.freeze
  SOURCE_ID_REGEX    = %r{\s(INC\d+)\s}.freeze
  SOURCE_NAME_PREFIX = 'ServiceNow'.freeze
end
