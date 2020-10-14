module API
  class PublicController < ApplicationController
    skip_before_action :verify_authenticity_token

    # GET /api/cohorts
    # [
    #   {
    #     "id": 46,
    #     "name": "20",
    #     "is_enrolling": true,
    #     "begins_on": "2020-12-04",
    #     "ends_on": "2021-03-18",
    #     "created_at": "2020-10-14T14:02:59.423Z",
    #     "updated_at": "2020-10-14T14:07:02.516Z",
    #     "format": "Immersive",
    #     "note": ".NET",
    #     "delivery": "In-person"
    #   }
    # ]
    def cohorts
      @cohorts = Cohort.where "ends_on > ?", Date.today
      render json: @cohorts
    end
  end
end
