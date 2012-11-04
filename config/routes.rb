Doorbell::Application.routes.draw do

  resources :doormen
  resources :events

  match "events/:event_name/start", to: "events#start", as: "start_event"
  match "events/:event_name/end", to: "events#end", as: "end_event"

  match "sms",  to: "application#sms",  via: :post
  match "call", to: "application#call", via: :post

  # root :to => 'doormen'
  
end
