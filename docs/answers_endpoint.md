#Answers Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /questions/:id/answers |	Returns all the answers for a particular question |	True
POST /questions/:id/answers/ | Creates a new answer for the specified question |	False
GET /questions/:id/answers/recent?limit={:total} | Returns {total} answers ordered by the most recent [ MAXLIMIT = 50 ]  | True
GET /questions/:id/answers/popular?limit={:total} | Returns {total} answers ordered by the most popular [ MAXLIMIT = 50 ] | True
POST /questions/:id/answers/:id/upvote | Upvotes an answer | False
POST /questions/:id/answers/:id/downvote | Downvotes an answer | False
PUT /answers/:id | Updates the answer with certain attributes | False
DELETE /answers/:id | Deletes an answer and its related comments | False

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
    text: "Why in the world do I have to do this?"
  }
```

Response
```ruby
Status: 201
{
  message: "Successfully added"
}
```

### GET /questions/:id/answers/recent?limit=10

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

### GET /questions/:id/answers/popular?limit={:total}

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
          user: {
            id: 2,
            name: 'Oscar Laide'
          }
        }
      ]
    }
  }
```

### POST /questions/:id/answers/:id/upvote

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    answer_id: 5
  }
```

Response
```ruby
Status: 201
{
  message: "Successfully upvoted"
}
```

### POST /questions/:id/answers/:id/downvote

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    answer_id: 5
  }
```

Response
```ruby
Status: 201
{
  message: "Successfully downvoted"
}
```

### PUT /answers/:id

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    text: "What in the world does this mean?"
  }
```

Response
```ruby
  Status: 204
```

### DELETE /answers/:id

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
