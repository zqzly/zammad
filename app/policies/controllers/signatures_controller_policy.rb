# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Controllers::SignaturesControllerPolicy < Controllers::ApplicationControllerPolicy
  permit! %i[index show], to: ['ticket.agent', 'admin.channel_email', 'admin.channel_google', 'admin.channel_microsoft365']
  permit! %i[create update destroy], to: ['admin.channel_email', 'admin.channel_google', 'admin.channel_microsoft365']
end
