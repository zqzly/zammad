# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Controllers::DataPrivacyTasksControllerPolicy < Controllers::ApplicationControllerPolicy
  default_permit!('admin.data_privacy')
end
