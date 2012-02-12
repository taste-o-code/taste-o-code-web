ActiveAdmin.register Task do

  belongs_to :language

  controller do
    def resource
      @task ||= Task.find_by_slug params[:id], params[:language_id]
    end
  end

  index do
    column :language
    column :name
    column :slug
    column :award
    column :position
    default_actions
  end

  form :partial => "form"

end
