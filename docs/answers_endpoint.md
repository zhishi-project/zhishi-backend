#Answers Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /questions/:id/answers |	Returns all the answers for a particular question |	True
POST /questions/:id/answers/ | Creates a new answer for the specified question |	False
GET /questions/:id/recent_answers?limit={:total} | Returns {total} answers ordered by the most recent [ MAXLIMIT = 50 ]  | True
GET /questions/:id/popular_answers?limit={:total} | Returns {total} answers ordered by the most popular [ MAXLIMIT = 50 ] | True
PUT /questions/:question_id/answers/:id | Updates the answer with certain attributes | False
DELETE /questions/:question_id/answers/:id | Deletes an answer and its related comments | False
POST /questions/:question_id/answers/:id/accept | Marks an answer as correct for the question | False

### GET /questions/:id/answers

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335"
  }
```

Response
```ruby
Status: 200
  {
    question: {
      id: 1,
      answers: [
        {
          id: 2,
          text: 'What do you really want to do?',
          date_created: 'Wed, 24TH Nov, 2017 10:00AM',
          updated: false,
          score: 8,
          user_vote: -1,
          user: {
            id: 2,
            name: 'Oscar Laide'
          }
        },
        {
          id: 4,
          text: 'This is such a scam',
          date_created: 'Wed, 25TH Nov, 2017 12:00PM',
          updated: true,
          score: 9,
          user_vote: nil,
          user: {
            id: 3,
            name: 'Bayo Owoade'
          }
        }
      ]
    }
  }
```

```ruby
Status: 404
{
  message: "Question not found"
}
```


### POST /questions/:id/answers/

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    content: "Why in the world do I have to do this?"
  }
```

Response
```ruby
Status: 201
{
  question_id: 1,
  comments_count: 4
  id: 4,
  content: 'This is such a scam',
  votes_count: 2,
  accepted: false,
  created_at: '2016-03-24T13:57:29.219Z',
  updated_at: '2016-03-24T13:57:29.219Z',
  updated: true,
  score: 9,
  user_vote: nil,
  user: {
    "id": 1,
    "name": "Emmanuel Science",
    "points": 10,
    "image": null,
    "url": "http://localhost:3000/users/1.json"
  },
  comment: []
}
```

### GET /questions/:id/recent_answers?limit=10

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335"
  }
```

Response
```ruby
Status: 200
  {
    question: {
      id: 1,
      limit: 10,
      answers: [
        {
          id: 4,
          text: 'This is such a scam',
          date_created: 'Wed, 25TH Nov, 2017 12:00PM',
          updated: true,
          user: {
            id: 3,
            name: 'Bayo Owoade'
          }
        },
        {
          id: 2,
          text: 'What do you really want to do?',
          date_created: 'Wed, 24TH Nov, 2017 10:00AM',
          updated: false,
          user: {
            id: 2,
            name: 'Oscar Laide'
          }
        }
      ]
    }
  }
```

### GET /questions/:id/popular_answers?limit={:total}

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335"
  }
```

Response
```ruby
# note score param added to the answer
Status: 200
  {
    question: {
      id: 1,
      limit: 10,
      answers: [
        {
          id: 4,
          text: 'This is such a scam',
          date_created: 'Wed, 25TH Nov, 2017 12:00PM',
          updated: true,
          score: 9,
          user_vote: 1,
          user: {
            id: 3,
            name: 'Bayo Owoade'
          }
        },
        {
          id: 2,
          text: 'What do you really want to do?',
          date_created: 'Wed, 24TH Nov, 2017 10:00AM',
          updated: false,
          score: 8,
          vote: 0,
          user: {
            id: 2,
            name: 'Oscar Laide'
          }
        }
      ]
    }
  }
```

### PUT /questions/:question_id/answers/:id

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    content: "What in the world does this mean?"
  }
```

Response
```ruby
  Status: 204
```

### DELETE /questions/:question_id/answers/:id

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335"
  }
```

Response
```ruby
  Status: 204
```

### POST /questions/:question_id/answers/:id/accept

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335"
  }
```

Response
```ruby
  Status: 201
  {
    message: "Answer Accepted"
  }
```
