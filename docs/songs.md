# Songs per User

In the Songbin app, Users save Songs from somewhere. Right now, we're only supporting Youtube, but there are plans to expand to other video and audio hosting services.

## Making sure you're authenticated

For all these endpoints, you'll **need to be authenticated** in order to access any song information. A user can only see their own songs, they can not share their songs amongst other users.

## Routes

The routes covered here are:

* [getting all of a user's songs](#get-all-songs)
* [get details about a single song](#get-a-song)
* [update details about a single song](#update-a-song)
* [delete a single song](#delete-a-song)

### Get All Songs

#### `GET /songs`

Access the entire list of songs a user has saved.

#### Format Request

No payload is required.

#### Responses

**On Success** status: `200`

An array of songs containing their name, id, and music_url will be returned.

``` json
{
  "data": [
    {
      "name": "Real Good Song",
      "music_url": "https://www.youtube.com/watch?v=nq4o7wLUVI4",
      "id": 123
    },
    {
      "name": "Happy Birthday Good Song",
      "music_url": "https://www.youtube.com/watch?v=nq4o7wLUVI4",
      "id": 127
    }
  ]
}
```

**On Failure** status: `401`

The request was not authenticated (entirely or correctly).

``` json
{
  "error": "Not Authorized"
}
```

### Get a Song

#### `GET /songs/:id`

Get the details about a single song that the authenticated user owns. _Right now, this includes no more than the endpoint to get all songs, but as we introduce sections to songs, this route will be updated to reflect this available data._

#### Format Request

No payload is required, but the song `id` must be present in the url.

#### Responses

**On Success** status: `200`

An object containing the details of a song, including their name, id, and music_url.

``` json
{
  "data": {
    "name": "Real Good Song",
    "music_url": "https://www.youtube.com/watch?v=nq4o7wLUVI4",
    "id": 123
  }
}
```

**On Failure** status: `401`

The request was not authenticated (entirely or correctly).

``` json
{
  "error": "Not Authorized"
}
```

**On Failure** status: `404`

The song requested does not exist for that user

``` json
{
  "error": "Sorry, we can't find that song."
}
```

### Update a Song

#### `PUT /songs/:id` `PATCH /songs/:id`

Update the details about a single song that the authenticated user owns.

#### Format Request

Include the song `id` in the url. Provide a json payload with the updated attributes of the song.

| key               | Required       | Type           |
| :-------------    | :------------- | :------------- |
| song              | yes            |                |
| song['name']      | no             | string         |
| song['music_url'] | no             | string         |

Example payload (in `application/json` format):

``` json
  "song": {
    "name": "Super Cool Guitar Solo"
  }
```

#### Responses

**On Success** status: `200`

An simple success indicator.

``` json
{
  "ok": true
}
```

**On Failure** status: `400`

The request was malformed.

``` json
{
  "error": "Malformed request! Please refer to the documentation and try again"
}
```

**On Failure** status: `401`

The request was not authenticated (entirely or correctly).

``` json
{
  "error": "Not Authorized"
}
```

**On Failure** status: `404`

The song requested does not exist for that user

``` json
{
  "error": "Sorry, we can't find that song."
}
```

### Delete a Song

#### `DELETE /songs/:id`

Delete a saved song.

#### Format Request

No payload is required, but the song `id` must be present in the url.

#### Responses

**On Success** status: `200`

An simple success indicator.

``` json
{
  "ok": true
}
```

**On Failure** status: `401`

The request was not authenticated (entirely or correctly).

``` json
{
  "error": "Not Authorized"
}
```

**On Failure** status: `404`

The song requested does not exist for that user

``` json
{
  "error": "Sorry, we can't find that song."
}
```
