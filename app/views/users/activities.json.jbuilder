json.activities(@activities) do |activity|
  json.extract! activity, :key, :display_message
  json.url url_for(activity.url_for_trackable)
  json.activity_on do
     json.type activity.trackable_type
     json.activity_action activity.activity_type
     # little hacking done here, bu the alternative would be to expand the following
     #  line which would result in multiple lines with a following if as the
    #  trackable_information are fetched from the resource being tracked
     json.extract! activity.trackable, *activity.trackable_information
     json.related_information activity.related_information
     json.question_url question_url(activity.url_for_question)
   end
end
json.partial! "application/shared/pagination", resource: @activities
