json.array!(@tests) do |test|
  json.extract! test, :id, :title, :text, :number, :test_at
  json.url test_url(test, format: :json)
end
