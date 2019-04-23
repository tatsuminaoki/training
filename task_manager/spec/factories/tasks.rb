FactoryBot.define do
  factory :task do
    name { "MyString" }
    description { "MyText" }
    due_date { Date.current }
  end
end
