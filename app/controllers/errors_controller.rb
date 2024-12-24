class ErrorsController < ApplicationController
  def routing_error
    redirect_to root_path, alert: "存在しないページです"
  end
end