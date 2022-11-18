# frozen_string_literal: true
class AddCRMURLToProgramApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :program_applications, :crm_url, :string
  end
end
