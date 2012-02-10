ActiveAdmin.register Task do
  index do
    column :language
    column :name
    column :slug
    column :award
    default_actions
  end
end
