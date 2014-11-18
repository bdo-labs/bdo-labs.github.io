---
title: api
description: REST-API for BDO Strategy
template: index.html
version: 0.0.1
date: 2014-11-11
collection: repos
---


<h1><i class="ion-planet"></i> API</h1>

The API's conform to a strict REST-structure, so their mostly interchangeable
by just replacing the resource-part, all the subtle differences should be well
documented.


Security
--------

All requests to the API should be over a TLS-connection using basic-auth.
It has the cost of sending your token upon each request, but it makes it
easier to test the API from the command-line etc.


Tracing & debugging
-------------------

The use of an `Accepts-header` and returning both an `Etag` and a unique
`Request-Id` will make debugging a lot easier, as you can trace it back and
redeem some context to the issue at hand.


Status codes
------------

Using all of the return-codes specified in the HTTP-protocol complicates the
work of creating a robust client. Thus, we only use a small sub-set.

  - 200 Success
  - 201 POST succeeded and completed synchronously
  - 202 Accepted, will be processed asynchronously
  - 206 GET succeeded, but only a partial response returned
  - 401 Unauthorized
  - 403 User is not authorized to access the resource
  - 422 Contained invalid parameters
  - 429 Too many requests
  - 500 Internal server error


Minimize path nesting
---------------------

Instead of long nested paths, it's better to identify the resource early. Doing
so avoids the problem of circular-dependencies and can make debugging more
trivial.

Good.

    /users/:login/followers

Bad.

    cards/:slug/indicators/:slug/owner/followers


Handling large responses
------------------------

To paginate results, use `Content-Range` headers with `..` as delimiter.
Example:

```http
Content-Range: updated_at 2015-01-01T00:00:00..2015-01-31T23:59:59
Next-Range: updated_at 2015-02-01T00:00:00..2015-02-31T23:59:59
```


Structured error-messages
-------------------------

Having a machine-readable `id`, a human-readable error-`message` and a resource
where you can find additional information will make the process of creating a
client, much easier.

```http
HTTP/1.1 429 Too Many Requests
```

```javascript
{
  "id": "rate_limit",
  "message": "Account reached its API rate limit.",
  "url": "https://docs.presti.ge/rate-limits"
}
```



#### Retrieve cards

Note that `/cards` is a short-hand for `/org/cards`.

```http
GET /cards?indicators=true
```

```javascript
[{
  "id": "23465b43532...",
  "title": "foretaksservice",
  "description": "fremtidens regnskapstjenester levert i dag",
  "created_at": "2015-01-01T12:00:00Z",
  "updated_at": "2015-01-01T12:00:00Z",
  "status": "good",
  "owner": {
    "id": "32bdd2b3...",
    "name": "Snorre Nævdal",
    "email": "snorre.naevdal@bdo.no",
    "foo": "bar"
  },
  "followers": [
    {
      "id": "8764ab4a9b4..."
    }
  ],
  "indicators": [
    {
      "id": "72542b234523b..."
      "category": "økonomi",
      "title": "omsetning",
      "direction": -1,
      "status": "warning",
      "description": "her kan det skrives tekst etter behov",
      "order": 1,
      "indicators": [
        {
          "id": "2345a23b5ab...",
          "frequency": "monthly",
          "status": "good",
          "direction": 1,
          "unit": "nok",
          "tags": ["foretaksservice"],
          "create_at": "2015-01-01T12:00:00Z",
          "updated_at": "2015-01-01T12:00:00Z",
          "owner": {
            "id": "32bdd2b3...",
            "groups": ["digitale tjenester","fest komité"],
            "name": "Snorre Nævdal",
            "email": "snorre.naevdal@bdo.no",
            "created_at": "2014-05-05T12:00:00Z",
            "updated_at": "2014-05-05T12:00:00Z"
          },
          "payload": {
            "id": "24643ba52b..."
          }
        }
      ]
    }
  ]
}]
```

#### Retrieve an indicator object

```http
GET /indicator/:{slug,id}?expand=owner
```

```javascript
{
  "id": "72542b234523b..."
  "category": "økonomi",
  "title": "omsetning",
  "direction": -1,
  "status": "warning",
  "description": "her kan det skrives tekst etter behov",
  "order": 1,
  "indicators": [
    {
      "id": "2345a23b5ab...",
      "frequency": "monthly",
      "status": "good",
      "direction": 1,
      "unit": "nok",
      "tags": ["foretaksservice"],
      "create_at": "2015-01-01T12:00:00Z",
      "updated_at": "2015-01-01T12:00:00Z",
      "owner": {
        "id": "32bdd2b3...",
        "groups": ["digitale tjenester","fest komité"],
        "name": "Snorre Nævdal",
        "email": "snorre.naevdal@bdo.no",
        "created_at": "2014-05-05T12:00:00Z",
        "updated_at": "2014-05-05T12:00:00Z"
      },
      "payload": {
        "id": "24643ba52b..."
      }
    }
  ]
}
```

#### Retrieve a list of tasks

```http
GET /task/:{slug,id}?expand=owner,assignee
```

#### Retrieve a list of all users.

```http
GET /users
```

```javascript
[
  {
    "id": "8764ab4a9b4...",
    "name": "Henrik Kjelsberg",
    "foo": "bar"
  }
]
```

#### Retrieve a single user-object.

```http
GET /users/:{login,id}
```

```javascript
{
  "id": "8764ab4a9b4...",
  "type": "User",
  "login": "hkjels",
  "created_at": "2014-10-10T12:00:00Z",
  "updated_at": "2015-01-01T12:00:00Z",
  "name": "Henrik Kjelsberg",
  "email": "henrik.kjelsberg@bdo.no",
  "role": "admin",
  "organization": "bdo",
  "following": [
    {
      "id": "0786ba078b6a..."
    }
  ]
  "followers": [
    {
      "id": "0786ba078b6a..."
    }
  ]
}
```

#### Retrieve your own user-object

```http
GET /user
```

#### Retrieve a list of all organizations.

```http
GET /orgs
```

```javascript
[
  {
    "id": "5234646265b46354b...",
    "name": "BDO AS",
    "foo": "bar"
  }
]
```

#### Retrieve a single organization-object.

```http
GET /orgs/:{slug,id}
```

```javascript
{
  "id": "5234646265b46354b...",
  "name": "BDO AS",
  "type": "Organization"
}
```

#### Retrieve your own organization

```http
GET /org
```

#### List public events

```http
GET /events
```

#### List organization events

```http
GET /org/:slug/events
```

#### List user events

```http
GET /users/:login/events
```

