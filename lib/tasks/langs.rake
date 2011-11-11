namespace :langs do

  desc "Updates or creates languages using langs.yml."
  task :update => :environment do
    langs = YAML.load_file("#{Rails.root.to_s}/db/langs.yml")
    langs.each{|lang| insert_or_update lang}
  end

  def insert_or_update(lang_yml)
    lang = Language.where(:_id => lang_yml["id"]).first
    lang ||= Language.new
    status = lang.persisted? ? 'updated' : 'inserted'
    if lang.update_attributes lang_yml
      lang.save
      puts "%-7s #{status}" % lang.id
    else
      puts "%-7s wasn't #{status}" % lang.id
      puts lang.errors.messages.to_yaml
    end
  end
end
