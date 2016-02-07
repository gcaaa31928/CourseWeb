class Score < ActiveRecord::Base
    validates :project_id, uniqueness: {scope: [ :teaching_assistant_id, :no]}
    belongs_to :project
    belongs_to :teaching_assistant
    
end
