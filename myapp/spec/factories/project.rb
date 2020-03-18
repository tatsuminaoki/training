FactoryBot.define do
  factory :project do
    name { 'test project' }

    trait :with_group do
      after(:create) do |project|
        FactoryBot.create(:group, project: project)
      end
    end
  end
end
