# frozen_string_literal: true
class CreateCourseRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :course_registrations do |t|
      t.references :person, foreign_key: true
      t.references :course, foreign_key: true
      t.references :invoice, foreign_key: true
      t.integer :fee
      t.string :code

      t.timestamps
    end
  end
end
