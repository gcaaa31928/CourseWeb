class AddAcademicYearOnCourse < ActiveRecord::Migration
    def change
        add_column :courses, :academic_year, :integer
    end
end
