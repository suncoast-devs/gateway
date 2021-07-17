class MoveLeadStatusToPerson < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :lead_status, :integer, null: false, default: 0
    remove_column :program_enrollments, :status, :integer, null: false, default: 0

    Person.reset_column_information

    Person.kept.each do |person|
      response = Close::API.get("lead/#{person.close_lead}")
      case response['status_label']
      when 'Potential'
        person.potential!
      when 'Interested'
        person.interested!
      when 'Qualified'
        person.qualified!
      when 'Bad Fit'
        person.bad_fit!
      when 'Customer'
        person.customer!
      when 'Uninterested'
        person.uninterested!
      when 'Irrelevant'
        person.irrelevant!
      end
    end
  end
end
