Setting up Zhishi Backend

First thing first, ensure you have cloned the zhishi backend from github.

``
git clone git@github.com:andela-iamadi/zhishi-backend.git
``

Secondly ensure you have postgress installed locally especially if you're working with Rails newly on your machine. For some reasons I had issues installing the specific postgres for this application, so this worked for me.

`gem install pg -v '0.18.4' -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/latest/bin/pg_config
`

after which you simply run `bundle` to install the remaining dependecies.

Now that all dependecies for the app are installed you should run the database migration at this point by running 

`rake db:migrate`


Run `figaro install` to generate the application.yml file to configure environment variable for the application.


The last thing you should also install at this point is redis data store, simply run 

`brew install redis` to install redis, then to start redis simply run `brew services restart redis `


IMPORTANT: For development you may want to ensure you have this minimal variables setup

```
BASE_ANDELA_URL: <andela-systems-api-path>
BASE_URL: <zhishi-frontend-application-path>
ANDELA_AUTH_URL: <andela-systems-api-path>/login
LOGOUT_PATH: logout
```

At this point the backend application should be up and running!
