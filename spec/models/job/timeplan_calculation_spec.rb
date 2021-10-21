# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

require 'rails_helper'

RSpec.describe Job::TimeplanCalculation do
  subject(:instance) { described_class.new(timeplan) }

  describe '#contains?' do
    context 'without a valid timeplan' do
      let(:timeplan) { {} }

      it { is_expected.not_to be_contains(Time.zone.now) }
    end

    context 'with monday 09:20' do
      let(:timeplan) { { 'days' => { 'Mon' => true }, 'hours' => { '9' => true }, 'minutes' => { '20' => true } } }

      it { is_expected.to be_contains(Time.zone.parse('2020-12-28 09:20')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-21 09:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-21 10:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-21 9:10')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-22 9:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-20 9:20')) }
    end

    context 'with monday and tuesday 09:20' do
      let(:timeplan) { { 'days' => { 'Mon' => true, 'Tue' => true }, 'hours' => { '9' => true }, 'minutes' => { '20' => true } } }

      it { is_expected.to be_contains(Time.zone.parse('2020-12-28 09:20')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-21 09:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-21 10:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-21 9:10')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-22 9:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-20 9:20')) }
    end

    context 'with monday 09:20 and 10:20' do
      let(:timeplan) { { 'days' => { 'Mon' => true }, 'hours' => { '9' => true, '10' => true }, 'minutes' => { '20' => true } } }

      it { is_expected.to be_contains(Time.zone.parse('2020-12-28 09:20')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-21 09:20')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-21 10:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-21 9:10')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-22 9:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-20 9:20')) }
    end

    context 'with monday 09:20 and 9:10' do
      let(:timeplan) { { 'days' => { 'Mon' => true }, 'hours' => { '9' => true }, 'minutes' => { '20' => true, '10' => true } } }

      it { is_expected.to be_contains(Time.zone.parse('2020-12-28 09:20')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-21 09:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-21 10:20')) }
      it { is_expected.to be_contains(Time.zone.parse('2020-12-21 9:10')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-22 9:20')) }
      it { is_expected.not_to be_contains(Time.zone.parse('2020-12-20 9:20')) }
    end
  end

  describe 'next_at?' do
    context 'without a valid timeplan' do
      let(:timeplan) { {} }

      it { expect(instance.next_at(Time.zone.now)).to be_nil }
    end

    context 'with monday 09:20' do
      let(:timeplan) { { 'days' => { 'Mon' => true }, 'hours' => { '9' => true }, 'minutes' => { '20' => true } } }

      it { expect(instance.next_at(Time.zone.parse('2020-12-28 09:31'))).to eq(Time.zone.parse('2021-01-04 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-28 09:30'))).to eq(Time.zone.parse('2021-01-04 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-28 09:20'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:21'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:35'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:20'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:21'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 9:10'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-22 9:20'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-20 9:20'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
    end

    context 'with monday and tuesday 09:20' do
      let(:timeplan) { { 'days' => { 'Mon' => true, 'Tue' => true }, 'hours' => { '9' => true }, 'minutes' => { '20' => true } } }

      it { expect(instance.next_at(Time.zone.parse('2020-12-28 09:30'))).to eq(Time.zone.parse('2020-12-29 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-29 09:30'))).to eq(Time.zone.parse('2021-01-04 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:25'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:35'))).to eq(Time.zone.parse('2020-12-22 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:20'))).to eq(Time.zone.parse('2020-12-22 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:21'))).to eq(Time.zone.parse('2020-12-22 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 9:10'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-22 9:30'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-20 9:20'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
    end

    context 'with monday 09:20 and 10:20' do
      let(:timeplan) { { 'days' => { 'Mon' => true }, 'hours' => { '9' => true, '10' => true }, 'minutes' => { '20' => true } } }

      it { expect(instance.next_at(Time.zone.parse('2020-12-28 09:30'))).to eq(Time.zone.parse('2020-12-28 10:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:30'))).to eq(Time.zone.parse('2020-12-21 10:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:35'))).to eq(Time.zone.parse('2020-12-21 10:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 08:07'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:30'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:31'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 9:10'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 9:47'))).to eq(Time.zone.parse('2020-12-21 10:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-22 9:20'))).to eq(Time.zone.parse('2020-12-28 09:20')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-20 9:30'))).to eq(Time.zone.parse('2020-12-21 09:20')) }
    end

    context 'with monday 09:30 and 9:10' do
      let(:timeplan) { { 'days' => { 'Mon' => true }, 'hours' => { '9' => true }, 'minutes' => { '30' => true, '10' => true } } }

      it { expect(instance.next_at(Time.zone.parse('2020-12-28 09:40'))).to eq(Time.zone.parse('2021-01-04 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:40'))).to eq(Time.zone.parse('2020-12-28 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:30'))).to eq(Time.zone.parse('2020-12-21 09:30')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:25'))).to eq(Time.zone.parse('2020-12-21 09:30')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:35'))).to eq(Time.zone.parse('2020-12-21 09:30')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 09:45'))).to eq(Time.zone.parse('2020-12-28 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 08:07'))).to eq(Time.zone.parse('2020-12-21 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:20'))).to eq(Time.zone.parse('2020-12-28 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 10:21'))).to eq(Time.zone.parse('2020-12-28 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 9:10'))).to eq(Time.zone.parse('2020-12-21 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-21 9:20'))).to eq(Time.zone.parse('2020-12-21 09:30')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-22 9:20'))).to eq(Time.zone.parse('2020-12-28 09:10')) }
      it { expect(instance.next_at(Time.zone.parse('2020-12-20 9:20'))).to eq(Time.zone.parse('2020-12-21 09:10')) }
    end
  end

  describe 'legacy tests moved from Job model' do
    let(:job)      { create(:job, :never_on) }
    let(:timeplan) { job.timeplan }
    let(:time)     { Time.current }

    context 'when the current day, hour, and minute all match true values in #timeplan' do
      it 'for Symbol/Integer keys returns true' do
        timeplan[:days].transform_keys!(&:to_sym)[time.strftime('%a').to_sym] = true
        timeplan[:hours].transform_keys!(&:to_i)[time.hour] = true
        timeplan[:minutes].transform_keys!(&:to_i)[time.min.floor(-1)] = true

        expect(instance.contains?(time)).to be(true)
      end

      it 'for String keys returns true' do
        timeplan[:days].transform_keys!(&:to_s)[time.strftime('%a')] = true
        timeplan[:hours].transform_keys!(&:to_s)[time.hour.to_s] = true
        timeplan[:minutes].transform_keys!(&:to_s)[time.min.floor(-1).to_s] = true

        expect(instance.contains?(time)).to be(true)
      end
    end

    context 'when the current day does not match a true value in #timeplan' do
      it 'for Symbol/Integer keys returns false' do
        timeplan[:days].transform_keys!(&:to_sym).transform_values! { true }[time.strftime('%a').to_sym] = false
        timeplan[:hours].transform_keys!(&:to_i)[time.hour] = true
        timeplan[:minutes].transform_keys!(&:to_i)[time.min.floor(-1)] = true

        expect(instance.contains?(time)).to be(false)
      end

      it 'for String keys returns false' do
        timeplan[:days].transform_keys!(&:to_s).transform_values! { true }[time.strftime('%a')] = false
        timeplan[:hours].transform_keys!(&:to_s)[time.hour.to_s] = true
        timeplan[:minutes].transform_keys!(&:to_s)[time.min.floor(-1).to_s] = true

        expect(instance.contains?(time)).to be(false)
      end
    end

    context 'when the current hour does not match a true value in #timeplan' do
      it 'for Symbol/Integer keys returns false' do
        timeplan[:days].transform_keys!(&:to_sym)[time.strftime('%a').to_sym] = true
        timeplan[:hours].transform_keys!(&:to_i).transform_values! { true }[time.hour] = false
        timeplan[:minutes].transform_keys!(&:to_i)[time.min.floor(-1)] = true

        expect(instance.contains?(time)).to be(false)
      end

      it 'for String keys returns false' do
        timeplan[:days].transform_keys!(&:to_s)[time.strftime('%a')] = true
        timeplan[:hours].transform_keys!(&:to_s).transform_values! { true }[time.hour.to_s] = false
        timeplan[:minutes].transform_keys!(&:to_s)[time.min.floor(-1).to_s] = true

        expect(instance.contains?(time)).to be(false)
      end
    end

    context 'when the current minute does not match a true value in #timeplan' do
      it 'for Symbol/Integer keys returns false' do
        timeplan[:days].transform_keys!(&:to_sym)[time.strftime('%a').to_sym] = true
        timeplan[:hours].transform_keys!(&:to_i)[time.hour] = true
        timeplan[:minutes].transform_keys!(&:to_i).transform_values! { true }[time.min.floor(-1)] = false

        expect(instance.contains?(time)).to be(false)
      end

      it 'for String keys returns false' do
        timeplan[:days].transform_keys!(&:to_s)[time.strftime('%a')] = true
        timeplan[:hours].transform_keys!(&:to_s)[time.hour.to_s] = true
        timeplan[:minutes].transform_keys!(&:to_s).transform_values! { true }[time.min.floor(-1).to_s] = false

        expect(instance.contains?(time)).to be(false)
      end
    end
  end
end
