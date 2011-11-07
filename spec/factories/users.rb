# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    name 'John Doe'
    email 'john@gmail.com'
    password '123456'
  end

end
