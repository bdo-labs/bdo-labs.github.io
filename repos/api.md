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

```http
POST /service/AuthorizationService/token
```
The authorization service is a stand-alone API, loosely coupled to the rest of the user implementation. Notice that the content-type and payload type for getting a token is “x-www-form-urlencoded” so the payload body will be on form
```javascript
    grant_type=password&username="test"&password="testpassword"&client_id="kEfz/BDu"
```

If the username, password, and client id is recognized we received signed token on the response.

```javascript
{
    "access_token": "1dvcQiXhbfDW8ruqSFqqpZi8ZjiZRnDsZkBebZp4a62sGmrzLonP8a32m6qXnR7st668W0rmPgDoGVVjh8vwQltxG03R7LT0iDLX2drwdXIRIWeKp9q0IdZlyxDoGwcAEI4yr5Ew01U72ASPFp1KB5mcfqUKFWkNP-yO7OMRZgQNEzA7QS_QFrw8jhQqK33VajrEDW5GkWf4vUwt3iPYAY4-JHT-Mab4DiC1erbO3wKhlJua9r6MJrnEHEhHc-kZJuzsm_g_tdeoI1Kj2Qvfb7wXweQ",
    "token_type": "bearer",
    "expires_in": 86399,
    "refresh_token": "d595cd1d488045cca74bb2e3e5c63609",
    "as:client_id": "kEfz/BDu",
    "userName": "test",
    ".issued": "Sat, 24 Jan 2015 14:08:14 GMT",
    ".expires": "Sun, 25 Jan 2015 14:08:14 GMT"
}
```

In order to authenticate API calls the token the bearer token needs to be added in the requests Authorization header.

```javascript
Authorization : Bearer 1dvcQiXhbfDW8ruqSFqqpZi8ZjiZRnDsZkBebZp4a62sGmrzLonP8a32m6qXnR7st668W0rmPgDoGVVjh8vwQltxG03R7LT0iDLX2drwdXIRIWeKp9q0IdZlyxDoGwcAEI4yr5Ew01U72ASPFp1KB5mcfqUKFWkNP-yO7OMRZgQNEzA7QS_QFrw8jhQqK33VajrEDW5GkWf4vUwt3iPYAY4-JHT-Mab4DiC1erbO3wKhlJua9r6MJrnEHEhHc-kZJuzsm_g_tdeoI1Kj2Qvfb7wXweQ
```

For testing purposes a secured resource is made available, with restricted access. The username, password, client id and token provided in this section can be used to gain access to the resource.

```http
GET /secured/
```

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



#### Retrieve scorecards

```http
GET /scorecard/:{id}
```

```javascript
{
        "id": 1,
        "title": "Lederkortet",
        "description": null,
        "createdtime": "2014-12-11T18:03:44.95",
        "updatedtime": "2014-12-11T18:03:44.95",
        "status": "good",
        "owner": {
            "id": 5,
            "name": "eva",
            "email": "snna@bdo.no"
        },
        "categories": [
            {
                "id": 1,
                "name": "Medlemsnytte",
                "order": 1,
                "status": "good",
                "trend": "good",
                "indicators": [
                    {
                        "id": 1,
                        "title": "50 igangsatte boliger pr år",
                        "description": null,
                        "order": 0,
                        "frequency": "Monthly",
                        "direction": "Equal",
                        "unit": "%",
                        "value": 10,
                        "goal": 15,
                        "status": "good",
                        "trend": "good"
                    },
                    {
                        "id": 2,
                        "title": "Nettovekst boliger til forvaltning",
                        "description": null,
                        "order": 0,
                        "frequency": "Monthly",
                        "direction": "Equal",
                        "unit": "",
                        "value": 10,
                        "goal": 15,
                        "status": "good",
                        "trend": "good"
                    }
                ]
            }
        ],
        "events": [
          {
            "$id": "218",
            "id": 174,
            "createddate": "2015-01-22T15:49:54.157",
            "createdby": {
                "$id": "219",
                "id": 1,
                "name": "system",
                "email": "snna@bdo.no",
                "imageurl": null,
                "events": null
            },
            "type": 1,
            "title": "50 igangsatte boliger pr år ble opprettet.",
                "details": "laoreet lorem sit sed nonummy dolor diam ipsum elit"
            }
        ]
    },
    {
        "id": 2,
        "title": "Styrekortet",
        "description": null,
        "createdtime": "2014-12-11T18:03:44.983",
        "updatedtime": "2014-12-11T18:03:44.983",
        "status": "good",
        "owner": {
            "id": 5,
            "name": "eva",
            "email": "snna@bdo.no"
        },
        "categories": [
```

#### Retrieve an indicator object

```http
GET /indicator/id
```

```javascript
{
  "id": 4,
  "title": "Oppslag i media",
  "description": null,
  "order": 0,
  "frequency": "Monthly",
  "direction": "Equal",
  "unit": "",
  "value": 631889,
  "goal": 990694,
  "status": "bad",
  "trend": "down"
  "values": 
  [
    {
        "$id": "2",
        "date": "2014-01-01T00:00:00",
        "value": 1371
    },
    {
        "$id": "3",
        "date": "2014-02-01T00:00:00",
        "value": 4959
    },
    {
        "$id": "4",
        "date": "2014-03-01T00:00:00",
        "value": 4959
    }
  ],
  "targets": 
  [
    {
        "$id": "110",
        "date": "2014-01-01T00:00:00",
        "value": 645
    },
    {
        "$id": "111",
        "date": "2014-02-01T00:00:00",
        "value": 4950
    },
    {
        "$id": "112",
        "date": "2014-03-01T00:00:00",
        "value": 4950
    },
    {
        "$id": "113",
        "date": "2014-04-01T00:00:00",
        "value": 9256
    }
  ],
  "events": 
  [
    {
      "$id": "218",
      "id": 174,
      "createddate": "2015-01-22T15:49:54.157",
      "createdby": {
          "$id": "219",
          "id": 1,
          "name": "system",
          "email": "snna@bdo.no",
          "imageurl": null,
          "events": null
      },
      "type": 1,
      "title": "50 igangsatte boliger pr år ble opprettet.",
          "details": "laoreet lorem sit sed nonummy dolor diam ipsum elit"
      }
  ]
}

```

#### Retrieve a list of tasks

```http
GET /task/:{id}
```

```javascript
[
    {
        "$id": "1",
        "id": 17,
        "title": "ut ut consectetuer dolor ipsum magna. elit diam ipsum elit dolore nibh. ",
        "description": "ut ut consectetuer dolor ipsum magna",
        "deadline": "2014-12-11T22:12:19.847",
        "status": "Ikke påbegynt",
        "priority": "Lav",
        "tagstring": "50 igangsatte boliger pr år",
        "createdtime": "2014-12-11T22:12:19.927",
        "updatedtime": "2014-12-11T22:12:19.927",
        "createdby": null,
        "updatedby": null,
        "events": 
        [
          {
            "$id": "218",
            "id": 174,
            "createddate": "2015-01-22T15:49:54.157",
            "createdby": {
                "$id": "219",
                "id": 1,
                "name": "system",
                "email": "snna@bdo.no",
                "imageurl": null,
                "events": null
            },
            "type": 1,
            "title": "50 igangsatte boliger pr år ble opprettet.",
                "details": "laoreet lorem sit sed nonummy dolor diam ipsum elit"
            }
        ]
    },
    {
        "$id": "2",
        "id": 18,
        "title": "dolore adipiscing euismod laoreet sed elit. laoreet euismod adipiscing ut aliquam dolor. ",
        "description": "dolore adipiscing euismod laoreet sed elit laoreet euismod adipiscing ut aliquam dolor magna erat aliquam dolor euismod consectetuer elit euismod dolor aliquam ut adipiscing sit diam diam. amet magna nibh magna amet elit diam euismod euismod elit magna",
        "deadline": "2014-12-11T22:12:19.847",
        "status": "Påbegynt i rute",
        "priority": "Lav",
        "tagstring": "50 igangsatte boliger pr år",
        "createdtime": "2014-12-11T22:12:20.087",
        "updatedtime": "2014-12-11T22:12:20.087",
        "createdby": 
          {
            "$id": "219",
            "id": 1,
            "name": "system",
            "email": "snna@bdo.no",
            "imageurl": null,
            "events": null
          },
        "updatedby": null,
        "events": 
        [
          {
            "$id": "218",
            "id": 174,
            "createddate": "2015-01-22T15:49:54.157",
            "createdby": {
                "$id": "219",
                "id": 1,
                "name": "system",
                "email": "snna@bdo.no",
                "imageurl": null,
                "events": null
            },
            "type": 1,
            "title": "50 igangsatte boliger pr år ble opprettet.",
                "details": "laoreet lorem sit sed nonummy dolor diam ipsum elit"
            }
        ]
    },

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

