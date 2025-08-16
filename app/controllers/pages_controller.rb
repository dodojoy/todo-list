class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :home ]
  before_action :redirect_user_to_tasks

  def home
  end
end
