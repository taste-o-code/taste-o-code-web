ActiveAdmin.register AdminUser do

  index do
    column :email
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
    end
    f.buttons
  end
end
