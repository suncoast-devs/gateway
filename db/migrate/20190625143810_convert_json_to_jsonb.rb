class ConvertJsonToJsonb < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up { change_column :program_applications, :question_responses, "jsonb USING CAST(question_responses AS jsonb)" }
      dir.down { change_column :program_applications, :question_responses, "json USING CAST(question_responses AS json)" }
    end
  end
end
