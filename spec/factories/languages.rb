FactoryGirl.define do

  factory :language do |lang|
    sequence(:name) { |n| "Language #{n}" }
    sequence(:id) { |n| "lang_#{n}" }
    lang.after_create { |l| 2.times { Factory(:task, language: l) } }
  end
end
