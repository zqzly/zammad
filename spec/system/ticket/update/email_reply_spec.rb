# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

require 'rails_helper'

RSpec.describe 'Ticket > Update > Email Reply', current_user_id: -> { current_user.id }, type: :system, time_zone: 'Europe/London' do
  let(:group) { Group.find_by(name: 'Users') }
  let(:ticket) { create(:ticket, group: group) }
  let(:ticket_article) { create(:ticket_article, ticket: ticket, from: 'Example Name <asdf1@example.com>') }
  let(:customer) { create(:customer) }
  let(:current_user) { customer }

  before do
    visit "ticket/zoom/#{ticket_article.ticket.id}"
  end

  context 'when TO field is being edited' do

    it 'shows error dialog when updated value is an invalid email' do
      within(:active_content) do
        click_reply

        find('.token').double_click
        find('.js-to', visible: false).sibling('.token-input').set('test')
        find('.js-textarea').set('welcome to the community')
        find('.js-submitDropdown button.js-submit').click

        expect(page).to have_text 'Need recipient in "To" or "Cc".'
      end
    end

    it 'updates article when updated value is a valid email' do
      within(:active_content) do
        click_reply

        find('.token').double_click
        find('.js-to', visible: false).sibling('.token-input').set('user@test.com')
        find('.js-textarea').set('welcome to the community')
        find('.js-submitDropdown button.js-submit').click

        expect(page).to have_text 'welcome to the community'
      end
    end

  end

  def click_reply
    click '.js-ArticleAction[data-type=emailReply]'
  end

end
