# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Sequencer
  class Unit
    module Import
      module Zendesk
        module User
          class CustomFields < Sequencer::Unit::Import::Zendesk::Common::CustomFields

            private

            def remote_fields
              resource.user_fields
            end
          end
        end
      end
    end
  end
end
