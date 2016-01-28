#User Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
POST /users	| Signs-in a user |	True
GET /users/renew_token |	Renew a user api_key |	False
POST /users/logout |	Logs out a user |	False
GET /users	| Returns all users (possibly paginated)	| False
GET /users/:id	| Returns information of a particular user	| False
GET users/:id/questions| offset, limit ( both could be optional ), user_id, auth_token in header | Returns the questions with the user_id and all the information concerning it  or error message if any.
GET users/:id/tags| offset, limit ( both could be optional ), user_id, auth_token in header | Returns the tags with the user_id or error message if any.


### POST /users

Request
```ruby
  {
    provider: "google-oauth",
	  token: "2324sfsfsf123234sfsadf123423safsadf2342"
  }
```

Response
```ruby
Status: 201
  {
    api_key: "zushi_sdfadfase13452424lj23lkj234213245343453wrwerwer23424"
  }
```

```ruby
  Status: 404
  {
    message: "User token could not be verified"
  }
```
### GET /users/renew_token
Response
```ruby
Status: 200
  {
	  api_key: "zushi_sdfad89rrewet1323sdfsdf234r3423ksdfsfs00u"
  }
```
> see API_KEY errors

### POST /users/logout
Response
```ruby
Status: 204
```
> See API_KEY errors

### GET /users
Response
```ruby
Status: 200
  {
	  {
	    user_id: 1,
	    user_name:	First_name1 Last_name,
	    user_picture: image_url,
	    user_subscriptions: ["#ruby", "#rails", "#python"]
    },
    {
	    user_id: 2,
	    user_name:	First_name2 Last_name,
	    user_picture: image_url,
	    user_subscriptions: ["#photography", "#js", "#python"]
    }
  }
```

### GET /users/:id/
Request
```ruby
  {
	  id: 1
  }
```

Response
```ruby
Status: 200
  {
	  user_id: 1,
	  user_name:	First_name1 Last_name,
	  user_picture: image_url,
	  user_subscriptions: ["#ruby", "#rails", "#python"]
  }
```

Response
```ruby
Status: 404
  {
	  message: "User not found"
  }
```


## GET /users/1/tags
Request
```ruby
 GET  /users/1/tags
```
Response
```ruby
Status: 200
  {
    tags: ["operations", "andela"]
  }
```

#### OR
```ruby
Status: 404
  {
    message: "No tags found"
  }
```


## GET /users/:id/questions
Request
```ruby
 GET  /users/1/questions
```
Response
```ruby
Status: 200
  {
    [
      {
        id: 1,
        title: "what is Andela?",
        tags:  ["operations", "Andela"],
      }
      {
        id: 2
        title: "where is Amity?"
        tags:  [ "operations", "Andela"],
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

##API_KEY errors
```ruby
Status 401
  {
	  message: "Request was made with invalid token"
  }
```
```ruby
Status 404
  {
	  message: "Token seem valid but User record is not found"
  }
```
