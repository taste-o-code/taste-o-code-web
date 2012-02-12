ActiveAdmin.register User do

  controller do
    def resource
      @user ||= User.find params[:id].to_i
    end
  end

  index do
    column :id
    column :name
    column :email
    column :total_points
    column :available_points
    column :languages do |user|
      user.languages.map{ |l| l.name }.join(',')
    end
    default_actions
  end
end
