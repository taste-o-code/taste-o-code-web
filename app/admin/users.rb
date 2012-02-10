ActiveAdmin.register User do
  index do
    column :id
    column :name
    column :email
    column :total_points
    column :available_points
    column :languages do |user|
      user.languages.map{ |l| l.name }.join(',')
    end
  end
end
