Rails.application.routes.draw do

  # TODO: Remove default routes
  resources :adobe_connect_extension_bookings do
    get :edit_participants
    patch :update_participants
  end

end
