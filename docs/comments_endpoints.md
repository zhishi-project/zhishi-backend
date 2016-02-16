#Comments Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /answers/:id/comments |	Returns all the comments for a particular answer |	True
POST /answers/:id/comments/ | Creates a new comment for the specified answer |	False
PATCH /answers/:answer_id/comments/:id | Updates the specified comment of the specified answer | False
DELETE /answers/:answer_id/comments/:id | Deletes the specified comment of the specified answer | False
GET /questions/:id/comments |	Returns all the comments for a particular question |	True
POST /questions/:id/comments/ | Creates a new comment for the specified question |	False
PATCH /questions/:question_id/comments/:id | Updates the specified comment of the specified question | False
DELETE /questions/:question_id/comments/:id | Deletes the specified comment of the specified question | False

### GET /answers/:id/comments

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
    answer: {
      id: 1,
      comments: [
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
 Or

```ruby
Status: 404
{
  error: "The resource you tried to access was not found"
}
```

### GET /questions/:id/comments

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
    answer: {
      id: 1,
      comments: [
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
 Or

```ruby
Status: 404
{
  error: "The resource you tried to access was not found"
}
```


### POST /answers/:id/comments/

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
```

### POST /questions/:id/comments/

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
```
OR
```ruby
Status: 404
{
  error: "Comment body can not be empty!"
}
```

### PATCH /answers/:answer_id/comments/:id

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    content: "What in the world does this mean?"
  }
```

Response
```ruby
  Status: 200
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
```
### PATCH /questions/:question_id/comments/:id

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    content: "What in the world does this mean?"
  }
```

Response
```ruby
  Status: 200
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
```
OR
```ruby
Status: 404
{
  error: "Comment body can not be empty!"
}
```
### DELETE /answers/:answer_id/comments/:id

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

### DELETE /questions/:answer_id/comments/:id

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

OR
```ruby
Status: 404
{
  error: "The operation could not be performed. Please check your request or try again later"
}
```
