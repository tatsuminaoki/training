FactoryBot.define do
  factory :task do
    name { "MyString" }
    tag_list { 'tag' }
    user
    status { 0 }
    description { "MyText" }
    due_date { Date.current }
  end
end
