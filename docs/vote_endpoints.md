#Votes Resources

Endpoints |	Usage |	Public Access
--------- | ----- | -------------
POST /questions/:question_id/upvote |	Increase the upvotes of the given question by one unit |	False
POST /questions/:question_id/downvote |	Increase the downvotes of the given question by one unit |	False
POST /answers/:answer_id/upvote |	Increase the upvotes of the given answer by one unit |	False
POST /answers/:answer_id/downvote |	Increase the downvotes of the given answers by one unit |	False
POST /comments/:question_id/upvote |	Increase the upvotes of the given comment by one unit |	False
POST /comments/:question_id/downvote |	Increase the downvotes of the given comments by one unit |	False

### POST /questions/:question_id/upvote/

Response
```ruby
Status: 200
{
  response: 11
}
```
#### OR
```ruby
Status: 403
  {
    error: "Invalid vote!"
  }
```
### POST /comments/:comment_id/upvote/

Response
```ruby
Status: 200
{
  response: 23
}
```
#### OR
```ruby
Status: 403
  {
    error: "Invalid vote!"
  }
```
### POST /answers/:answer_id/upvote/

Response
```ruby
Status: 200
{
  response: 0
}
```
#### OR
```ruby
Status: 403
  {
    error: "Invalid vote!"
  }
```
### POST /questions/:question_id/downvote/

Response
```ruby
Status: 200
{
  response: 2
}
```
#### OR
```ruby
Status: 403
  {
    error: "Invalid vote!"
  }
```
### POST /comments/:comment_id/downvote/

Response
```ruby
Status: 200
{
  response: -12
}
```
#### OR
```ruby
Status: 403
  {
    error: "Invalid vote!"
  }
```
### POST /answers/:answer_id/downvote/

Response
```ruby
Status: 200
{
  response: 34
}
```
#### OR
```ruby
Status: 403
  {
    error: "Invalid vote!"
  }
```
