FactoryGirl.define do

  factory :user do
    sequence(:name) { |i| "John Doe #{i}" }
    sequence(:email) { |i| "john#{i}@example.com" }
    password '123456'
  end

  factory :omniauth_identity do
    provider 'google'
    uid do |identity|
      OmniAuth.config.mock_auth.fetch(identity.provider.to_sym, { 'uid' => "123456" })['uid']
    end
  end

  factory :user_with_omniauth_identity, :parent => :user do |user|
    omniauth_identities [Factory.build(:omniauth_identity)]
    password nil
  end

  factory :user_with_languages, :parent => :user do |user|
    user.after_create { |u| u.languages = [Factory(:language), Factory(:language)] }
  end

end

Factory.define :task do; end

FactoryGirl.define do

  factory :language do |lang|
    sequence(:name) { |n| "Language #{n}" }
    sequence(:id) { |n| "lang_#{n}" }
    lang.after_create { |l| 2.times { Factory(:task, language: l) } }
  end

end
