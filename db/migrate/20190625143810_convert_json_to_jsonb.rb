# frozen_string_literal: true
class ConvertJsonToJsonb < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
 change_column :program_applications, :question_responses, 'jsonb USING CAST(question_responses AS jsonb)' end
      dir.down do
 change_column :program_applications, :question_responses, 'json USING CAST(question_responses AS json)' end
    end
  end
end
