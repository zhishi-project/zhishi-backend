json.notifications(@notifications) do |notification|
  json.id notification.id
  json.type notification.type
  json.key notification.key
  json.url notification.question_url
  json.title notification.question_title
  json.extract! notification, *notification.additional_information
  json.content notification.content
end
