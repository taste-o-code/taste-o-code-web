# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    name 'John Doe'
    sequence(:email) { |i| "john#{i}@example.com" }
    password '123456'
  end

end
