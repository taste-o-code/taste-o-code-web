FactoryGirl.define do

  factory :user do
    sequence(:name) { |i| "John Doe #{i}" }
    sequence(:email) { |i| "john#{i}@example.com" }
    password '123456'
  end

end
