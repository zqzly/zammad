# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Controllers::WebhooksControllerPolicy < Controllers::ApplicationControllerPolicy
  default_permit!('admin.webhook')
end