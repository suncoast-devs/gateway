# frozen_string_literal: true
class AddCustomFieldsToProgramEnrollment < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :ac_deposit_outstanding_field, :string
    add_column :program_enrollments, :ac_enrollment_agreement_signed_field, :string
    add_column :program_enrollments, :ac_financially_cleared_field, :string
    add_column :program_enrollments, :ac_deposit_invoice_url_field, :string
    add_column :program_enrollments, :ac_enrollment_agreement_url_field, :string
  end
end
