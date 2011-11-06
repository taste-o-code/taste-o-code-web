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
  end

end
