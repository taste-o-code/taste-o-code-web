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

  factory :user_with_omniauth_identity, :parent => :user do |user|
    user.before(:create) { |u| u.omniauth_identities = [build(:omniauth_identity)] }
    password nil
  end

  factory :user_with_languages, :parent => :user do |user|
    user.after(:create) { |u| u.languages = [create(:language), create(:language)] }
  end

  factory :task do
    sequence(:position) { |n| n }
    sequence(:name) { |n| "Task no #{n}" }
    sequence(:slug) { |n| "task_#{n}" }
    description "*Description*  \n\n    print(hello)\n    print(world)"
    template "Solution template"
    award 10
  end

  factory :language do |lang|
    sequence(:name) { |n| "Language #{n}" }
    sequence(:id) { |n| "lang_#{n}" }
    description 'Description and some interesting facts about language.'
    code_example 'print "Hello, world"'
    links { |l| ["example.org/wiki/#{l.name}", "example.org/languages/#{l.name.parameterize}", "escaped.org/C%2B%2B"] }
    lang.after(:create) { |l| 2.times { create(:task, language: l) } }
    version 'Version 1.2.3'
  end

  factory :comment do
    body 'Some body'
    task { Task.first || create(:task) }
    user { User.first || create(:user) }
  end

end
