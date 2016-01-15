#Comments Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /answers/:id/comments |	Returns all the comments for a particular answer |	True
POST /answers/:id/comments/ | Creates a new answer for the specified answer |	False
GET /answers/:id/comments/recent?limit={:total} | Returns {total} comments ordered by the most recent [ MAXLIMIT = 15 ]  | True
GET /answers/:id/comments/popular?limit={:total} | Returns {total} comments ordered by the most popular [ MAXLIMIT = 15 ] | True
POST /answers/:id/comments/:id/upvote | Upvotes a comment | False
POST /answers/:id/comments/:id/downvote | Downvotes a comment | False
PUT /comments/:id | Updates the comment with certain attributes | False
DELETE /comments/:id | Deletes an comment | False

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

```ruby
Status: 404
{
  message: "Answer not found"
}
```


### POST /answers/:id/comments/

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

### GET /answers/:id/comments/recent?limit=10

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
      limit: 10,
      comments: [
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

### GET /answers/:id/comments/popular?limit={:total}

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
    answer: {
      id: 1,
      limit: 10,
      comments: [
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

### POST /answers/:id/comments/:id/upvote

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    comment_id: 5
  }
```

Response
```ruby
Status: 201
{
  message: "Successfully upvoted"
}
```

### POST /answers/:id/comments/:id/downvote

Request
```ruby
  {
    auth_token: "90ioji0j0i0i0ik0k0jmj0090jknieu93833r335",
    comment_id: 5
  }
```

Response
```ruby
Status: 201
{
  message: "Successfully downvoted"
}
```

### PUT /comments/:id

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

### DELETE /comments/:id

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
