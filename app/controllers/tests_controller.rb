class TestsController < ApplicationController
  def index
    render json: { tests: TestRecord.all }
  end
end
