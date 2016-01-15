#Tags Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /tags/?q=query |	Returns the tags that match the given the argument (autocomplete feature) |	True
GET /tags/popular | Returns the popular tags | True
GET /tags/recent | Returns the recent tags | True
GET /tags/trending | Returns the trending tags | True

### GET /tags/?q=query

Request
```ruby
  {
    q: "mac"
  }
```

Response
```ruby
Status: 200
  {
    matches: ["mac", "machine", "mac-book", "mac-book"]
  }
```

```ruby
Status: 404
{
  message: "Tag is not found."
}
```


### GET /tags/popular
Response
```ruby
Status: 200
{
  tags: ["#simulations", "#mac-book", "#checkpoint", "#accommodation", "#promotion"]
}
```
> Might be paginated
### GET /tags/recent

Response
```ruby
Status: 200
{
  tags: ["#simulations", "#mac-book", "#checkpoint", "#accommodation", "#promotion"]
}
```

### GET /tags/trending
Response
```ruby
Status: 200
{
  tags: ["#simulations", "#mac-book", "#checkpoint", "#accommodation", "#promotion"]
}
```
