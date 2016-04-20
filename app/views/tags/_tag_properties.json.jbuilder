json.tags do
  json.array!(tags){|tag| json.extract! tag, :id, :name, :representative_id }
end
