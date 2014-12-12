Rails.application.routes.draw do
  resources :items

  root :to => "items#show", :id => '1'
end
