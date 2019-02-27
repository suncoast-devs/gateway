class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :identifier
      t.string :name
      t.string :session
      t.date :starts_on
      t.date :ends_on
      t.string :days
      t.string :time

      t.timestamps
    end

    Course.reset_column_information

    Course.create([
      {
        identifier: "wdtd",
        name: "Web Development Test Drive",
        session: "Spring Session I",
        days: "Mondays and Wednesdays",
        time: "6:30 - 8:30 p.m.",
        starts_on: "2019-03-11",
        ends_on: "2019-04-17",
      },
      {
        identifier: "rbiw",
        name: "React I: Building Interactive Websites",
        session: "Spring Session I",
        days: "Tuesdays and Thursdays",
        time: "6:30 - 8:30 p.m.",
        starts_on: "2019-03-12",
        ends_on: "2019-04-18",
      },
      {
        identifier: "uxnd",
        name: "User Experience (UX) for Non-Designers",
        session: "Spring Session I",
        days: "Saturdays",
        time: "10:00 a.m. - 3:00 p.m.",
        starts_on: "2019-03-16",
        ends_on: "2019-04-20",
      },
      {
        identifier: "dmds",
        name: "Digital Marketing",
        session: "Spring Session I",
        days: "Saturdays",
        time: "10:00 a.m. - 3:00 p.m.",
        starts_on: "2019-03-16",
        ends_on: "2019-04-20",
      },
    ])
  end
end
