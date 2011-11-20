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
  end

end
