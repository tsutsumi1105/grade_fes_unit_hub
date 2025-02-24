class PagesController < ApplicationController
  skip_before_action :require_login

  def policy
  end

  def terms
  end
end