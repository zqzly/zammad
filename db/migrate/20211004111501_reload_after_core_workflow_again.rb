# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class ReloadAfterCoreWorkflowAgain < ActiveRecord::Migration[6.0]
  def up

    # return if it's a new setup
    return if !Setting.exists?(name: 'system_init_done')

    AppVersion.set(true, 'app_version')
  end
end
