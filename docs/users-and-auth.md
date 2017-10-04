# Users and Authentication

In order to access any resources from the API, you'll need to be authenticated. Creating a user is the only non-authenticated route in the API.

## How to Authenticate a Request

Include in your request the **Authorization** Header, whose value is the JSON Web Token received after authenticating. An example cURL request:

``` bash
curl -H "Authorization: long.Token" http://localhost:3000/things
```

All available routes require authentication, with the sole exception of creating a user (`POST /user`). The JSON Web Token lasts for 24 hours.

## Routes

The routes covered here are:

* [creating a user](#creating-a-user)
* [updating user credentials](#updating-user)
* [deleting a user](#deleting-a-user)
* [authenticating](#authenticating)

### Creating a User

#### `POST /user`

Used for creating a new user in the system, like when signing up for the service.

#### Format Request

| key              | Required       | Type           |
| :-------------   | :------------- | :------------- |
| user             | yes            |                |
| user['name']     | yes            | string         |
| user['email']    | yes            | string         |
| user['password'] | yes            | string         |

Example payload (in `application/json` format):

``` json
  "user": {
    "name": "bana",
    "email": "bana@haha.com",
    "password": "reallygoodpassword"
  }
```

Some restrictions:

* the email used must be unique - a user can not have multiple accounts under the same email address
* the password must be 8 characters or longer, and under 72 characters

#### Responses

**On Success** status: `201`

The user's auth token will be returned.

``` json
{
  "auth_token": "big-ol-auth-token"
}
```

**On Failure** status: `400`

The request to create a new user failed. A list of errors will be returned with some hints as to why:

``` json
{
  "error": {
    "error": {
      "password": [
        "can't be blank",
        "is too short (minimum is 8 characters)"
      ],
      "email": [
        "can't be blank"
      ]
    }
  }
}
```

``` json
{
  "error": "Malformed request! Please refer to the documentation and try again"
}
```

### Updating User

#### `PUT /user`

Used for updating user details, name, email, and/or password. Currently, you can follow any of these scenarios:

* update name and/or email
* update password

It is **not allowed** to update the password with anything else. You are, however, allowed to update the email and name together.

#### Format Request

| key              | Required       | Type           |
| :-------------   | :------------- | :------------- |
| user             | yes            |                |
| user['name']     | no             | string         |
| user['email']    | no             | string         |
| user['password'] | no             | string         |

Example payload (in `application/json` format):

``` json
  "user": {
    "name": "banarama",
    "email": "bana@hahalol.com"
  }
```

``` json
  "user": {
    "password": "updatingpassword"
  }
```

This is an example of a payload that is **not allowed**&mdash;it will return an error:

``` json
  "user": {
    "name": "banarama bad request",
    "email": "bana@hahalol.com",
    "password": "updatingpasswordWontWork"
  }
```

#### Responses

**On Success** status: `200`

``` json
{
  "ok": true
}
```

**On Failure** status: `400`

Errors will be returned trying to offer hints as to why the request failed.

``` json
{
  "error": "Please only change either the password or the name and email"
}
```

``` json
{
  "error": {
    "password": [
      "is too short (minimum is 8 characters)"
    ]
  }
}
```

### Deleting a User

#### `DELETE /user`

Used for deleting a user. Simply being authorized to access this route will provide the information we need to delete the account.

#### Responses

**On Success** status: `200`

``` json
{
  "ok": true
}
```

**On Failure** status: `400`

Errors will be returned trying to offer hints as to why the request failed.

``` json
{
  "error": "user not deleted due to x reason"
}
```

### Authenticating

#### `POST /authenticate`

Used for authenticating a user. Doing this will provide an auth_token to authenticate further requests made. Currently this auth token lasts 24 hours from issue. We would recommend [storing it in cookies](https://stormpath.com/blog/where-to-store-your-jwts-cookies-vs-html5-web-storage) for any web applications.

#### Format Request

| key              | Required       | Type           |
| :-------------   | :------------- | :------------- |
| user             | yes            |                |
| user['email']    | yes            | string         |
| user['password'] | yes            | string         |

Example payload (in `application/json` format):

``` json
  "user": {
    "email": "bana@haha.com",
    "password": "fancypants"
  }
```

#### Responses

**On Success** status: `200`

``` json
{
  "auth_token": "super long token"
}
```

**On Failure** status: `401`

You will be told you are unauthorized

``` json
{
  "error": {
    "user_authentication": [
      "invalid credentials"
    ]
  }
}
```
