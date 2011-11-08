require 'spec_helper'

describe User do

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).with_maximum(30) }

    ['John Doe', 'john-doe', 'john_doe', 'john123', "John A'Doe"].each do |name|
      it { should validate_format_of(:name).to_allow(name) }
    end

    ['john!', '#john', 'johasf<', 'joh"doe"', "john\t"].each do |name|
      it { should validate_format_of(:name).not_to_allow(name) }
    end

    it { should validate_presence_of :password }
    it { should validate_length_of(:password) }
    it { should validate_confirmation_of(:password) }

    it 'should not validate password for omniauth only accounts' do
      usr = Factory(:user, :password => nil, :authentications => [Authentication.new])
      usr.should be_valid
    end

    it 'should not be valid for user without password' do
      usr = User.new(:password => nil, :authentications => [])
      usr.should_not be_valid
    end

  end

end
