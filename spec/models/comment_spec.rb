require 'spec_helper'

describe Comment do

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :task }
    it { should validate_presence_of :user }
  end

end
