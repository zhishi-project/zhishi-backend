## Questions Resources

Endpoints |Params| Usage |
--------- | ----- |--------
GET /questions | offset, limit ( both could be optional ), auth_token in header |	Returns all questions ordered by the tags the user is subscribed to, with up-vote and down-vote data, or error message if any.
GET /questions/all | offset, limit ( both could be optional ), auth_token in header |	Returns all questions with up-vote and down-vote data, or error message if any.
POST /questions |title, description, user_id, auth_token in header | Returns success message if question creation is successful  or error message if any.
GET /questions/:id |question's id, auth_token in header| Returns the question with that id and all other information concerning the the question or error message if any.
GET questions/top_questions | offset, limit ( both could be optional ), auth_token in header | Returns the questions matching the criteria for top questions or error message if any.
PUT questions/:id| question's id, update information(title, description), auth_token in header | Returns the updated question and all the information concerning it  or error message if any.
DELETE questions/:id| question's id, auth_token in header | Returns a confirmation that the question has been deleted  or error message if any.
GET questions/search | `q` which has the value of the params to search | Returns an array of questions, with a few things stripped off, such as association counts etc
GET questions/personalized | offset, limit ( both could be optional ), auth_token in header | Returns all questions based on the tags a user has subscribed to with all the basic data
GET questions/by_tags | `tag_ids` which is an array of tag_id, this allows the client to filter by multiple tags. Preferably, send the representative_id of the tags as well | Returns the questions matching the tag_ids provided.

## GET /questions/
## GET /questions/all
Request
```ruby
 GET  /questions?limit=5&offset=1
```
Response
```ruby
Status: 200
  {
    questions:[{
            id: 1,
            title: "what is Andela?",
            user_id: 1,
            tags:  [ "operations", "Andela"],
          },
          {
            id: 2
            title: "where is Amity?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 3
            title: "what is M55?"
            user_id: 4
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 4
            title: "What is DevOps?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 5
            title: "What is month one all about?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
    ]
  }
```

#### OR
```ruby
Status: 404
  {
    message: "No questions found"
  }
```

## POST /questions
Request
```ruby
  POST  /questions
  params: {
    title: "Question Title",
    content: "Question Description",
    user_id: "current user id",
    tags: "tag 1", "tag 2",
  }
```

Response
```ruby
Status: 201
  {
    question: {
      id: 1,
      title: "Question tittle",
      description: "Question Description",
      user_id: 1,
      up_votes: 0
      down_votes: 0
      comment:  [{  }],
      answers: [{
                 "No answers yet"
               }],
      tags:  [{
                matches: [ "tag 1", "Tag 2"]
             }],
      created_at: "2015-12-14T16:51:06.437Z",
      updated_at: "2015-12-14T16:51:06.437Z",
    }
  }}
```

#### OR

```ruby
Status: 403
  {
    message: Error Message
  }
```

## GET /questions/:id

Request
```ruby
  GET  /questions/1
```

Response
```ruby
Status: 200
{
  question: {
    id: 1,
    title: "What is Andela",
    description: "I want to know what Andela is all about",
    user_id: 24,
    up_votes: 10
    down_votes: 0
    user_vote: 1,
    comment:  [
                {
                  id: 1,
                  id: 13,
                  body: "This is a comment on a question",
                  type: "comment",
                  created_at: "2015-12-14T22:23:17.646Z",
                  updated_at: "2015-12-14T22:23:17.646Z"
                }
                {
                  id: 2,
                  user_id: 2,
                  body: "This is another comment on a question",
                  type: "comment",
                  created_at: "2015-12-14T22:23:17.646Z",
                  updated_at: "2015-12-14T22:23:17.646Z"
                }
            ],

    answers: [{
               id: 1,
               user_id: 21,
               body: "A description of Andela",
               type: "Answer",
               comment:[
                        {
                         id: 3,
                         user_id: 3,
                         body: "This is a comment on an answer",
                         type: "comment",
                         created_at: "2015-12-14T22:23:17.646Z",
                         updated_at: "2015-12-14T22:23:17.646Z"
                       }
                       {
                        id: 7,
                        user_id: 5,
                        body: "This is another comment on an answer",
                        type: "comment",
                        created_at: "2015-12-14T22:23:17.646Z",
                        updated_at: "2015-12-14T22:23:17.646Z"
                      }
                    ],
               created_at: "2015-12-14T22:23:17.646Z",
               updated_at: "2015-12-14T22:23:17.646Z"

             }],
    tags:  [{
              matches: [ "operations", "Andela"]
           }],
    created_at: "2015-12-14T16:51:06.437Z",
    updated_at: "2015-12-14T16:51:06.437Z",
  }
}
```
#### OR

```ruby
Status: 404
  {
    message: "Question with id 1 was not found"
  }
```

## GET /top_questions
Request
```ruby
 GET  /top_questions?limit=5,offset=1
```
Response
```ruby
Status: 200
  {
    question:[{
            id: 12,
            title: "what is Andela?",
            user_id: 1,
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 24
            title: "where is Amity?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 300
            title: "what is M55?"
            user_id: 4
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 41
            title: "What is DevOps?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 5
            title: "What is month one all about?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
    ]
  }
```

#### OR
```ruby
Status: 404
  {
    message: "No questions found"
  }
```

## PUT /questions/:id
Request
```ruby
  PUT/PATCH  /questions/1
  params: {
    title: "Edited Question Title",
    description: "Edited Question Description",
    user_id: "current user id",
    tags: "tag 1", "tag 2", "tag 3"
  }
```

Response
```ruby
Status: 200
  {
    question: {
      id: 1,
      title: "Edited Question Title",
      content: "Edited Question Description",
      votes_count: 1,
      answers_count: 0
      comments_count: 0
      created_at: "2015-12-14T16:51:06.437Z",
      updated_at: "2015-12-14T16:51:06.437Z",
    }
  }}
```

#### OR

```ruby
Status: 403
  {
    message: Error Message
  }
```
## DELETE /questions/:id
Request
```ruby
  DELETE  /questions/1
```

Response
```ruby
Status: 200
{
  message: "Question deleted successfully"
}
```

#### OR

```ruby
Status: 403
  {
    message: Error Message
  }
```


## GET /questions/search
Request
```ruby
 GET  /questions/search?q=search+params
```
Response
```ruby
Status: 200
  {
    questions:[{
            id: 1,
            title: "what is Andela?",
            content: "Andela has been said to be everything"
            user: {
              name: 'User Name',
              email: 'username@email.com',
            },
            tags:  [ "operations", "Andela"],
            url: 'http://zhishi.com/questions/1',
          }
          {
            id: 2
            title: "where is Amity?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 3
            title: "what is M55?"
            user_id: 4
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 4
            title: "What is DevOps?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 5
            title: "What is month one all about?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
    ]
  }
```

## GET /top_questions
Request
```ruby
 GET  /questions/by_tags?tag_ids[]=1&tag_ids[]=2&tag_ids[]=3&tag_ids[]=4&page=1
 OR
 GET  /questions/by_tags?page=1
 data: { tag_ids: [1,2,3,4] }
```
Response
```ruby
Status: 200
  {
    question:[{
            id: 12,
            title: "what is Andela?",
            user_id: 1,
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 24
            title: "where is Amity?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 300
            title: "what is M55?"
            user_id: 4
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 41
            title: "What is DevOps?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
          {
            id: 5
            title: "What is month one all about?"
            user_id: 12
            tags:  [{
                      matches: [ "operations", "Andela"],
                   }],
          }
    ]
  }
```
