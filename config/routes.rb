Rails.application.routes.draw do
  root to: proc {
    [
      200,
      { "Content-Type" => "application/json" },
      [ { ok: true }.to_json ]
    ]
  }

  get '/me/:user_id', to: 'users#me'

  get '/available_recharges_options', to: 'recharges#available_recharges_options'

  get '/users/:user_id/phones', to: 'phones#index'
  get '/users/:user_id/phones/:id', to: 'phones#show'
  post '/users/:user_id/phones', to: 'phones#create'
  put '/users/:user_id/phones/:id', to: 'phones#update'
  delete '/users/:user_id/phones/:id', to: 'phones#destroy'

  post '/users/:user_id/transfers', to: 'transfers#create'
end
