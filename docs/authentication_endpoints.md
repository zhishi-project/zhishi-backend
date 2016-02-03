#Authentication

Because the application mainly for in-house usage, usage is largely authenticated.
Therefore, to authenticate a user, here are the endpoints provided:

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /login/:provider_url?redirect_url=[REDIRECT_URL]	| Send the user here to login with the provider specified. Provider could either be Google or Slack. We would authenticate the user and send back the same user to the `redirect_url` provided along with a `temp_token` params as a query string, e.g `http://front-end-route.com?temp_token=[TEMP_TOKEN]`. `redirect_url` must be fully qualified  |	True
POST /validate_token | Send back the `temp_token` received in the login action earlier as a JSON object: `{temp_token: [TEMP_TOKEN]}`. A valid user token is sent back, which must be thrown in a `Authorization Token token=[TOKEN]` header for all other requests | True


### GET /login/:provider_url?redirect_url=[REDIRECT_URL]

Request
```ruby
  {
    provider: /google|slack/,
	  redirect_url: "http://example.com/route-to-receive-user"
  }
```

### POST /validate_token

Request
```ruby
  {
	  temp_token: "hjdhdu9euu93uh43ih43i3u94y3h94u094u30jr33u39u"
  }
```

Response
```ruby
Status: 200
  {
	  api_key: "zushi_sdfad89rrewet1323sdfsdf234r3423ksdfsfs00u"
  }
```
