#User Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
POST /users	| Signs-in a user |	True
GET /users/renew_token |	Renew a user api_key |	False
POST /users/logout |	Logs out a user |	False
GET /users	| Returns all users (possibly paginated)	| False
GET /users/show/:id	| Returns information of a particular user	| False


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

### GET /users/show/
Request
```ruby
  {
	  user_id: 1
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
