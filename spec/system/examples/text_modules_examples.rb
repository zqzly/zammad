# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

RSpec.shared_examples 'text modules' do |path:|
  let!(:agent_fixed_name)          { create :agent, firstname: 'FFFF1', lastname: 'GGGG1', groups: [Group.find_by(name: 'Users')] }
  let!(:group1)                    { create :group }
  let!(:group2)                    { create :group }
  let!(:text_module_without_group) { create :text_module }
  let!(:text_module_group1)        { create :text_module, groups: [group1] }
  let!(:text_module_group2)        { create :text_module, groups: [group2] }

  it 'shows when send ::' do
    refresh # workaround to get new created objects from db
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select(1)
      find(:richtext).send_keys(':')
      find(:richtext).send_keys(':')
      expect(page).to have_selector(:text_module, text_module_without_group.id)
    end
  end

  it 'does not break after usage of Ctrl/Command+Backspace' do
    visit path
    within(:active_content) do
      find(:richtext).send_keys(':')
      find(:richtext).send_keys(':')
      find(:richtext).send_keys('bur')

      # The click is needed to get the focus back to the field for chrome.
      find(:richtext).click
      if Gem::Platform.local.os.eql? 'darwin'
        find(:richtext).send_keys(%i[command backspace])
      else
        find(:richtext).send_keys(%i[control backspace])
      end

      find(:richtext).send_keys('Some other text')
      find(:richtext).send_keys(:enter)
      expect(find(:richtext)).to have_text 'Some other text'
    end
  end

  it 'does not show when send :enter:' do
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select(1)
      find(:richtext).send_keys(':')
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(':')
      expect(page).to have_no_selector(:text_module, text_module_without_group.id)
    end
  end

  it 'does not break search on backspace' do
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select(1)
      find(:richtext).send_keys('@@agen')
      find(:richtext).send_keys(:backspace)
      expect(page).to have_no_text('No results found')
    end
  end

  it 'does delete empty mentions (issue #3636 / FF only)' do
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select('Users')
      find(:richtext).send_keys('@@FFFF1')
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(:enter)
      (agent_fixed_name.firstname.length + agent_fixed_name.lastname.length + 2).times do
        find(:richtext).send_keys(:backspace)
      end
      expect(find(:richtext).all('a[data-mention-user-id]', visible: :all).count).to eq(0)
    end
  end

  it 'does delete empty mentions (issue #3636 / simulation)' do
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select('Users')
      find(:richtext).send_keys('@@FFFF1')
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys('test')
      page.execute_script("$('a[data-mention-user-id]').first().html('<br>')")
      find(:richtext).send_keys(:backspace)
      expect(find(:richtext).all('a[data-mention-user-id]', visible: :all).count).to eq(0)
    end
  end

  it 'does not delete parts of the text on multiple mentions (issue #3717)' do
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select('Users')
      find(:richtext).send_keys('Testing Testy')
      find(:richtext).send_keys('@@FFFF1')
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys('Testing Testy ')
      find(:richtext).send_keys('@@FFFF1')
      find(:richtext).send_keys(:enter)

      expect(find(:richtext).text).to include('Testing TestyFFFF1 GGGG1')
      expect(find(:richtext).text).to include('Testing Testy FFFF1 GGGG1')
    end
  end

  it 'does not delete line breaks of text with mentions (issue #3717)' do
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select('Users')
      find(:richtext).send_keys('@@FFFF1')
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(' Testing Testy')
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(:enter)
      find(:richtext).send_keys(:backspace)
      find(:richtext).send_keys('@@FFFF1')
      find(:richtext).send_keys(:enter)
      expect(find(:richtext).text).to include("FFFF1 GGGG1 Testing Testy\nFFFF1 GGGG1")
    end
  end

  it 'supports group-dependent text modules' do

    # give user access to all groups including those created
    # by using FactoryBot outside of the example
    group_names_access_map = Group.all.pluck(:name).index_with do |_group_name|
      'full'.freeze
    end

    current_user do |user|
      user.group_names_access_map = group_names_access_map
      user.save!
    end

    refresh # workaround to get changed settings from db
    visit path
    within(:active_content) do
      find('select[name="group_id"]').select(group1.name)
      find(:richtext).send_keys('::')

      expect(page).to have_selector(:text_module, text_module_without_group.id)
      expect(page).to have_selector(:text_module, text_module_group1.id)
      expect(page).to have_no_selector(:text_module, text_module_group2.id)

      find('select[name="group_id"]').select(group2.name)
      find(:richtext).send_keys('::')

      expect(page).to have_selector(:text_module, text_module_without_group.id)
      expect(page).to have_no_selector(:text_module, text_module_group1.id)
      expect(page).to have_selector(:text_module, text_module_group2.id)
    end
  end
end
