# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Sequencer
  class Sequence
    module Import
      module Zendesk
        class Ticket < Sequencer::Sequence::Base
          class Comment < Sequencer::Sequence::Base

            def self.sequence
              [
                'Import::Zendesk::Ticket::Comment::UserId',
                'Import::Zendesk::Common::ArticleSenderId',
                'Import::Zendesk::Common::ArticleTypeId',
                'Import::Zendesk::Ticket::Comment::From',
                'Import::Zendesk::Ticket::Comment::To',
                'Import::Zendesk::Ticket::Comment::Mapping',
                'Import::Zendesk::Ticket::Comment::UnsetInstance',
                'Common::ModelClass::Ticket::Article',
                'Import::Common::Model::FindBy::MessageId',
                'Import::Common::Model::Update',
                'Import::Common::Model::Create',
                'Import::Common::Model::Save',
                'Import::Zendesk::Ticket::Comment::Attachments',
              ]
            end
          end
        end
      end
    end
  end
end
