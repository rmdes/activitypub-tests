ActivityPub Actor Tester
Actor URL
https://rmendes.net/activitypub/users/rick


Test https://rmendes.net/activitypub/users/rick
Test Results
✅ Actor Objects Must Have Properties `inbox` and `outbox`
Details

{
  "type": [
    "Assertion"
  ],
  "result": {
    "outcome": "passed",
    "source": []
  },
  "test": {
    "slug": "actor-objects-must-have-inbox-outbox-properties",
    "url": "https://socialweb.coop/activitypub/test-cases/actor-objects-must-have-inbox-outbox-properties",
    "description": "This rule checks whether a given Actor Object has the properties inbox and outbox.",
    "name": "Actor Objects Must Have Properties `inbox` and `outbox`",
    "uuid": "acaacb5f-8f7e-4f28-8d81-c7955070a767"
  },
  "input": {
    "actor": "{\"@context\":[\"https://www.w3.org/ns/activitystreams\",\"https://w3id.org/security/v1\",\"https://w3id.org/security/data-integrity/v1\",\"https://www.w3.org/ns/did/v1\",\"https://w3id.org/security/multikey/v1\",{\"alsoKnownAs\":{\"@id\":\"as:alsoKnownAs\",\"@type\":\"@id\"},\"manuallyApprovesFollowers\":\"as:manuallyApprovesFollowers\",\"movedTo\":{\"@id\":\"as:movedTo\",\"@type\":\"@id\"},\"toot\":\"http://joinmastodon.org/ns#\",\"Emoji\":\"toot:Emoji\",\"featured\":{\"@id\":\"toot:featured\",\"@type\":\"@id\"},\"featuredTags\":{\"@id\":\"toot:featuredTags\",\"@type\":\"@id\"},\"discoverable\":\"toot:discoverable\",\"suspended\":\"toot:suspended\",\"memorial\":\"toot:memorial\",\"indexable\":\"toot:indexable\",\"schema\":\"http://schema.org#\",\"PropertyValue\":\"schema:PropertyValue\",\"value\":\"schema:value\",\"misskey\":\"https://misskey-hub.net/ns#\",\"_misskey_followedMessage\":\"misskey:_misskey_followedMessage\",\"isCat\":\"misskey:isCat\"}],\"id\":\"https://rmendes.net/activitypub/users/rick\",\"type\":\"Person\",\"featured\":\"https://rmendes.net/activitypub/users/rick/featured\",\"featuredTags\":\"https://rmende…"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
✅ ActivityPub Servers Must Serve Objects in Response to an HTTP GET Request Accepting ActivityStreams 2.0 Media Type
Details
⚠️ inbox must be an OrderedCollection
Details
inbox property has a value whose type does not identify it as an OrderedCollection

{
  "type": [
    "Assertion"
  ],
  "result": {
    "type": "TestResult",
    "outcome": "failed",
    "info": "inbox property has a value whose type does not identify it as an OrderedCollection"
  },
  "test": {
    "slug": "inbox-must-be-an-orderedcollection",
    "url": "https://socialweb.coop/activitypub/test-cases/inbox-must-be-an-orderedcollection",
    "description": "This rule checks whether the inbox property of an object appears to be an OrderedCollection",
    "name": "inbox must be an OrderedCollection",
    "uuid": "5e94d155-ed4a-4d71-b797-d7c387736ecf"
  },
  "input": {
    "object": "{\"@context\":[\"https://www.w3.org/ns/activitystreams\",\"https://w3id.org/security/v1\",\"https://w3id.org/security/data-integrity/v1\",\"https://www.w3.org/ns/did/v1\",\"https://w3id.org/security/multikey/v1\",{\"alsoKnownAs\":{\"@id\":\"as:alsoKnownAs\",\"@type\":\"@id\"},\"manuallyApprovesFollowers\":\"as:manuallyApprovesFollowers\",\"movedTo\":{\"@id\":\"as:movedTo\",\"@type\":\"@id\"},\"toot\":\"http://joinmastodon.org/ns#\",\"Emoji\":\"toot:Emoji\",\"featured\":{\"@id\":\"toot:featured\",\"@type\":\"@id\"},\"featuredTags\":{\"@id\":\"toot:featuredTags\",\"@type\":\"@id\"},\"discoverable\":\"toot:discoverable\",\"suspended\":\"toot:suspended\",\"memorial\":\"toot:memorial\",\"indexable\":\"toot:indexable\",\"schema\":\"http://schema.org#\",\"PropertyValue\":\"schema:PropertyValue\",\"value\":\"schema:value\",\"misskey\":\"https://misskey-hub.net/ns#\",\"_misskey_followedMessage\":\"misskey:_misskey_followedMessage\",\"isCat\":\"misskey:isCat\"}],\"id\":\"https://rmendes.net/activitypub/users/rick\",\"type\":\"Person\",\"featured\":\"https://rmendes.net/activitypub/users/rick/featured\",\"featuredTags\":\"https://rmende…",
    "time": "T10S"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
⚠️ Outbox Servers handling activity submissions MUST return a 201 created HTTP status code
Details
outbox POST response status MUST be 201, but got 200

{
  "type": [
    "Assertion"
  ],
  "result": {
    "outcome": "failed",
    "info": "outbox POST response status MUST be 201, but got 200",
    "pointer": {
      "request": {
        "url": "https://rmendes.net/activitypub/users/rick/outbox"
      },
      "response": {
        "status": 200,
        "statusText": "",
        "body": "{\"type\":\"OrderedCollection\",\"id\":\"https://rmendes.net/activitypub/users/rick/outbox\",\"@context\":[\"ht"
      }
    }
  },
  "test": {
    "slug": "outbox-post-servers-must-return-a-201-created-http-code",
    "url": "https://socialweb.coop/activitypub/test-cases/outbox-post-servers-must-return-a-201-created-http-code",
    "description": "This test checks that an ActivityPub Outbox responds with a 201 status code when sent a POST request with an Activity submission.",
    "name": "Outbox Servers handling activity submissions MUST return a 201 created HTTP status code",
    "uuid": "723afcbb-118d-433e-8ab4-560ffca93582"
  },
  "input": {
    "outbox": "https://rmendes.net/activitypub/users/rick/outbox",
    "time": "T10S"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
✅ outbox must be an OrderedCollection
Details

{
  "type": [
    "Assertion"
  ],
  "result": {
    "type": "TestResult",
    "outcome": "passed"
  },
  "test": {
    "slug": "outbox-must-be-an-orderedcollection",
    "url": "https://socialweb.coop/activitypub/test-cases/outbox-must-be-an-orderedcollection",
    "description": "This rule checks whether the outbox property of an object appears to be an OrderedCollection",
    "name": "outbox must be an OrderedCollection",
    "uuid": "4af549f4-3797-4d99-a151-67c3d8feaa46"
  },
  "input": {
    "object": "{\"@context\":[\"https://www.w3.org/ns/activitystreams\",\"https://w3id.org/security/v1\",\"https://w3id.org/security/data-integrity/v1\",\"https://www.w3.org/ns/did/v1\",\"https://w3id.org/security/multikey/v1\",{\"alsoKnownAs\":{\"@id\":\"as:alsoKnownAs\",\"@type\":\"@id\"},\"manuallyApprovesFollowers\":\"as:manuallyApprovesFollowers\",\"movedTo\":{\"@id\":\"as:movedTo\",\"@type\":\"@id\"},\"toot\":\"http://joinmastodon.org/ns#\",\"Emoji\":\"toot:Emoji\",\"featured\":{\"@id\":\"toot:featured\",\"@type\":\"@id\"},\"featuredTags\":{\"@id\":\"toot:featuredTags\",\"@type\":\"@id\"},\"discoverable\":\"toot:discoverable\",\"suspended\":\"toot:suspended\",\"memorial\":\"toot:memorial\",\"indexable\":\"toot:indexable\",\"schema\":\"http://schema.org#\",\"PropertyValue\":\"schema:PropertyValue\",\"value\":\"schema:value\",\"misskey\":\"https://misskey-hub.net/ns#\",\"_misskey_followedMessage\":\"misskey:_misskey_followedMessage\",\"isCat\":\"misskey:isCat\"}],\"id\":\"https://rmendes.net/activitypub/users/rick\",\"type\":\"Person\",\"featured\":\"https://rmendes.net/activitypub/users/rick/featured\",\"featuredTags\":\"https://rmende…",
    "time": "T10S"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
✅ An ActivityPub Object `liked` Collection Must be a Collection
Details

{
  "type": [
    "Assertion"
  ],
  "result": {
    "outcome": "passed"
  },
  "test": {
    "slug": "liked-collection-must-be-a-collection",
    "url": "https://socialweb.coop/activitypub/test-cases/liked-collection-must-be-a-collection",
    "description": "tests whether an ActivityPub Object has a liked collection with an appropriate Collection type",
    "name": "An ActivityPub Object `liked` Collection Must be a Collection",
    "uuid": "018c3df2-d6d8-7f62-805b-b71a96cc6170"
  },
  "input": {
    "object": "{\"@context\":[\"https://www.w3.org/ns/activitystreams\",\"https://w3id.org/security/v1\",\"https://w3id.org/security/data-integrity/v1\",\"https://www.w3.org/ns/did/v1\",\"https://w3id.org/security/multikey/v1\",{\"alsoKnownAs\":{\"@id\":\"as:alsoKnownAs\",\"@type\":\"@id\"},\"manuallyApprovesFollowers\":\"as:manuallyApprovesFollowers\",\"movedTo\":{\"@id\":\"as:movedTo\",\"@type\":\"@id\"},\"toot\":\"http://joinmastodon.org/ns#\",\"Emoji\":\"toot:Emoji\",\"featured\":{\"@id\":\"toot:featured\",\"@type\":\"@id\"},\"featuredTags\":{\"@id\":\"toot:featuredTags\",\"@type\":\"@id\"},\"discoverable\":\"toot:discoverable\",\"suspended\":\"toot:suspended\",\"memorial\":\"toot:memorial\",\"indexable\":\"toot:indexable\",\"schema\":\"http://schema.org#\",\"PropertyValue\":\"schema:PropertyValue\",\"value\":\"schema:value\",\"misskey\":\"https://misskey-hub.net/ns#\",\"_misskey_followedMessage\":\"misskey:_misskey_followedMessage\",\"isCat\":\"misskey:isCat\"}],\"id\":\"https://rmendes.net/activitypub/users/rick\",\"type\":\"Person\",\"featured\":\"https://rmendes.net/activitypub/users/rick/featured\",\"featuredTags\":\"https://rmende…"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
✅ An ActivityPub Actor Object's `followers` Collection Must be a Collection
Details

{
  "type": [
    "Assertion"
  ],
  "result": {
    "outcome": "passed"
  },
  "test": {
    "slug": "followers-collection-must-be-a-collection",
    "url": "https://socialweb.coop/activitypub/test-cases/followers-collection-must-be-a-collection",
    "description": "tests whether an ActivityPub Object has a `followers`` collection with an appropriate Collection type",
    "name": "An ActivityPub Actor Object's `followers` Collection Must be a Collection",
    "uuid": "018c3e08-611f-7e56-9f45-2fe5e4877d4e"
  },
  "input": {
    "object": "{\"@context\":[\"https://www.w3.org/ns/activitystreams\",\"https://w3id.org/security/v1\",\"https://w3id.org/security/data-integrity/v1\",\"https://www.w3.org/ns/did/v1\",\"https://w3id.org/security/multikey/v1\",{\"alsoKnownAs\":{\"@id\":\"as:alsoKnownAs\",\"@type\":\"@id\"},\"manuallyApprovesFollowers\":\"as:manuallyApprovesFollowers\",\"movedTo\":{\"@id\":\"as:movedTo\",\"@type\":\"@id\"},\"toot\":\"http://joinmastodon.org/ns#\",\"Emoji\":\"toot:Emoji\",\"featured\":{\"@id\":\"toot:featured\",\"@type\":\"@id\"},\"featuredTags\":{\"@id\":\"toot:featuredTags\",\"@type\":\"@id\"},\"discoverable\":\"toot:discoverable\",\"suspended\":\"toot:suspended\",\"memorial\":\"toot:memorial\",\"indexable\":\"toot:indexable\",\"schema\":\"http://schema.org#\",\"PropertyValue\":\"schema:PropertyValue\",\"value\":\"schema:value\",\"misskey\":\"https://misskey-hub.net/ns#\",\"_misskey_followedMessage\":\"misskey:_misskey_followedMessage\",\"isCat\":\"misskey:isCat\"}],\"id\":\"https://rmendes.net/activitypub/users/rick\",\"type\":\"Person\",\"featured\":\"https://rmendes.net/activitypub/users/rick/featured\",\"featuredTags\":\"https://rmende…"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
✅ An ActivityPub Actor Object's `following` Collection Must be a Collection
Details

{
  "type": [
    "Assertion"
  ],
  "result": {
    "outcome": "passed"
  },
  "test": {
    "slug": "following-collection-must-be-a-collection",
    "url": "https://socialweb.coop/activitypub/test-cases/following-collection-must-be-a-collection",
    "description": "tests whether an ActivityPub Object has a `following`` collection with an appropriate Collection type",
    "name": "An ActivityPub Actor Object's `following` Collection Must be a Collection",
    "uuid": "018c3e17-a1bd-7040-8007-4cd3b9063288"
  },
  "input": {
    "object": "{\"@context\":[\"https://www.w3.org/ns/activitystreams\",\"https://w3id.org/security/v1\",\"https://w3id.org/security/data-integrity/v1\",\"https://www.w3.org/ns/did/v1\",\"https://w3id.org/security/multikey/v1\",{\"alsoKnownAs\":{\"@id\":\"as:alsoKnownAs\",\"@type\":\"@id\"},\"manuallyApprovesFollowers\":\"as:manuallyApprovesFollowers\",\"movedTo\":{\"@id\":\"as:movedTo\",\"@type\":\"@id\"},\"toot\":\"http://joinmastodon.org/ns#\",\"Emoji\":\"toot:Emoji\",\"featured\":{\"@id\":\"toot:featured\",\"@type\":\"@id\"},\"featuredTags\":{\"@id\":\"toot:featuredTags\",\"@type\":\"@id\"},\"discoverable\":\"toot:discoverable\",\"suspended\":\"toot:suspended\",\"memorial\":\"toot:memorial\",\"indexable\":\"toot:indexable\",\"schema\":\"http://schema.org#\",\"PropertyValue\":\"schema:PropertyValue\",\"value\":\"schema:value\",\"misskey\":\"https://misskey-hub.net/ns#\",\"_misskey_followedMessage\":\"misskey:_misskey_followedMessage\",\"isCat\":\"misskey:isCat\"}],\"id\":\"https://rmendes.net/activitypub/users/rick\",\"type\":\"Person\",\"featured\":\"https://rmendes.net/activitypub/users/rick/featured\",\"featuredTags\":\"https://rmende…"
  },
  "@context": [
    "https://socialweb.coop/ns/testing/context.json",
    "https://www.w3.org/ns/activitystreams"
  ]
}
Inapplicable Tests
These tests ran, but resulted in an inapplicable outcome.
An ActivityPub Object `likes` Collection Must be a Collection
object has no `likes` property
shares collection MUST be either an OrderedCollection or a Collection
inputs.object does not have a shares property to test
