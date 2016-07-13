## Notifications Endpoint

Endpoints |Params| Usage |
--------- | ----- |--------
GET /notifications |  |	Returns all the notifications that has been pushed to the user's queue. Max size of the elements array is 15
GET /point_notifications |  |	Returns all the notifications that has been pushed to the user's queue. Max size of the elements array is 15

## GET /notifications
Request
```ruby
 GET  /notifications
```
Response
```ruby
Status: 200
  {
    notifications:[{
            id: 1,
            type: "New Comment",
            key: "new.comment"
            url: "http://localhost:3000/questions/1",
            title:  "Why do I have to try this again",
            content: "I hope this makes sense at the end of the day"
          },
          {
            id: 2,
            type: "New Answer",
            key: "new.answer"
            url: "http://localhost:3000/questions/1",
            title:  "Why do I have to try this again",
            content: "I hope this makes sense at the end of the day"
          },
          {
            id: 1,
            type: "New Question",
            key: "new.question"
            url: "http://localhost:3000/questions/1",
            title:  "Why do I have to try this again",
            content: "I hope this makes sense at the end of the day"
          }          
    ]
  }
```

## GET /point_notifications
Request
```ruby
 GET  /point_notifications
```
Response
```ruby
Status: 200
  {
    notifications:[{
            id: 1,
            type: "Accepted your Answer",
            key: "answer.accept"
            url: "http://localhost:3000/questions/1",
            title:  "Why do I have to try this again",
            points: "+20",
            content: "I hope this makes sense at the end of the day"
          },
          {
            id: 2,
            type: "Upvoted your Answer",
            key: "answer.upvote"
            url: "http://localhost:3000/questions/1",
            title:  "Why do I have to try this again",
            points: "+5",
            content: "I hope this makes sense at the end of the day"
          },
          {
            id: 1,
            type: "Downvoted your Question",
            key: "question.downvote"
            url: "http://localhost:3000/questions/1",
            title:  "Why do I have to try this again",
            points: "-2"
            content: "I hope this makes sense at the end of the day"
          }          
    ]
  }
```
