class AddAcDealIdentifierToProgramApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :program_applications, :ac_deal_identifier, :string
  end
end
