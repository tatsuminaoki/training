FactoryBot.define do
  factory :project do
    name { 'test project' }

    trait :with_group do
      after(:create) do |project|
        FactoryBot.create(:group, project: project)
      end
    end

    trait :with_label do
      after(:create) do |project|
        FactoryBot.create(:label, project: project)
      end
    end

    trait :with_group_and_label do
      after(:create) do |project|
        FactoryBot.create(:group, project: project)
        FactoryBot.create(:label, project: project)
      end
    end
  end
end
