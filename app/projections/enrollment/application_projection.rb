class Enrollment::ApplicationProjection
  def call(event)
    send event.class.name.demodulize.underscore, event
  end

  def submitted(event)
    uid = event.data[:id]
    return if Application.where(uid: uid).exists?
    Application.create!(
      uid: uid,
      state: "Draft",
    )
  end
end
