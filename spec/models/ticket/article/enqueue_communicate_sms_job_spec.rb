# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

require 'rails_helper'

RSpec.describe Ticket::Article::EnqueueCommunicateSmsJob, performs_jobs: true do
  before { allow(Delayed::Job).to receive(:enqueue).and_call_original }

  let(:article) { create(:ticket_article, **(try(:factory_options) || {})) }

  shared_examples 'for no-op' do
    it 'is a no-op' do
      expect { article }.not_to have_enqueued_job(CommunicateSmsJob)
    end
  end

  shared_examples 'for success' do
    it 'enqueues the SMS background job' do
      expect { article }.to have_enqueued_job(CommunicateSmsJob)
    end
  end

  context 'when in Import Mode' do
    before { Setting.set('import_mode', true) }

    include_examples 'for no-op'
  end

  context 'when article is created during Channel::EmailParser#process', application_handle: 'scheduler.postmaster' do
    include_examples 'for no-op'
  end

  context 'when article is from a customer' do
    let(:factory_options) { { sender_name: 'Customer' } }

    include_examples 'for no-op'
  end

  context 'when article is an sms' do
    let(:factory_options) { { sender_name: 'Agent', type_name: 'sms' } }

    include_examples 'for success'
  end
end
