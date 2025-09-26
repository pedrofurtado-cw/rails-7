Rails.application.routes.draw do
  root to: proc {
    [
      200,
      { "Content-Type" => "application/json" },
      [ { app: 'funcionou', ok: true, env: Rails.env }.to_json ]
    ]
  }

  get '/tests', to: 'tests#index'
  get '/me/:user_id', to: 'users#me'
end
