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
    it { should validate_length_of(:password).with_minimum(6) }
    it { should validate_confirmation_of(:password) }

    it 'should not validate password for omniauth only accounts' do
      usr = Factory(:user, :password => nil, :omniauth_identities => [OmniauthIdentity.new])
      usr.should be_valid
    end

    it 'should not be valid for user without password' do
      usr = User.new(:password => nil, :authentications => [])
      usr.should_not be_valid
    end

    it { should validate_length_of(:location).with_maximum(100) }
    it { should validate_length_of(:about).with_maximum(1000) }
  end

  describe 'has_language method' do
    it 'should has language' do
      user = Factory(:user_with_languages)
      present_lang = user.languages.first
      user.has_language?(present_lang).should be_true
    end

    it 'should not has language' do
      user = Factory(:user_with_languages)
      non_present_lang = Factory(:language)
      user.has_language?(non_present_lang).should be_false
    end
  end

  describe 'buy_language method' do
    it 'should buy language' do
      user = Factory(:user_with_languages)
      price = user.available_points - 10
      lang = Factory(:language, price: price)
      user.buy_language(lang).should be_true
      user.reload
      user.available_points.should eq(10)
      user.has_language?(lang).should be_true
    end

    it 'should not buy repeated language' do
      user = Factory(:user_with_languages)
      points = user.available_points
      lang = user.languages.first
      lang.price = 0
      user.buy_language(lang).should be_false
      user.reload
      user.available_points.should eq(points)
      user.has_language?(lang).should be_true
    end

    it 'should not buy expensive language' do
      user = Factory(:user_with_languages)
      points = user.available_points
      lang = Factory(:language, price: points + 10)
      user.buy_language(lang).should be_false
      user.reload
      user.available_points.should eq(points)
      user.has_language?(lang).should be_false
    end
  end

  describe 'tasks methods' do
    it 'should return solved tasks' do
      user = Factory(:user_with_languages)
      solved_tasks = user.languages.map{ |l| l.tasks.first }
      user.solved_tasks = solved_tasks
      user.save

      goal_task = solved_tasks.first
      tasks_for_lang = user.solved_tasks_for_lang(goal_task.language)
      tasks_for_lang.map(&:id).should eq([goal_task.id])
    end

    it 'should return unsubdued tasks' do
      user = Factory(:user_with_languages)
      unsubdued_tasks = user.languages.map{ |l| l.tasks.first }
      user.unsubdued_tasks = unsubdued_tasks
      user.save

      goal_task = unsubdued_tasks.first
      tasks_for_lang = user.unsubdued_tasks_for_lang(goal_task.language)
      tasks_for_lang.map(&:id).should eq([goal_task.id])
    end

    it 'should return percent tasks solved' do
      user = Factory(:user_with_languages)
      solved_tasks = user.languages.map{ |l| l.tasks.first }
      user.solved_tasks = solved_tasks
      user.save
      lang = user.languages.first
      expected = 1.0 / lang.tasks.count * 100
      user.percent_solved_for_lang(lang).should be_within(1).of(expected)
    end
  end
end
