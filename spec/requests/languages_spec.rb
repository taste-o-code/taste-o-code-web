require 'spec_helper'

describe LanguagesController do

  it 'should list all languages' do
    languages = (1..5).map { Factory(:language) }

    visit languages_path
    languages.each { |l| page.should have_content(l.name) }
  end

  it 'should display language info' do
    lang = Factory :language

    visit language_path(lang)

    page.should have_content(lang.name)
    page.should have_content(lang.description)
    lang.links.map { |link| page.should have_content(link) }
  end

end