Rails.application.routes.draw do
  root to: proc {
    [
      200,
      { "Content-Type" => "application/json" },
      [ { app: 'funcionou', ok: true, env: Rails.env }.to_json ]
    ]
  }
end
