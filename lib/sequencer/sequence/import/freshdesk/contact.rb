# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Sequencer
  class Sequence
    module Import
      module Freshdesk
        class Contact < Sequencer::Sequence::Base

          def self.sequence
            [
              'Common::ModelClass::User',
              'Import::Freshdesk::Contact::Mapping',
              'Import::Freshdesk::Mapping::CustomFields',
              'Import::Common::Model::Attributes::AddByIds',
              'Import::Common::Model::FindBy::UserAttributes',
              'Import::Common::Model::Update',
              'Import::Common::Model::Create',
              'Import::Common::Model::Save',
              'Import::Freshdesk::MapId',
              'Import::Common::Model::Statistics::Diff::ModelKey',
              'Import::Common::ImportJob::Statistics::Update',
              'Import::Common::ImportJob::Statistics::Store',
            ]
          end
        end
      end
    end
  end
end
