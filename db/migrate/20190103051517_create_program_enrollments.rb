class CreateProgramEnrollments < ActiveRecord::Migration[5.2]
  def change
    create_table :program_enrollments do |t|
      t.references :person, foreign_key: true
      t.references :cohort, foreign_key: true
      t.string :program
      t.string :ac_deal_identifier
      t.integer :stage, null: false, default: 3
      t.integer :status, null: false, default: 0
      t.boolean :deposit_required
      t.boolean :deposit_paid
      t.boolean :enrollment_agreement_complete
      t.string :financial_clearance
      t.string :lost_reason
      t.timestamps
    end

    add_reference :program_applications, :program_enrollment
    add_reference :program_acceptances, :program_enrollment
    add_column :people, :preferred_communication, :string
    add_column :people, :shirt_size, :string
    add_column :people, :dietary_note, :string

    ProgramApplication.reset_column_information
    ProgramAcceptance.reset_column_information
    ProgramEnrollment.reset_column_information

    ProgramApplication.all.each do |app|
      if app.program == "web-development"
        say "Creating enrollment record for #{app.person.full_name}"
        enrollment = ProgramEnrollment.new
        enrollment.person = app.person
        enrollment.program = app.program

        if app.acceptance_sent?
          enrollment.stage = 5
        elsif app.interview_scheduled?
          enrollment.stage = 4
        else
          enrollment.stage = 3
        end

        if enrollment.save!
          app.update(program_enrollment: enrollment)
          app.program_acceptance.update(program_enrollment: enrollment) if app.program_acceptance
        end
      end
    end
  end
end
