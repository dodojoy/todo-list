class UserAuthenticatedConstraint
  def matches?(request)
    user_id = request.session[:user_id]
    return false unless user_id

    user = User.find_by(id: user_id)
    user&.present?
  end
end

Rails.application.routes.draw do
  get "sign-up" => "users#new", as: :new_user
  get "sign-in" => "sessions#new", as: :new_session
  get "sessions/destroy", as: :destroy_user_session

  resources :users
  resources :tasks
  resource :session
  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check
  get "pages/home", as: :home
  root "pages#home"

  constraints UserAuthenticatedConstraint.new do
    root "tasks#index", as: :authenticated_root
  end

end
