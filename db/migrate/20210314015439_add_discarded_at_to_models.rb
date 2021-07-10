# frozen_string_literal: true
class AddDiscardedAtToModels < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :discarded_at, :datetime
    add_index :people, :discarded_at

    add_column :notes, :discarded_at, :datetime
    add_index :notes, :discarded_at

    add_column :program_acceptances, :discarded_at, :datetime
    add_index :program_acceptances, :discarded_at

    add_column :program_applications, :discarded_at, :datetime
    add_index :program_applications, :discarded_at

    add_column :program_enrollments, :discarded_at, :datetime
    add_index :program_enrollments, :discarded_at
  end
end
