FactoryBot.define do
  factory :user do
    email    { FFaker::Internet.unique.email }
    password { FFaker::Internet.password }
  end
end
