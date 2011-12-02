namespace :langs do

  desc "Updates or creates languages using langs.yml."
  task :update => :environment do
    puts 'Languages'
    langs = YAML.load_file("#{Rails.root.to_s}/db/langs.yml")
    langs.each{|lang| insert_or_update_lang lang}
    puts "\n\nTasks"
    tasks = YAML.load_file("#{Rails.root.to_s}/db/tasks.yml")
    tasks.each{|task| insert_or_update_task task}
  end

  def insert_or_update_lang(lang_yml)
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

  def insert_or_update_task(task_yml)
    task = Task.where(:language_id => task_yml["language_id"],
                      :position => task_yml["position"]).first
    task ||= Task.new
    status = task.persisted? ? 'updated' : 'inserted'
    if task.update_attributes task_yml
      task.save
      puts "%-7s %2d %-20s #{status}" % [task.language_id, task.position, task.name]
    else
      puts "%-7s %2d %-20s wasn't #{status}" % [task.language_id, task.position, task.name]
      puts task.errors.messages.to_yaml
    end
  end
end
