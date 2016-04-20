#Tags Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
GET /tags/?q=query |	Returns the tags that match the given the argument (autocomplete feature) |	True
GET /tags/popular | Returns the popular tags | True
GET /tags/recent | Returns the recent tags | True
GET /tags/trending | Returns the trending tags | True
POST /tags/update_subscription | Returns the users tags | True

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
    tags: [
      {
        name: 'mac',
        id: 1,
        representative_id: nil
      }
    ]
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
  tags: [
    {
      name: 'mac',
      id: 1,
      representative_id: nil
    }
  ]
}
```
> Might be paginated
### GET /tags/recent

Response
```ruby
Status: 200
{
  tags: [
    {
      name: 'mac',
      id: 1,
      representative_id: nil
    }
  ]
}
```

### GET /tags/trending
Response
```ruby
Status: 200
{
  tags: [
    {
      name: 'mac',
      id: 1,
      representative_id: nil
    }
  ]
}
```

### POST /tags/update_subscription
Request
```ruby
{
  tags: 'tag1, tag2'
}
```

Response
```ruby
Status: 200
{
  tags: [
    {
      name: 'tag1',
      id: 1,
      representative_id: nil
    },
    {
      name: 'tag2',
      id: 2,
      representative_id: nil
    }
  ]
}
```
