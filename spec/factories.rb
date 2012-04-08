FactoryGirl.define do

  factory :user do
    sequence(:name) { |i| "John Doe #{i}" }
    sequence(:email) { |i| "john#{i}@example.com" }
    location 'Minsk, Belarus'
    about 'Poor factory user...'
    password '123456'
  end

  factory :omniauth_identity do
    provider 'google'
    uid do |identity|
      OmniAuth.config.mock_auth.fetch(identity.provider.to_sym, { 'uid' => "123456" })['uid']
    end
  end

  factory :user_with_omniauth_identity, :parent => :user do
    omniauth_identities [FactoryGirl.build(:omniauth_identity)]
    password nil
  end

  factory :user_with_languages, :parent => :user do |user|
    user.after_create { |u| u.languages = [Factory(:language), Factory(:language)] }
  end

  factory :task do
    sequence(:position) { |n| n }
    sequence(:name) { |n| "Task no #{n}" }
    sequence(:slug) { |n| "task_#{n}" }
    description "*Description*  \n\n    print(hello)\n    print(world)"
    award 10
  end

  factory :language do |lang|
    sequence(:name) { |n| "Language #{n}" }
    sequence(:id) { |n| "lang_#{n}" }
    description 'Description and some interesting facts about language.'
    code_example 'print "Hello, world"'
    links { |l| ["example.org/wiki/#{l.name}", "example.org/languages/#{l.name.parameterize}", "escaped.org/C%2B%2B"] }
    lang.after_create { |l| 2.times { Factory(:task, language: l) } }
  end

end
