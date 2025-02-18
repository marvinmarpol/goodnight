# Good Night App

A sleep tracking API that allows users to log sleep records by clocking-in and clocking-out, follow/unfollow other users, and view the followed user sleep records.

## Features
- User authentication using `devise_token_auth`
- Sleep tracking with clock-in and clock-out functionality
- Follow/unfollow other users
- View sleep records of followed users from last week

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/marvinmarpol/goodnight.git
   cd goodnight
   ```
2. Install dependencies:
   ```sh
   bundle install
   ```
3. Set environment variables on `.env`
   ```sh
   DB_NAME=goodnight
   DB_NAME_TEST=goodnight_test
   DB_USERNAME=username
   DB_PASSWORD=password
   DB_HOST=localhost
   DB_PORT=5432
   ```
4. Set up the database:
   ```sh
   rails db:create db:migrate db:seed
   ```
5. Start the server:
   ```sh
   rails s
   ```

## API Documentation

### Authentication

#### **Login**
- **Endpoint**: `POST /auth/sign_in`
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "password"
  }
  ```

- **Response Headers**: 
  ```
  Authorization: Bearer <your_token>
  ```

- **Response Body**:
  ```json
  {
    "data": {
        "email": "user2@example.com",
        "provider": "email",
        "uid": "user2@example.com",
        "id": 2,
        "allow_password_change": false,
        "name": "Andrew",
        "nickname": null,
        "image": null
    }
  }
  ```

#### **Logout**
- **Endpoint**: `DELETE /auth/sign_out`
- **Headers**: 
  ```
  Authorization: Bearer <your_token>
  ```

### Sleep Records

#### **Clock In**
- **Endpoint**: `POST /sleep_records/clock_in`
- **Headers**: `Authorization: Bearer <your_token>`
- **Response**: `201 Created`

#### **Clock Out**
- **Endpoint**: `PATCH /sleep_records/clock_out`
- **Headers**: `Authorization: Bearer <your_token>`
- **Response**: `200 OK`

#### **Get Sleep Records**
- **Endpoint**: `GET /sleep_records?page=1`
- **Headers**: `Authorization: Bearer <your_token>`
- **Response**:
  ```json
  {
    "data": [
        {
            "id": 7,
            "user_id": 2,
            "clock_in": "2024-02-17T06:28:11.863Z",
            "clock_out": null,
            "duration": null,
            "created_at": "2025-02-17T06:28:11.873Z",
            "updated_at": "2025-02-17T06:28:11.873Z"
        }
    ],
    "pagination": {
        "total": 1,
        "current_page": 1,
        "limit_per_page": 20
    }
  }
  ```

#### **Get Friends' Sleep Records**
- **Endpoint**: `GET /sleep_records/friends`
- **Headers**: `Authorization: Bearer <your_token>`
- **Response**:
  ```json
  {
    "data": [
        {
            "id": 7,
            "user_id": 2,
            "clock_in": "2025-02-17T06:28:11.863Z",
            "clock_out": null,
            "duration": null,
            "created_at": "2025-02-17T06:28:11.873Z",
            "updated_at": "2025-02-17T06:28:11.873Z"
        }
    ],
    "pagination": {
        "total": 1,
        "current_page": 1,
        "limit_per_page": 20
    }
  }
  ```

### Follow/Unfollow Users

#### **Follow a User**
- **Endpoint**: `POST /users/:id/follow`
- **Headers**: `Authorization: Bearer <your_token>`
- **Response**: `201 Created`

#### **Unfollow a User**
- **Endpoint**: `DELETE /users/:id/unfollow`
- **Headers**: `Authorization: Bearer <your_token>`
- **Response**: `200 OK`

### Health Check
- **Endpoint**: `GET /up`
- **Response**: `200 OK`

## Running Tests

To run tests, execute:
```sh
bundle exec rspec
```
