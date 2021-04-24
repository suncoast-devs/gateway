class Enrollment::ApplicationProjection < ProjectionJob
  def submitted(event)
    uid = event.data[:id]
    return if Application.where(aggregate_root: uid).exists?

    Application.create!(
      aggregate_root: uid,
      state: :submitted,
      contact: event.data[:contact],
      responses: event.data[:responses],
      submitted_at: event.data[:submitted_at],
    )
  end
end
