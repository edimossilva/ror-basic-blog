# install

1. build containers
   ```
     docker-compose build
   ```

1. Setup database
   ```
     docker-compose run rails rake db:create
     docker-compose run rails rake db:migrate
     docker-compose run rails rake db:seed
   ```

1. start containers in background
   ```
     docker-compose up -d
   ```

1. run tests rails
   ```
     docker-compose exec rails rspec
   ```

1. run tests vue
   ```
     docker-compose exec vue yarn jest --coverage
   ```

1. access 

   ``` 
     http://localhost:8080/
   ```

