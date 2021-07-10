# frozen_string_literal: true
class RenameAcFieldNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :program_enrollments, :ac_enrollment_agreement_signed_field, :ac_sea_signed_field
    rename_column :program_enrollments, :ac_enrollment_agreement_url_field, :ac_sea_sign_url_field
  end
end
