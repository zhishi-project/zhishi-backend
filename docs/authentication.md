#Authentication

Since the application depends on the Andela Authentication system, there are no more dedicated routes for authenticaion - login, logout, validate_token.

We still perform authorization for every request using the JWT token. In a case of authorization failure for any request, we then attempt to authenticate with the Andela authentication service using the `andela:session` token, and carry on with the request if successful or not if failed.

Therefore, we expect every request to have this rescue plan of carring the `andela token` in the header along with the Zhishi `api key`.

The responce, however, for every request that was authenticated using the `andela token` carries an object in the key, `renewal` and contains the new Zhishi `api_key` and  the `user` object.
THIS NEW `api_key` IS EXPECTED TO BE USED FOR SUBSEQUENT REQUESTS.

### Requests Header
```ruby
header: {
  "Authentication": "Token token=kjdhbofdsbfudkajds.api.keygtsnfs",
  "andela_cookie": "theandelaseesioncookie"
}
```

### Response Body
**If authentication was with Andela cookie**
```ruby
{
  _[regular responce for this request]_,
  renewal: {
    api_key: "new api key",
    user: { [New user object] }
  }
}
```

**If authentication was with Zhishi API key**
```ruby
{
  _[reqular responce for the request]_
}
```
