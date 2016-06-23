## Notifications Endpoint

Endpoints |Params| Usage |
--------- | ----- |--------
GET /notifications |  |	Returns all the notifications that has been pushed to the user's queue. Max size of the elements array is 15

## GET /questions/
## GET /questions/all
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
