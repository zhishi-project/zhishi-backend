#!/bin/bash

if [ -z "$REMOTE" ]; then
  branch='test'
else
  branch=$REMOTE
fi

git push $branch master

heroku run rake db:migrate --remote $branch
heroku run rake zhishi:es:reindex[question] --remote $branch
heroku run rake zhishi:es:reindex[tag] --remote $branch
