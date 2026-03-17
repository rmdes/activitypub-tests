---
source: "https://activitypub-testing.socialweb.coop/test-cases/"
language: "en"
word_count: 14274
---

## ActivityPub Test Cases

- [Actor Objects Must Have Properties inbox and outbox](https://activitypub-testing.socialweb.coop/test-cases/actor-objects-must-have-inbox-outbox-properties)
	```
	{
	  "description": "This rule checks whether a given Actor Object has the properties inbox and outbox.",
	  "failedCases": [
	    {
	      "name": "actor without required properties",
	      "input": {
	        "actor": {
	          "type": "Person"
	        }
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "inapplicableCases": [
	    {
	      "name": "null actor",
	      "input": {
	        "actor": null
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "empty object actor",
	      "input": {
	        "actor": {}
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "actor with input actor not json",
	      "input": {
	        "actor": "2b292jb"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "input": {
	    "actor": {
	      "help": "the Actor Object to be tested for presence of required properties",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    }
	  },
	  "markdown": "---\ntype:\n- TestCase\nstatus: draft\nname: Actor Objects must have properties inbox and outbox\ndescription: |\n  This rule checks whether a given Actor Object has the properties inbox and outbox.\nuuid: acaacb5f-8f7e-4f28-8d81-c7955070a767\nattributedTo:\n- https://bengo.is\n\n\"@context\":\n- TestCase:\n    \"@id\": http://www.w3.org/ns/earl#:TestCase\n  type:\n    \"@type\": \"@id\"\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n    latestVersion: https://socialweb.coop/activitypub/test-cases/actor-objects-must-have-inbox-outbox-properties/\n\n---\n\n# Actor Objects Must Have Properties inbox and outbox\n\n## Background\n\n[ActivityPub][activitypub] [§4.1 Actor Objects](https://www.w3.org/TR/activitypub/#actor-objects):\n> Actor objects MUST have... the following properties: inbox... outbox...\n\n## About this Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub Object is in partial conformance with the following behaviors required by [ActivityPub][activitypub].\n\n* Actor Objects must have inbox property [cc3f730a-37a9-4af9-948f-7c8a0b7f6c41](https://socialweb.coop/activitypub/behaviors/cc3f730a-37a9-4af9-948f-7c8a0b7f6c41/)\n* Actor Objects must have outbox property [b8647b47-defb-483c-b468-8602d1124169](https://socialweb.coop/activitypub/behaviors/b8647b47-defb-483c-b468-8602d1124169/)\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:acaacb5f-8f7e-4f28-8d81-c7955070a767\`.\n\n## Test Subject\n\nThe subject of this test is any data claiming to conform to the specification of an ActivityPub Actor Object.\n\nThis test is *not* directly applicable to an ActivityPub Server.\nAn ActivityPub Server serves 0 or more Actor Objects.\nAn ActivityPub Server for a big community might serve hundreds of ActivityPub Actor Objects.\nAn ActivityPub Server for a single human may serve only that person's ActivityPub Actor Object.\n\nThis test applies to Actor *Objects*, but *not* all Actor Object are addressable by an HTTPS URL.\nThe URI that addresses an Actor Object is not the same as the Actor Object.\nA given URL may resolve to different Actor Objects in different contexts, and a given Actor Object may not be universally addressable across context by any one URL.\n\n## Inputs\n\nThis test requires the following [inputs](https://www.w3.org/TR/act-rules-format/#input):\n\n* \`actor\` - the actor object that should be tested\n    * type: binary data\n    * constraints\n        * will be interpreted as JSON. If not parseable as JSON, the test result MUST be \`inapplicable\`.\n\n## Applicability\n\nThis test applies directly to the \`actor\` input.\n\nIf \`actor\` is not an Actor Object, the outcome MUST be \`inapplicable\`.\n\n* see assumption \"How to Determine Whether Input is an Actor Object\" below\n\nIf \`actor\` JSON does not have a \`type\` property, the outcome MUST be \`inapplicable\`.\n\n### Test Targets\n\n* \`inbox\` - the inbox property (or lack thereof) in the input \`actor\` JSON object\n* \`outbox\` - the outbox property (or lack thereof) in the input \`actor\` JSON object\n\n## Expectations\n\n1. \`actor\` JSON has a property whose name is \`inbox\`.\n    * If there is no \`inbox\` property, the outcome is \`failed\` for test target \`inbox\`\n\n2. \`actor\` JSON has a property whose name is \`outbox\`\n    * If there is no \`outbox\` property, the outcome is \`failed\` for test target \`outbox\`\n\n## Assumptions\n\n### 1. How to Determine Whether Input is an Actor Object\n\nFor the purposes of determining whether the input \`actor\` is in fact an actor object and whether this test is applicable to that input,\nthis test assumes that a valid way of determining whether the input is an Actor Object is:\n\n* the input is valid JSON\n* the input, once parsed as JSON\n    * has a \`type\` property\n    * has a \`type\` property value that is either a string or array of strings\n    * one of those \`type\` value strings is one of \`Application\`, \`Group\`, \`Organization\`, \`Person\`, \`Service\`\n        * rationale:\n            * [ActivityPub 4.3 Actors](https://www.w3.org/TR/activitystreams-core/#actors):\n              > The Activity Vocabulary provides the normative definition of five specific types of Actors: Application | Group | Organization | Person | Service.\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n\n### 2. No property value expectations\n\nThis test does not assert any expectations about the *values* of these required properties. The requirement being tested only requires that they are present.\n\nFor test cases about the values of these properties, see:\n\n* [inbox-must-be-an-orderedcollection](https://socialweb.coop/activitypub/test-cases/inbox-must-be-an-orderedcollection/)\n* [outbox-must-be-an-orderedcollection](https://socialweb.coop/activitypub/test-cases/outbox-must-be-an-orderedcollection/)\n\n## Test Cases\n\nThese are test cases for this test case, and can be used to verify that an implementation of this test case specification will be [consistent](https://www.w3.org/WAI/standards-guidelines/act/implementations/#understanding-act-consistency) with other implementations.\n\n### simple valid actor\n\ninputs\n\n* \`actor\`\n\n  \`\`\`json\n    {\n      \"type\": \"Person\",\n      \"inbox\": \"https://bengo.is/inbox\",\n      \"outbox\": \"https://bengo.is/outbox\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`: present\n    * outcome: \`passed\`\n* \`outbox\`: present\n    * outcome: \`passed\`\n\n### missing inbox\n\ninputs\n\n* \`actor\`\n\n  \`\`\`json\n    {\n      \"type\": \"Person\",\n      \"outbox\": \"https://bengo.is/outbox\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`: not present\n    * outcome: \`failed\`\n* \`outbox\`: present\n    * outcome: \`passed\`\n\n### missing outbox\n\ninputs\n\n* \`actor\`\n\n  \`\`\`json\n    {\n      \"type\": \"Person\",\n      \"inbox\": \"https://bengo.is/inbox\",\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`: present\n    * outcome: \`passed\`\n* \`outbox\`: not present\n    * outcome: \`failed\`\n\n### actor type, but no inbox nor outbox\n\ninputs\n\n* \`actor\`\n\n  \`\`\`json\n    {\n      \"type\": \"Person\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`: not present\n    * outcome: \`failed\`\n* \`outbox\`: not present\n    * outcome: \`failed\`\n\n### not json\n\ninputs\n\n* \`actor\`\n\n  \`\`\`text\n  abc\n  \`\`\`\n\ntest targets\n\n* \`inbox\`: not present\n    * outcome: \`inapplicable\`\n* \`outbox\`: not present\n    * outcome: \`inapplicable\`\n\n### json with no properties\n\ninputs\n\n* \`actor\`\n\n    \`\`\`json\n    {}\n    \`\`\`\n\ntest targets\n\n* \`inbox\`: not present\n    * outcome: \`inapplicable\`\n        * because it is not an Actor Object\n* \`outbox\`: not present\n    * outcome: \`inapplicable\`\n        * because it is not an Actor Object\n\n### actor with no other properties\n\ninputs\n\n* \`actor\`\n\n  \`\`\`json\n  {\n    \"type\": \"Person\"\n  }\n  \`\`\`\n\ntest targets\n\n* \`inbox\`: not present\n    * outcome: \`failed\`\n        * rationale: the object is an Actor, but is missing the required property\n* \`outbox\`: not present\n    * outcome: \`failed\`\n        * rationale: the object is an Actor, but is missing the required property\n\n### object with \`inbox\` but no \`type\`\n\ninputs\n\n* \`actor\`\n\n  \`\`\`json\n  {\n    \"inbox\": \"https://bengo.is/inbox\"\n  }\n  \`\`\`\n\ntest targets\n\n* \`inbox\`: present\n    * outcome: \`inapplicable\`\n        * because it is not an Actor Object. There is no \`type\` property indicating this is an Actor Object.\n* \`outbox\`: not present\n    * outcome: \`inapplicable\`\n        * because it is not an Actor Object. There is no \`type\` property indicating this is an Actor Object.\n\n## Glossary\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject.\nAn outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping\n\n* [ActivityPub requirement cc3f730a-37a9-4af9-948f-7c8a0b7f6c41](https://socialweb.coop/activitypub/behaviors/cc3f730a-37a9-4af9-948f-7c8a0b7f6c41/) - actor objects must have an inbox property\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when test target \`inbox\` has outcome \`passed\`, requirement is satisfied\n        * when test target \`inbox\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`inbox\` has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n* [ActivityPub requirement b8647b47-defb-483c-b468-8602d1124169](https://socialweb.coop/activitypub/behaviors/b8647b47-defb-483c-b468-8602d1124169/) - actor objects must have an outbox property\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping for test target \`outbox\`\n        * when test target \`outbox\` has outcome \`passed\`, requirement is satisfied\n        * when test target \`outbox\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`outbox\` has outcome inapplicable, further testing is needed to determine requirement satisfaction\n\n## Change Log\n\n* 2023-11-03T03:41:20.725Z - first draft\n* 2023-12-29T20:48:45.838Z - update test cases with consistent formatting, headings, and fix some mistakes\n\n## Issues List\n",
	  "applicability": "This test applies directly to the \`actor\` input.\nIf \`actor\` is not an Actor Object, the outcome MUST be \`inapplicable\`.\n* see assumption \"How to Determine Whether Input is an Actor Object\" below\nIf \`actor\` JSON does not have a \`type\` property, the outcome MUST be \`inapplicable\`.\n### Test Targets\n* \`inbox\` - the inbox property (or lack thereof) in the input \`actor\` JSON object\n* \`outbox\` - the outbox property (or lack thereof) in the input \`actor\` JSON object\n",
	  "assumptions": "### 1. How to Determine Whether Input is an Actor Object\nFor the purposes of determining whether the input \`actor\` is in fact an actor object and whether this test is applicable to that input,\nthis test assumes that a valid way of determining whether the input is an Actor Object is:\n* the input is valid JSON\n* the input, once parsed as JSON\n    * has a \`type\` property\n    * has a \`type\` property value that is either a string or array of strings\n    * one of those \`type\` value strings is one of \`Application\`, \`Group\`, \`Organization\`, \`Person\`, \`Service\`\n        * rationale:\n",
	  "expectations": "1. \`actor\` JSON has a property whose name is \`inbox\`.\n    * If there is no \`inbox\` property, the outcome is \`failed\` for test target \`inbox\`\n2. \`actor\` JSON has a property whose name is \`outbox\`\n    * If there is no \`outbox\` property, the outcome is \`failed\` for test target \`outbox\`\n",
	  "name": "Actor Objects Must Have Properties inbox and outbox",
	  "passedCases": [
	    {
	      "name": "simple valid actor",
	      "input": {
	        "actor": {
	          "type": "Person",
	          "inbox": "https://bengo.is/inbox",
	          "outbox": "https://bengo.is/outbox"
	        }
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "slug": "actor-objects-must-have-inbox-outbox-properties",
	  "uuid": "acaacb5f-8f7e-4f28-8d81-c7955070a767",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:cc3f730a-37a9-4af9-948f-7c8a0b7f6c41",
	      "url": "https://socialweb.coop/activitypub/behaviors/cc3f730a-37a9-4af9-948f-7c8a0b7f6c41/"
	    },
	    {
	      "id": "urn:uuid:b8647b47-defb-483c-b468-8602d1124169",
	      "url": "https://socialweb.coop/activitypub/behaviors/b8647b47-defb-483c-b468-8602d1124169/"
	    }
	  ]
	}
	```
- [ActivityPub Servers Must Serve Objects in Response to an HTTP GET Request Accepting ActivityStreams 2.0 Media Type](https://activitypub-testing.socialweb.coop/test-cases/actor-must-serve-as2-object-to-get)
	```
	{
	  "description": "This rule checks that URLs of ActivityPub objects can be resolved to a representation with well-known media type for further processing.",
	  "expectations": "* \`response\` body is parseable as JSON\n* \`response\` body parsed JSON is a JSON Object\n* \`response\` body must be an \"ActivityStreams object representation\"\n",
	  "assumptions": "",
	  "applicability": "This test applies to a server hosting the ActivityPub Object identified by input \`id\`.\nIf input \`id\` is not a URI, outcome is \`inapplicable\`.\nIf input \`id\` URI scheme is not \`https\` or \`http\`, outcome is \`inapplicable\`. (This test may be revised later to handle other URI schemes).\nIf input \`time\` is not parseable as an RFC3339 \`dur-time\`, outcome is \`inapplicable\`.\n### Test Targets\n* \`response\` - the HTTP response that is the result of retrieving the ActivityPub Object identified by input \`id\`.\n    * how to derive \`response\` from inputs\n    1. start a timer with duration from input \`time\`. If the timer reaches zero before this derivation is complete, the whole test outcome is \`inapplicable\` because we weren't able to determine the \`response\` test target within the required time.\n    2. let \`request\` be a new HTTP Request whose URI is input \`id\`\n    3. add an http request header to \`request\` whose name is \`Accept\` and whose value is \`application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"\`\n    4. if input \`authorization\` was provided, add an http request header to \`request\` whose name is \`Authorization\` and whose value is input \`authorization\`\n    5. send the HTTP request and await a response\n    6. assign the HTTP response to the \`response\` test target\n",
	  "failedCases": [
	    {
	      "name": "nginx 404 response body",
	      "input": {
	        "id": "https://bengo.is/404",
	        "time": "T1M"
	      },
	      "result": {
	        "outcome": "failed"
	      },
	      "targets": {
	        "response": {
	          "httpVersion": "2.0",
	          "statusCodeValue": "404",
	          "headers": [
	            [
	              "content-type",
	              "text/html; charset=UTF-8"
	            ],
	            [
	              "content-length",
	              "153"
	            ]
	          ],
	          "body": "\n      \n      404 Not Found\n      \n      404 Not Found\n      nginx/1.25.2\n      \n          \n      "
	        }
	      }
	    }
	  ],
	  "inapplicableCases": [
	    {
	      "name": "non-URI input id",
	      "input": {
	        "id": "bafybeib5mvfjatmpswc3jnh7ydz4zxe25cm63xp6aafpg3j2awakf63qma",
	        "time": "T1M"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "non-RFC3339-duration input time",
	      "input": {
	        "id": "https://bengo.is/actor.json",
	        "time": "5 minutes"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "input": {
	    "id": {
	      "help": "identifier of an ActivityPub Object hosted at an ActivityPub Server",
	      "type": "xsd:anyUri",
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ],
	      "required": true
	    },
	    "authorization": {
	      "help": "proof of authorization to retrieve the object identified by input \`id\`"
	    },
	    "time": {
	      "help": "amount of time allowed to run test. This is meant to configure the limit for how long this test will wait for network requests. MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)",
	      "required": true,
	      "type": [
	        "rfc3339:dur-time",
	        "TimeLimit"
	      ]
	    }
	  },
	  "markdown": "---\n\nuuid: e7ee491d-88d7-4e67-80c8-f74781bb247c\ntype:\n- TestCase\n- ConformanceTestingRule\nruleType: atomic\nname: |\n  ActivityPub server serves an object in response to GET request for AS2 media type\ndescription: |\n  This rule checks that URLs of ActivityPub objects can be resolved to a representation with well-known media type for further processing.\nrequirementReference:\n- id: urn:uuid:00330762-59a2-4072-8d93-87ee4c30411c\n  url: https://socialweb.coop/activitypub/behaviors/08549639-2888-4ee2-a320-97fc7ee32e00/\ninputs:\n- name: URL of AS2 Object served by an ActivityPub Server\n  type: URL\n\n# https://www.w3.org/QA/WG/2005/01/test-faq#review\n# *submitted, accepted, reviewed*, *returned for revision*, or *rejected*\ntestCaseState: submitted\n\neleventyComputed:\n  title: \"{{ name }}\"\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# ActivityPub Servers Must Serve Objects in Response to an HTTP GET Request Accepting ActivityStreams 2.0 Media Type\n\n## Background\n\n[ActivityPub][activitypub] [§3.2 Retrieving Objects](https://www.w3.org/TR/activitypub/#retrieving-objects):\n> Servers... MUST present the ActivityStreams object representation in response to \`application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"\`\n\n## About This Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub Object is in partial conformance with the following behaviors required by [ActivityPub][activitypub].\n\n* [requirement 08549639-2888-4ee2-a320-97fc7ee32e00](https://socialweb.coop/activitypub/behaviors/08549639-2888-4ee2-a320-97fc7ee32e00/) - ActivityPub server must present object in response to GET request with AS2 Accept Header\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:e7ee491d-88d7-4e67-80c8-f74781bb247c\`.\n\n## Test Subject\n\nThe subject of this test is an ActivityPub Server.\n\nActivityPub Servers host ActivityPub Objects and are responsible for serving them to clients that request a representation of them.\n\nThe Test Subject can be identified by a URI for an ActivityPub Object. The ActivityPub Object can be requested via HTTP, and the ActivityPub Server is the system that is expected to respond to the HTTP request.\n\n## Inputs\n\nThis test requires the following [inputs](https://www.w3.org/TR/act-rules-format/#input):\n\n1. \`id\` - identifier of an ActivityPub Object hosted at an ActivityPub Server\n\n    * required: yes\n    * type: binary\n        * constraints\n            * MUST be a URI, i.e. an [ActivityPub Object Identifier](https://www.w3.org/TR/activitypub/#obj-id) that is not \`null\`\n\n2. \`authorization\` - proof of authorization to retrieve the object identified by input \`id\`\n\n    * required: no\n        * if this input is omitted, no \`Authorization\` will be provided in the HTTP request send by this test\n    * type: binary\n        * constraints\n            * If present, this should be valid as the value of an HTTP \`Authorization\` header\n\n3. \`time\` - amount of time allowed to run test. This is meant to configure the limit for how long this test will wait for network requests.\n\n    * required: yes\n    * example: \`T0.0021S\`\n    * type: binary\n        * constraints\n            * MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)\n\n## Applicability\n\nThis test applies to a server hosting the ActivityPub Object identified by input \`id\`.\n\nIf input \`id\` is not a URI, outcome is \`inapplicable\`.\n\nIf input \`id\` URI scheme is not \`https\` or \`http\`, outcome is \`inapplicable\`. (This test may be revised later to handle other URI schemes).\n\nIf input \`time\` is not parseable as an RFC3339 \`dur-time\`, outcome is \`inapplicable\`.\n\n### Test Targets\n\n* \`response\` - the HTTP response that is the result of retrieving the ActivityPub Object identified by input \`id\`.\n    * how to derive \`response\` from inputs\n    1. start a timer with duration from input \`time\`. If the timer reaches zero before this derivation is complete, the whole test outcome is \`inapplicable\` because we weren't able to determine the \`response\` test target within the required time.\n    2. let \`request\` be a new HTTP Request whose URI is input \`id\`\n    3. add an http request header to \`request\` whose name is \`Accept\` and whose value is \`application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"\`\n    4. if input \`authorization\` was provided, add an http request header to \`request\` whose name is \`Authorization\` and whose value is input \`authorization\`\n    5. send the HTTP request and await a response\n    6. assign the HTTP response to the \`response\` test target\n\n## Expectations\n\n* \`response\` body is parseable as JSON\n* \`response\` body parsed JSON is a JSON Object\n* \`response\` body must be an \"ActivityStreams object representation\"\n    * see issue [AP-ec50](#AP-ec50) below\n\n## Assumptions\n\n## Implementation Considerations\n\nThough the spec only *requires* serving the object in response to this \`Accept\` header value, servers seeking to interop widely may also want to serve the same object in response to Accept header values like:\n\n* \`application/ld+json\` (but without the \`profile=\` parameter)\n* \`application/activity+json\`\n* \`application/json\`\n\n## Test Cases\n\nThese are test cases for this test itself.\n\n### simple passed case\n\noutcome: \`passed\`\n\ninputs\n\n* \`id\`: \`https://bengo.is/actor.json\`\n* \`time\`: \`T1M\`\n\ntest targets\n\n* \`response\`:\n\n    \`\`\`http\n    HTTP/2 200 \n    content-type: application/json\n    content-length: 484\n\n    {\n      \"@context\": [\n        \"https://www.w3.org/ns/activitystreams\",\n        \"https://w3id.org/security/v1\"\n      ],\n      \"id\": \"https://bengo.is/\",\n      \"type\": \"Person\",\n      \"preferredUsername\": \"bengo\",\n      \"name\": \"bengo\",\n      \"url\": \"https://bengo.is/\",\n      \"inbox\": \"https://mastodon.social/users/bengo/inbox\",\n      \"attachments\": [\n        {\n          \"type\": \"PropertyValue\",\n          \"name\": \"Website\",\n          \"value\": \"https://bengo.is\"\n        }\n      ],\n      \"outbox\": \"https://bengo.is/activitypub/actors/bengo/outbox.json\"\n    }\n    \`\`\`\n\n    * outcome: \`passed\`\n\n### nginx 404 response body\n\noutcome: \`failed\`\n\n* rationale: test target \`response\` does not meet expectation of containing an ActivityPub Object representation in the response body\n\ninputs\n\n* \`id\`: \`https://bengo.is/404\`\n* \`time\`: \`T1M\`\n\ntest targets\n\n* \`response\`:\n\n  \`\`\`http\n  HTTP/2 404 \n  content-type: text/html; charset=UTF-8\n  content-length: 153\n  \n  \n  404 Not Found\n  \n  404 Not Found\n  nginx/1.25.2\n  \n  \n  \`\`\`\n\n    * outcome: \`failed\`\n\n### non-URI input \`id\`\n\noutcome: \`inapplicable\`\n\n* rationale: input \`id\` is not a URI\n\ninputs\n\n* \`id\`: \`bafybeib5mvfjatmpswc3jnh7ydz4zxe25cm63xp6aafpg3j2awakf63qma\`\n* \`time\`: \`T1M\`\n\ntest targets\n\n* \`response\` - undefined\n    * irrelevant because \`id\` does not meet syntax requirements\n\n### non-RFC3339-duration input \`time\`\n\noutcome: \`inapplicable\`\n\n* rationale: input \`time\` does not meet syntax requirements\n\ninputs\n\n* \`id\`: \`https://bengo.is/actor.json\`\n* \`time\`: \`5 minutes\`\n\ntest targets\n\n* \`response\` - undefined\n    * irrelevant because \`time\` input is malformed regardless of resolved \`resposne\`\n\n## Glossary\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping\n\n* [ActivityPub requirement 08549639-2888-4ee2-a320-97fc7ee32e00](https://socialweb.coop/activitypub/behaviors/08549639-2888-4ee2-a320-97fc7ee32e00/) - ActivityPub server must present object in response to GET request with AS2 Accept Header\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when test target \`response\` has outcome \`passed\`, requirement is satisfied\n        * when test target \`response\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`response\` has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Change Log\n\n* (~) 2023-10-15T00:00:00Z - sketch as first test case\n* 2023-11-07T21:07:59.214Z - update to be internally consistent and a good first draft\n* 2023-12-29T21:08:32.432Z - clean up test case formatting\n\n## Issues List\n\n* AP-ec50: clarify how to verify response body is an \"ActivityStreams object representation\"\n* When rendered to HTML and [published here](https://socialweb.coop/activitypub/test-cases/actor-must-serve-as2-object-to-get/#simple-passed-case), the \`response\` test targets HTTP response syntax highlighting separates the HTTP headers from the response body. This is a quirk of the rendering process.\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n",
	  "name": "ActivityPub Servers Must Serve Objects in Response to an HTTP GET Request Accepting ActivityStreams 2.0 Media Type",
	  "passedCases": [
	    {
	      "name": "simple passed case",
	      "input": {
	        "id": "https://bengo.is/actor.json",
	        "time": "T1M"
	      },
	      "result": {
	        "outcome": "passed"
	      },
	      "targets": {
	        "response": {
	          "httpVersion": "2",
	          "statusCodeValue": "200",
	          "headers": [
	            [
	              "content-type",
	              "application/json"
	            ],
	            [
	              "content-length",
	              "404"
	            ]
	          ],
	          "body": "\n      {\n        \"@context\": [\n          \"https://www.w3.org/ns/activitystreams\",\n          \"https://w3id.org/security/v1\"\n        ],\n        \"id\": \"https://bengo.is/\",\n        \"type\": \"Person\",\n        \"preferredUsername\": \"bengo\",\n        \"name\": \"bengo\",\n        \"url\": \"https://bengo.is/\",\n        \"inbox\": \"https://mastodon.social/users/bengo/inbox\",\n        \"attachments\": [\n          {\n            \"type\": \"PropertyValue\",\n            \"name\": \"Website\",\n            \"value\": \"https://bengo.is\"\n          }\n        ],\n        \"outbox\": \"https://bengo.is/activitypub/actors/bengo/outbox.json\"\n      }\n      "
	        }
	      }
	    }
	  ],
	  "slug": "actor-must-serve-as2-object-to-get",
	  "uuid": "e7ee491d-88d7-4e67-80c8-f74781bb247c",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:08549639-2888-4ee2-a320-97fc7ee32e00",
	      "url": "https://socialweb.coop/activitypub/behaviors/08549639-2888-4ee2-a320-97fc7ee32e00/"
	    }
	  ]
	}
	```
- [inbox must be an OrderedCollection](https://activitypub-testing.socialweb.coop/test-cases/inbox-must-be-an-orderedcollection)
	```
	{
	  "description": "This rule checks whether the inbox property of an object appears to be an OrderedCollection",
	  "failedCases": [
	    {
	      "name": "test case when the value of the inbox property is null",
	      "input": {
	        "object": "{\"inbox\":null}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "test case when inbox is an object without type OrderedCollection",
	      "input": {
	        "object": "{\"inbox\":{\"type\":[\"Person\"]}}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "inputs.object has inbox url to a non-collection",
	      "input": {
	        "authorization": "foo",
	        "object": "{\"inbox\":\"https://bengo.is/actor.json\"}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "inapplicableCases": [
	    {
	      "name": "test case when the inbox property is missing",
	      "input": {
	        "object": "{}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "test case where the value of inputs.object is not JSON",
	      "input": {
	        "object": "\u0000x123abc_intentionallyNotJson"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "test case where the value of of the inbox property is an array of length 2",
	      "input": {
	        "authorization": "",
	        "object": "{\"inbox\":[\"https://example.com\",\"https://example.com\"]}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "test case where inbox property value is a URL that 404s when fetched",
	      "input": {
	        "object": {
	          "inbox": "https://mastodon.social/users/bengo/inbox"
	        }
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "inputs.object is null",
	      "input": {
	        "object": "null"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "inputs.object is a number",
	      "input": {
	        "object": "123"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "input": {
	    "object": {
	      "help": "the object whose \`inbox\` property will be tested",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    },
	    "time": {
	      "help": "amount of time allowed to run test, as IETF RFC3339 dur-time time duration. This is meant to configure the limit for how long this test will wait for network requests.",
	      "required": true,
	      "default": "T5S",
	      "type": [
	        "rfc3339:dur-time",
	        "TimeLimit"
	      ],
	      "constraints": [
	        {
	          "content": " MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)",
	          "mediaType": "test/markdown"
	        }
	      ]
	    }
	  },
	  "markdown": "---\ntype:\n- TestCase\nstatus: draft\nname: inbox must be an OrderedCollection\ndescription: |\n  This rule checks whether the inbox property of an object appears to be an OrderedCollection\nuuid: 5e94d155-ed4a-4d71-b797-d7c387736ecf\nattributedTo:\n- https://bengo.is\n\"@context\":\n- TestCase:\n    \"@id\": http://www.w3.org/ns/earl#:TestCase\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# inbox must be an OrderedCollection\n\n## Background\n\n[ActivityPub](https://www.w3.org/TR/activitypub/) [§ 5.2 Inbox](https://www.w3.org/TR/activitypub/#inbox):\n> The inbox is discovered through the inbox property of an actor's profile. The inbox MUST be an OrderedCollection.\n\n## About this Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub object has an inbox property that meets this requirement to 'be an OrderedCollection', meeting requirement [4edf6768-c751-448f-96ac-4ef44cb4291f](https://socialweb.coop/activitypub/behaviors/4edf6768-c751-448f-96ac-4ef44cb4291f)\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:5e94d155-ed4a-4d71-b797-d7c387736ecf\`.\n\n## Test Subject\n\nThe subject of this test is any data claiming to conform to the specification of an ActivityPub Actor Object.\n\nThis test is *not* inherently applicable to an ActivityPub Server. An ActivityPub Server serves 0 or more Actor Objects. An ActivityPub Server for a big community might serve hundreds of ActivityPub Actor Objects. An ActivityPub Server for a single human may serve only that person's ActivityPub Actor Object.\n\nThis test is *not* inherently applicable to a URL of an Actor Object. The URL is not the same as the Actor Object. The URL may resolve to different Actor Objects in different contexts.\n\n## Inputs\n\nThis test requires the following [inputs](https://www.w3.org/TR/act-rules-format/#input):\n\n1. \`object\` - the object whose \`inbox\` property will be tested\n\n    * type: binary\n    * constraints\n        * will be interpreted as JSON\n\n2. \`time\` - amount of time allowed to run test. This is meant to configure the limit for how long this test will wait for network requests.\n\n    * required: yes\n    * example: \`T0.0021S\`\n    * type: bytes\n    * constraints\n        * MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)\n\n## Applicability\n\nThis test applies to inbox objects linked to from the \`object\` input. Usually an actor will have one inbox, but there may be multiple.\n\nThis test does not apply to objects with more than one inbox . If the input \`object\` has an inbox property whose value is an array of length >= 2, outcome is \`inapplicable\`.\n(See issue #5102 below to track expanding the applicability)\n\nIf \`object\` is not parseable as JSON to a JSON object, outcome is \`inapplicable\`.\n\nIf \`object\` is a JSON object, but it does not contain a property named \`inbox\`, outcome is \`inapplicable\`. The rationale is that there is already a test \`acaacb5f-8f7e-4f28-8d81-c7955070a767\` that can be used to determine if input \`object\` has an inbox property at all.\n\n### Test Targets\n\n1. \`inbox\` - the value of the \`inbox\` property in the input \`object\` object\n    * since the \`object\` object must be JSON for this test's applicability, the value of \`JSON.parse(actor).inbox\` must also be JSON\n    * how to derive \`inbox\` from inputs\n        1. let \`inboxValue\` be\n            * if \`inputs.actor.inbox\` is a JSON string, \`inboxValue\` is that string\n            * if \`inputs.actor.inbox\` is a JSON object, \`inboxValue\` is that object\n            * if \`inputs.actor.inbox\` is an Array of length 1, \`inboxValue\` is the item in that array\n            * if \`inputs.actor.inbox\` is an Array of length greater than 1, the test outcome is \`not applicable\` (covered in 'Applicability' above)\n              * see issue #5102 below to track expanding the applicability to support inbox property values that are arrays with length greater than 1\n        2. let \`inboxObject\` be\n            * if \`inboxValue\` is a json object, \`inboxObject\` is that object\n            * if \`inboxValue\` is a json string, \`inboxObject\` is the result of interpreting that string as an ActivityPub Object Identifier and fetching the corresponding ActivityPub Object (e.g. \`GET https://...\`).\n        3. test target \`inbox\` is \`inboxValue\`\n\n## Expectations\n\n1. \`inbox\` is a json object\n2. \`inbox\` has a property named \`type\`\n3. the values of the inbox's \`type\` property must contain \`\"OrderedCollection\"\`, as determined by\n    * if value of \`inbox\`'s \`type\` property is a string, it MUST be \`\"OrderedCollection\"\`\n    * if value of \`inbox\`'s \`type\` property is an Array, it MUST contain an entry identical to \`\"OrderedCollection\"\`\n\n## Assumptions\n\n### Interpreting \"MUST be an OrderedCollection\"\n\nRevisiting the background from above,\n[ActivityPub](https://www.w3.org/TR/activitypub/) [says](https://www.w3.org/TR/activitypub/#inbox)\n> The inbox is discovered through the inbox property of an actor's profile. The inbox MUST be an OrderedCollection.\n\n\"MUST be an OrderedCollection\" is open to some interpretation here.\n\nThis test chose to interpret 'be an' to include 'indicate its type as'. The rationale is that it's easy to check and easy to implement.\n\n## Test Cases\n\n### simple valid inbox\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"inbox\": {\n        \"id\": \"http://example.org/blog/\",\n        \"type\": \"OrderedCollection\",\n        \"name\": \"Martin's Blog\"\n      }\n    }\n    \`\`\`\n\n    * note: this OrderedCollection is from [Example 5 in activitystreams-core](https://www.w3.org/TR/activitystreams-core/#ex2-jsonld)\n\ntest targets\n\n* \`inbox\`\n    * value:\n\n        \`\`\`json\n        {\n        \"id\": \"http://example.org/blog/\",\n        \"type\": \"OrderedCollection\",\n        \"name\": \"Martin's Blog\"\n        }\n        \`\`\`\n\n    * outcome: \`passed\`\n\n### inbox is null\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"inbox\": null\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`\n    * value:\n\n        \`\`\`json\n        null\n        \`\`\`\n\n    * outcome: \`failed\`\n        * rationale: inbox is not an OrderedCollection\n\n### inbox type array contains only Person\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"inbox\": {\n        \"type\": [\"Person\"]\n      }\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`\n    * value:\n\n        \`\`\`json\n        {\n          \"type\": [\"Person\"]\n        }\n        \`\`\`\n\n    * outcome: \`failed\`\n        * rationale: inbox type is not OrderedCollection\n\n### object with no properties\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {}\n    \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### object is not JSON\n\ninputs\n\n* \`object\`\n\n    \`\`\`text\n    \\0x123abc_intentionallyNotJson\n    \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### inapplicable because inbox has many values\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"inbox\": [\"https://example.com\", \"https://example.com\"]\n    }\n    \`\`\`\n\ntest targets\n\n* \`inbox\`\n    * value:\n\n        \`\`\`json\n        [\"https://example.com\", \"https://example.com\"]\n        \`\`\`\n\n    * outcome: \`inapplicable\`\n        * rationale: inbox values that are arrays of length greater than 1 or inapplicable. See issue #5102 below to track expanding the applicability\n\n## Glossary\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping\n\n* [ActivityPub Requirement 4edf6768-c751-448f-96ac-4ef44cb4291f](https://socialweb.coop/activitypub/behaviors/4edf6768-c751-448f-96ac-4ef44cb4291f) - The inbox MUST be an OrderedCollection\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when test target \`inbox\` has outcome \`passed\`, requirement is satisfied\n        * when test target \`inbox\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`inbox\` has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Change Log\n\n* 2023-11-15T01:18:34.191Z - first draft\n* 2023-11-16T06:09:56.915Z - finish all sections in first draft\n    * add test cases for passed outcome\n    * add test cases for failed outcome\n    * add test cases for inapplicable outcome\n    * add requirements mapping for \n    * add a test case where inbox is a URI that is resolved to an OrderedCollection an the outcome is \"passed\"\n* 2023-12-29T21:51:17.983Z - reformat test cases\n\n## Issues\n\n* #01d2: resolving inbox url should use inputs.time and timeout\n* #5102: expand applicability to handle cases where there are multiple inboxes\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n",
	  "name": "inbox must be an OrderedCollection",
	  "passedCases": [
	    {
	      "name": "test case when inbox is an OrderedCollection",
	      "input": {
	        "object": "{\"inbox\":{\"id\":\"http://example.org/blog/\",\"type\":\"OrderedCollection\",\"name\":\"Martin's Blog\"}}"
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "slug": "inbox-must-be-an-orderedcollection",
	  "uuid": "5e94d155-ed4a-4d71-b797-d7c387736ecf",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "url": "https://socialweb.coop/activitypub/behaviors/4edf6768-c751-448f-96ac-4ef44cb4291f/",
	      "id": "urn:uuid:4edf6768-c751-448f-96ac-4ef44cb4291f"
	    }
	  ]
	}
	```
- [outbox must be an OrderedCollection](https://activitypub-testing.socialweb.coop/test-cases/outbox-must-be-an-orderedcollection)
	```
	{
	  "description": "This rule checks whether the outbox property of an object appears to be an OrderedCollection",
	  "failedCases": [
	    {
	      "name": "test case when the value of the outbox property is null",
	      "input": {
	        "object": {
	          "outbox": null
	        }
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "test case when outbox is an object without type OrderedCollection",
	      "input": {
	        "object": "{\"outbox\":{\"type\":[\"Person\"]}}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "inputs.object has outbox url to a non-collection",
	      "input": {
	        "object": "{\"outbox\":\"https://bengo.is/actor.json\"}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "inapplicableCases": [
	    {
	      "name": "test case when the outbox property is missing",
	      "input": {
	        "object": "{}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "test case where the value of inputs.object is not JSON",
	      "input": {
	        "object": "\u0000x123abc_intentionallyNotJson"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "test case where the value of of the outbox property is an array of length 2",
	      "input": {
	        "object": "{\"outbox\":[\"https://example.com\",\"https://example.com\"]}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "test case where outbox property value is a URL that 404s when fetched",
	      "input": {
	        "authorization": "foo",
	        "object": "{\"outbox\":\"https://bengo.is/404\"}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "object is null",
	      "input": {
	        "object": "null"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "input": {
	    "object": {
	      "help": "the object whose \`outbox\` property will be tested",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    },
	    "time": {
	      "help": "amount of time allowed to run test, as IETF RFC3339 dur-time time duration. This is meant to configure the limit for how long this test will wait for network requests.",
	      "required": true,
	      "default": "T5S",
	      "type": [
	        "rfc3339:dur-time",
	        "TimeLimit"
	      ],
	      "constraints": [
	        {
	          "content": " MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)",
	          "mediaType": "test/markdown"
	        }
	      ]
	    }
	  },
	  "markdown": "---\ntype:\n- TestCase\nstatus: draft\nname: outbox must be an OrderedCollection\ndescription: |\n  This rule checks whether the outbox property of an object appears to be an OrderedCollection\nuuid: 4af549f4-3797-4d99-a151-67c3d8feaa46\nattributedTo:\n- https://bengo.is\n\"@context\":\n- TestCase:\n    \"@id\": http://www.w3.org/ns/earl#:TestCase\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# outbox must be an OrderedCollection\n\n## Background\n\n[ActivityPub](https://www.w3.org/TR/activitypub/) [§ 5.1 Outbox](https://www.w3.org/TR/activitypub/#outbox):\n> The outbox is discovered through the outbox property of an actor's profile. The outbox MUST be an OrderedCollection.\n\n## About this Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub object has an outbox property that meets this requirement to 'be an OrderedCollection', meeting requirement [3b925cdf-89fe-4f51-b41f-26df23f58e0c](https://socialweb.coop/activitypub/behaviors/3b925cdf-89fe-4f51-b41f-26df23f58e0c)\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:4af549f4-3797-4d99-a151-67c3d8feaa46\n\`.\n\n## Test Subject\n\nThe subject of this test is any data claiming to conform to the specification of an ActivityPub Actor Object.\n\nThis test is *not* inherently applicable to an ActivityPub Server. An ActivityPub Server serves 0 or more Actor Objects. An ActivityPub Server for a big community might serve hundreds of ActivityPub Actor Objects. An ActivityPub Server for a single human may serve only that person's ActivityPub Actor Object.\n\nThis test is *not* inherently applicable to a URL of an Actor Object. The URL is not the same as the Actor Object. The URL may resolve to different Actor Objects in different contexts.\n\n## Inputs\n\nThis test requires the following [inputs](https://www.w3.org/TR/act-rules-format/#input):\n\n1. \`object\` - the object whose \`outbox\` property will be tested\n    * type: binary\n    * constraints\n        * will be interpreted as JSON\n\n2. \`time\` - amount of time allowed to run test. This is meant to configure the limit for how long this test will wait for network requests.\n    * required: yes\n    * example: \`T0.0021S\`\n    * type: binary\n    * constraints\n        * MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)\n\n## Applicability\n\nThis test applies to outbox objects linked to from the \`object\` input. Usually an actor will have one outbox, but there may be multiple.\n\nThis test does not apply to objects with more than one outbox . If the input \`object\` has an outbox property whose value is an array of length >= 2, outcome is \`inapplicable\`.\n(See issue #5102 below to track expanding the applicability)\n\nIf \`object\` is not parseable as JSON to a JSON object, outcome is \`inapplicable\`.\n\nIf \`object\` is a JSON object, but it does not contain a property named \`outbox\`, outcome is \`inapplicable\`. The rationale is that there is already a test \`acaacb5f-8f7e-4f28-8d81-c7955070a767\` that can be used to determine if input \`object\` has an outbox property at all.\n\n### Test Targets\n\n* \`outbox\` - the value of the \`outbox\` property in the input \`object\` object\n    * since the \`object\` object must be JSON for this test's applicability, the value of \`JSON.parse(actor).outbox\` must also be JSON\n    * how to derive \`outbox\` from inputs\n        1. let \`outboxValue\` be\n            * if \`inputs.actor.outbox\` is a JSON string, \`outboxValue\` is that string\n            * if \`inputs.actor.outbox\` is a JSON object, \`outboxValue\` is that object\n            * if \`inputs.actor.outbox\` is an Array of length 1, \`outboxValue\` is the item in that array\n            * if \`inputs.actor.outbox\` is an Array of length greater than 1, the test outcome is \`inapplicable\` (covered in 'Applicability' above)\n              * see issue #5102 below to track expanding the applicability to support outbox property values that are arrays with length greater than 1\n        2. let \`outboxObject\` be\n            * if \`outboxValue\` is a JSON object, \`outboxObject\` is that object\n            * if \`outboxValue\` is a JSON string, \`outboxObject\` is the result of interpreting that string as an ActivityPub Object Identifier and fetching the corresponding ActivityPub Object (e.g. \`GET https://...\`).\n        3. test target \`outbox\` is \`outboxObject\`\n\n## Expectations\n\n1. \`outbox\` is a JSON object\n2. \`outbox\` has a property named \`type\`\`\n3. the values of the outbox's \`type\` property must contain \`\"OrderedCollection\"\`, as determined by\n    * if value of \`outbox\`'s \`type\` property is a string, it MUST be \`\"OrderedCollection\"\`\n    * if value of \`outbox\`'s \`type\` property is an Array, it MUST contain an entry identical to \`\"OrderedCollection\"\`\n\n## Assumptions\n\n### Interpreting \"MUST be an OrderedCollection\"\n\nRevisiting the background from above,\n[ActivityPub](https://www.w3.org/TR/activitypub/) [says](https://www.w3.org/TR/activitypub/#outbox)\n> The outbox is discovered through the outbox property of an actor's profile. The outbox MUST be an OrderedCollection.\n\n\"MUST be an OrderedCollection\" is open to some interpretation here.\n\nThis test chose to interpret 'be an' to include 'indicate its type as'. The rationale is that it's easy to check and easy to implement.\n\n## Test Cases\n\n### object has simple valid outbox\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"outbox\": {\n        \"id\": \"http://example.org/blog/\",\n        \"type\": \"OrderedCollection\",\n        \"name\": \"Martin's Blog\"\n      }\n    }\n    \`\`\`\n\n    * note: this OrderedCollection is from [Example 5 in activitystreams-core](https://www.w3.org/TR/activitystreams-core/#ex2-jsonld)\n\ntest targets\n\n* \`outbox\`\n    * value:\n\n        \`\`\`json\n        {\n          \"id\": \"http://example.org/blog/\",\n          \"type\": \"OrderedCollection\",\n          \"name\": \"Martin's Blog\"\n        }\n        \`\`\`\n\n    * outcome: \`passed\`\n\n### object outbox is null\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"outbox\": null\n    }\n    \`\`\`\n\ntest targets\n\n* \`outbox\`\n    * value:\n\n      \`\`\`json\n      null\n      \`\`\`\n\n    * outcome: \`failed\`\n        * rationale: outbox is obviously not an OrderedCollection\n\n### object outbox type array contains Person\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      \"outbox\": {\n        \"type\": [\"Person\"]\n      }\n    }\n    \`\`\`\n\ntest targets\n\n* \`outbox\`\n    * value:\n\n      \`\`\`json\n      {\n        \"type\": [\"Person\"]\n      }\n      \`\`\`\n\n    * outcome: \`failed\`\n        * rationale: outbox type is not OrderedCollection\n\n### inapplicable because outbox has many values\n\ninputs\n\n* \`object\`\n\n  \`\`\`json\n  {\n    \"outbox\": [\"https://example.com\", \"https://example.com\"]\n  }\n  \`\`\`\n\ntest targest\n\n* \`outbox\`\n    * value:\n\n      \`\`\`json\n      [\"https://example.com\", \"https://example.com\"]\n      \`\`\`\n\n    * outcome: \`inapplicable\`\n        * rationale: outbox values that are arrays of length greater than 1 are not covered by this test's applicability. See issue #5102 below to track expanding the applicability\n\nresult\n\n* outcome: \`inapplicable\`\n\n### object is empty object\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {}\n    \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### object is not JSON\n\ninputs\n\n* \`object\`\n\n    \`\`\`text\n    \\0x123abc_intentionallyNotJson\n    \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n## Glossary\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping\n\n* [ActivityPub Requirement 003a3be2-fb58-4812-a3a3-795067254327](https://socialweb.coop/activitypub/behaviors/003a3be2-fb58-4812-a3a3-795067254327) - The outbox MUST be an OrderedCollection\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when test target \`outbox\` has outcome \`passed\`, requirement is satisfied\n        * when test target \`outbox\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`outbox\` has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Change Log\n\n* 2023-11-22T05:12:58.454Z - first draft, heavily copy from ../inbox-must-be-an-orderedcollection/inbox-must-be-an-orderedcollection.md\n* 2023-12-29T22:46:03.806Z - reformat test cases to give each one its own heading\n\n## Issues\n\nRequired\n\n* add a test case where outbox is a URI that is resolved to an OrderedCollection an the outcome is \"passed\"\n    * decide what the URL will be. Does it need to publicly resolve for a long time? maybe \n        * if that's not feasible, the test case could have the \`outbox\` test target stubbed out so at least that part could be checked\n\nNice to Have\n\n* #01d2: resolving outbox url should use inputs.time and timeout\n* #5102: expand applicability to handle cases where there are multiple outboxes\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n",
	  "name": "outbox must be an OrderedCollection",
	  "passedCases": [
	    {
	      "name": "test case when outbox is an OrderedCollection",
	      "input": {
	        "object": "{\"outbox\":{\"id\":\"http://example.org/blog/\",\"type\":\"OrderedCollection\",\"name\":\"Martin's Blog\"}}"
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "slug": "outbox-must-be-an-orderedcollection",
	  "uuid": "4af549f4-3797-4d99-a151-67c3d8feaa46",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:003a3be2-fb58-4812-a3a3-795067254327",
	      "url": "https://socialweb.coop/activitypub/behaviors/003a3be2-fb58-4812-a3a3-795067254327"
	    }
	  ]
	}
	```
- [shares collection MUST be either an OrderedCollection or a Collection](https://activitypub-testing.socialweb.coop/test-cases/shares-collection-must-be-a-collection)
	```
	{
	  "description": "This test case tests that an actor's shares collection is an expected kind of collection",
	  "input": {
	    "object": {
	      "help": "the object whose \`shares\` property will be tested",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    }
	  },
	  "markdown": "---\ntype:\n- TestCase\nstatus: draft\nname: shares collection MUST be either an OrderedCollection or a Collection\nslug: shares-collection-must-be-a-collection\ndescription: |\n  This rule checks that the shares collection of an ActivityPub Object, if present, is an OrderedCollection or a Collection.\nuuid: b03a5245-1072-426d-91b3-a3d412d45ae8\nattributedTo:\n- https://bengo.is\n\"@context\":\n- TestCase:\n    \"@id\": http://www.w3.org/ns/earl#:TestCase\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# shares collection MUST be either an OrderedCollection or a Collection\n\n## Background\n\n[ActivityPub](https://www.w3.org/TR/activitypub/) [§ 5.8 Shares Collection](https://www.w3.org/TR/activitypub/#shares):\n> Every object MAY have a shares collection.…\n> The shares collection MUST be either an OrderedCollection or a Collection\n\n## About this Test\n\nThis is a Test describing a rule to determine whether an ActivityPub object has a \`shares\` property whose value conforms to a the [requirement](https://socialweb.coop/activitypub/behaviors/937ae4e2-dd33-40c7-be1d-3ecac7f9fad5/) that \"The shares collection MUST be either an OrderedCollection or a Collection\".\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:b03a5245-1072-426d-91b3-a3d412d45ae8\`.\n\n## Test Subject\n\nThe subject of this test is data claiming to conform to the specification of an [ActivityPub Object](https://www.w3.org/TR/activitypub/#obj).\n\nThis test is *not* inherently applicable to an ActivityPub Server. An ActivityPub Server serves 1 or more ActivityPub Objects.\n\nThis test is *not* inherently applicable to a URL that resolves to an ActivityPub Object. The URL is not the same as the Object. The URL may resolve to different Objects in different contexts. Dereference the URL to test the referent with this test.\n\n## Inputs\n\nThis test requires the following [inputs](https://www.w3.org/TR/act-rules-format/#input):\n\n1. \`object\` - the object whose \`shares\` property will be tested\n    * type: binary\n    * constraints\n        * will be interepreted as JSON\n\n## Applicability\n\nThis test applies to the the \`shares\` property on the input \`object\`.\n\nThis test does not apply to objects with more than one shares collection. If the input \`object\` has a \`shares\` property whose value is an array length >= 2, the test outcome is \`inapplicable\`.\n\nThis test does not apply to objects for which a \`shares\` collection cannot be found.\nIf input \`object\` is not parseable as JSON to a JSON object, the test outcome is \`inapplicable\`.\nIf input \`object\` is a JSON object, but it does not contain a property named \`shares\`, the test outcome is \`inapplicable\`.\n\n### Test Targets\n\n1. \`shares\` - the shares collection derived from the input \`object\` and its \`shares\` property\n    * because this is the value of a property from the input \`object\` that must be a JSON object, the value of this \`shares\` target will also be JSON\n    * how to derive \`shares\` from inputs\n        1. let \`inputs.object\` be the JSON object parsed from input \`object\`\n        2. let \`propertyValue\` be\n            * if \`inputs.object.shares\` is a JSON string, \`propertyValue\` is that string\n            * if \`inputs.object.shares\` is a JSON object, \`propertyValue\` is that object\n            * if \`inputs.object.shares\` is an Array of length 1, \`propertyValue\` is the item in that array\n            * if \`inputs.object.shares\` is an Array of length greater than 1, the test outcome is \`inapplicable\` (covered in 'Applicability' above)\n        3. let \`value\` be\n          *if \`outboxValue\` is a json string, \`value\` is the result of interpreting that string as an ActivityPub Object Identifier, fetching the corresponding ActivityPub Object (e.g. \`GET https://...\`), and parsing the resulting response body as \`application/json\`.\n          * otherwise \`value\` is \`outboxValue\`\n        4. test target \`shares\` is equal to \`value\`\n\n## Expectations\n\n1. \`shares\` is a JSON object\n2. \`shares\` has a property named \`type\`\n3. the values of the \`shares\` target's \`type\` property must indicate that the value is either an OrderedCollection or a Collection as determined by:\n    * if the value of the \`shares\` target's \`type\` property is a string, it MUST be equal to either \`\"OrderedCollection\"\` or \`\"Collection\"\`\n    * if the value of the \`shares\` target's \`type\` property is an Array, it MUST contain an entry for at least one of \`\"OrderedCollection\"\` or \`\"Collection\"\`\n\n## Assumptions\n\n### Interpreting \"MUST be either an OrderedCollection or a Collection\"\n\nThis test chose to interpret 'MUST be… an' to include 'indicate its type as'. The rationale is:\n\n* it's easy to check and implement.\n* I can't think of a better alternative\n* I haven't received any objections\n\n## Test Cases\n\n### simple passed case\n\ninputs\n\n* \`object\`\n\n    \`\`\`json\n    {\n      shares: [{\n        type: [\"Collection\"]\n      }]\n    }\n    \`\`\`\n\ntest targets\n\n* \`shares\`\n\n    \`\`\`json\n    {\n      \"type\": [\"Collection\"]\n    }\n    \`\`\`\n\n    * outcome: \`passed\`\n\n### object.shares is a number\n\ninputs\n\n* \`object\`\n\n  \`\`\`json\n  {\n    shares: 1\n  }\n  \`\`\`\n\ntest targets\n\n* \`shares\`\n\n  \`\`\`json\n  1\n  \`\`\`\n\n    * outcome: \`failed\`\n        * rationale: shares does not seem to \"be either an OrderedCollection or a Collection\"\n\n### object is number\n\ninputs\n\n* \`object\`\n\n  \`\`\`json\n  1\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n## Glossary\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping\n\n* [ActivityPub Requirement 937ae4e2-dd33-40c7-be1d-3ecac7f9fad5](https://socialweb.coop/activitypub/behaviors/937ae4e2-dd33-40c7-be1d-3ecac7f9fad5) - \"The shares collection MUST be either an OrderedCollection or a Collection\"\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when test target \`shares\` has outcome \`passed\`, requirement is satisfied\n        * when test target \`shares\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`shares\` has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Change Log\n\n* 2023-11-28T22:01:58.195Z - first draft\n* 2023-12-29T23:06:48.611Z - format test cases section so each test case has a heading\n\n## Issues\n\n* [ ] ff7a: expand applicability to cover objects with \`shares\` property whose value is an array of length >= 2\n    * or perhaps just make another more ambitious test case\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n",
	  "name": "shares collection MUST be either an OrderedCollection or a Collection",
	  "slug": "shares-collection-must-be-a-collection",
	  "uuid": "b03a5245-1072-426d-91b3-a3d412d45ae8",
	  "inapplicableCases": [
	    {
	      "name": "object is number",
	      "input": {
	        "object": "1"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "object has no shares property",
	      "input": {
	        "object": "{}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "object has shares property value with array of length 2",
	      "input": {
	        "object": "{\"shares\":[1,2]}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "passedCases": [
	    {
	      "name": "simple object w/ shares",
	      "input": {
	        "object": "{\"shares\":{\"type\":\"Collection\"}}"
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    },
	    {
	      "name": "object has shares property value with array of length 1",
	      "input": {
	        "object": "{\"shares\":[{\"type\":[\"Collection\"]}]}"
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "failedCases": [
	    {
	      "name": "shares is a number",
	      "input": {
	        "object": "{\"shares\":1}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "shares has non-collection type",
	      "input": {
	        "object": "{\"shares\":{\"type\":[\"Person\"]}}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "shares null type",
	      "input": {
	        "object": "{\"shares\":{\"type\":null}}"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:937ae4e2-dd33-40c7-be1d-3ecac7f9fad5",
	      "url": "https://socialweb.coop/activitypub/behaviors/937ae4e2-dd33-40c7-be1d-3ecac7f9fad5/"
	    }
	  ]
	}
	```
- [An ActivityPub Object \`likes\` Collection Must be a Collection](https://activitypub-testing.socialweb.coop/test-cases/likes-collection-must-be-a-collection)
	```
	{
	  "input": {
	    "object": {
	      "help": "object with a likes property",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    }
	  },
	  "markdown": "---\n\ntype:\n- TestCase\ntags:\n- tests-activitypub-object\nuuid:\n- 200b9bc8-aae3-46f2-a6ab-5366042c0f6e\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# An ActivityPub Object \`likes\` Collection Must be a Collection\n\n## Background\n\n[ActivityPub][activitypub] says\n> Every object MAY have a likes collection.\n> …\n> The likes collection MUST be either an OrderedCollection or a Collection\n\n## About This Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub Object is in partial conformance with the following behaviors required by [ActivityPub][activitypub].\n\n* [requirement f965e989-4084-4f9d-9119-6a7ea13bcb64](https://socialweb.coop/activitypub/behaviors/f965e989-4084-4f9d-9119-6a7ea13bcb64/) - The likes collection MUST be either an OrderedCollection or a Collection\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:200b9bc8-aae3-46f2-a6ab-5366042c0f6e\`.\n\n## Test Subject\n\nThe subject of this test is an ActivityPub Object.\n\n## Input\n\nThis test requires the following [inputs](act-rules-input) indicating parts of the test subject:\n\n### \`input.object\`\n\nthe object whose \`likes\` property will be tested\n\n* type: binary\n* constraints\n    * should be JSON\n\n## Applicability\n\nThis test applies to each of the likes collections derived from the values of the property on \`object\` named \`likes\`.\n\n### Prerequisites\n\n* \`object\` is a JSON object\n* \`object\` JSON object has a property named \`likes\`\n\n### Test Targets\n\nHow to Derive Test Targets from Input\n\n* let \`targets\` be a set\n* let \`likesValues\` be the result of\n    * if \`object.likes\` is an Array, return it\n    * else return an Array whose only item is the value of \`object.likes\`\n* for each item in \`likesValues\`\n    * if item is a string\n        * let itemFetched be the result of interpreting the string as an ActivityPub Object Identifier and fetching the corresponding ActivityPub Object.\n        * add itemFetched to \`targets\`\n    * else add item to \`targets\`\n* return \`targets\`\n\n## Expectations\n\nFor every target \`target\`\n\n* \`target\` is a JSON object\n* \`target\` has a property named \`type\`\n* the value of the \`target\`'s \`type\` property must be one of\n    * an array containing the string \"Collection\"\n    * an array containing the string \"OrderedCollection\"\n    * the string \"Collection\"\n    * the string \"OrderedCollection\"\n\n## Test Cases\n\nWhat follows are some specific cases of applything this test rule.\n\n### Passed Example 1\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"likes\": {\n      \"type\": \"Collection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"Collection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 2\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"likes\": {\n      \"type\": \"OrderedCollection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"OrderedCollection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 3\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"likes\": {\n      \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"likes\": {\n      \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n    }\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n        * rationale: \`\"FancyCollection\"\` is not well-defined here, but this object still passes the test because at least one of the \`type\` property values is \`OrderedCollection\` and thus satisfies the requirement as interpreted.\n\n### Failed Example 1 - Likes is a number\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"likes\": 1\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  1\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 2 - Likes is an empty object\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"likes\": {}\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {}\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 3 - Likes object type is array including only \`\"Link\"\`\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"likes\": {\n      \"type\": [\"Link\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"Link\"]\n  }\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Inapplicable Example 1\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  1\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### Inapplicable Example 2 - object has no likes property\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  { \"foo\": \"bar\" }\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### Inapplicable Example 3 - object is html\n\ninputs\n\n* \`object\`:\n\n  \`\`\`html\n  hi\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n## Glossary [?](https://www.w3.org/TR/act-rules-format/#glossary)\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping [?](https://www.w3.org/TR/act-rules-format/#accessibility-requirements-mapping)\n\n* [ActivityPub requirement f965e989-4084-4f9d-9119-6a7ea13bcb64](https://socialweb.coop/activitypub/behaviors/f965e989-4084-4f9d-9119-6a7ea13bcb64/) - The likes collection MUST be either an OrderedCollection or a Collection\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when every test target has outcome \`passed\`, the requirement is satisfied by the test subject\n        * when any test target has outcome \`failed\`, the requirement is not satisfied by the test subject\n        * when any test target has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Issues [?](https://www.w3.org/TR/act-rules-format/issues-list)\n\n## Change Log\n\n* 2023-12-06T06:48:14.689Z: init\n* 2023-12-18T04:33:22.670Z: add more example cases that were useful for maximizing implementation code coverage\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n",
	  "name": "An ActivityPub Object \`likes\` Collection Must be a Collection",
	  "description": "tests whether an ActivityPub Object has a likes collection with an appropriate Collection type",
	  "slug": "likes-collection-must-be-a-collection",
	  "inapplicableCases": [
	    {
	      "name": "inapplicable example 1",
	      "input": {
	        "object": "1"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "inapplicble example 2 - object has no likes property",
	      "input": {
	        "object": "\n      { \"foo\": \"bar\" }\n      "
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "inapplicable example 3 - html object",
	      "input": {
	        "object": "hi"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "passedCases": [
	    {
	      "name": "passed example 1",
	      "input": {
	        "object": "\n        {\n          \"likes\": {\n            \"type\": \"Collection\"\n          }\n        }\n      "
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    },
	    {
	      "name": "passed example 2",
	      "input": {
	        "object": "\n      {\n        \"likes\": {\n          \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n        }\n      }\n      "
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "failedCases": [
	    {
	      "name": "failed example 1",
	      "input": {
	        "object": "\n        {\n          \"likes\": 1\n        }\n      "
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "failed example 2",
	      "input": {
	        "object": "\n        {\n          \"likes\": {}\n        }\n      "
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "failed example 3",
	      "input": {
	        "object": "\n        {\n          \"likes\": {\n            \"type\": [\"Link\"]\n          }\n        }\n      "
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "uuid": "200b9bc8-aae3-46f2-a6ab-5366042c0f6e",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:f965e989-4084-4f9d-9119-6a7ea13bcb64",
	      "url": "https://socialweb.coop/activitypub/behaviors/f965e989-4084-4f9d-9119-6a7ea13bcb64/"
	    }
	  ]
	}
	```
- [An ActivityPub Object \`liked\` Collection Must be a Collection](https://activitypub-testing.socialweb.coop/test-cases/liked-collection-must-be-a-collection)
	```
	{
	  "input": {
	    "object": {
	      "help": "object with a liked property",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    }
	  },
	  "markdown": "---\n\ntype:\n- TestCase\ntags:\n- tests-activitypub-actor\nuuid:\n- 018c3df2-d6d8-7f62-805b-b71a96cc6170\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# An ActivityPub Object \`liked\` Collection Must be a Collection\n\n## Background [?][test-background]\n\n[ActivityPub][activitypub] [§ 5.5 Liked Collection](https://www.w3.org/TR/activitypub/#liked):\n> Every object MAY have a liked collection.\n> …\n> The liked collection MUST be either an OrderedCollection or a Collection\n\n## About This Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub Object is in partial conformance with the following behaviors required by [ActivityPub][activitypub].\n\n* [requirement d2db8da3-25d4-4dd9-9c9c-b2793fd899cf](https://socialweb.coop/activitypub/behaviors/d2db8da3-25d4-4dd9-9c9c-b2793fd899cf/) - The liked collection MUST be either an OrderedCollection or a Collection\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:018c3df2-d6d8-7f62-805b-b71a96cc6170\`.\n\n## Test Subject\n\nThe subject of this test is an ActivityPub Object.\n\n## Input [?][test-input]\n\nThis test requires the following [inputs](act-rules-input) indicating parts of the test subject:\n\n1. \`object\` - the object whose \`liked\` property will be tested\n    * type: binary\n    * constraints\n        * should be JSON\n\n## Applicability [?][test-applicability]\n\nThis test applies to each of the liked collections derived from the values of the property on \`object\` named \`liked\`.\n\n### Prerequisites\n\n* \`object\` is a JSON object\n* \`object\` JSON object has a property named \`liked\`\n\n### How to Derive Test Targets from Input\n\n* let \`targets\` be a set\n* let \`likedValues\` be the result of\n    * if \`object.liked\` is an Array, return it\n    * else return an Array whose only item is the value of \`object.liked\`\n* for each item in \`likedValues\`\n    * if item is a string\n        * let itemFetched be the result of interpreting the string as an ActivityPub Object Identifier and fetching the corresponding ActivityPub Object.\n        * add itemFetched to \`targets\`\n    * else add item to \`targets\`\n* return \`targets\`\n\n## Expectations [?][test-expectations]\n\nFor every target \`target\`\n\n* \`target\` is a JSON object\n* \`target\` has a property named \`type\`\n* the values of the \`target\`'s \`type\` property must be one of\n    * an array containing the string \"Collection\"\n    * an array containing the string \"OrderedCollection\"\n    * the string \"Collection\"\n    * the string \"OrderedCollection\"\n\n## Assumptions [?][test-assumptions]\n\n## Test Cases [?][test-test-cases]\n\nWhat follows are some specific cases of applything this test.\n\n### Passed Example 1\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"liked\": {\n      \"type\": \"Collection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"Collection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 2\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"liked\": {\n      \"type\": \"OrderedCollection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"OrderedCollection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 3\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"liked\": {\n      \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n        * rationale: \`\"FancyCollection\"\` is not well-defined here, but this object still passes the test because at least one of the \`type\` property values is \`OrderedCollection\` and thus satisfies the requirement as interpreted.\n\n### Failed Example 1 - Likes is a number\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"liked\": 1\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  1\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 2 - Likes is an empty object\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"liked\": {}\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {}\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 3 - Likes object type is array including only \`\"Link\"\`\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"liked\": {\n      \"type\": [\"Link\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"Link\"]\n  }\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Inapplicable Example 1\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  1\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### Inapplicable Example 2 - object has no likes property\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  { \"foo\": \"bar\" }\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n## Glossary [?](https://www.w3.org/TR/act-rules-format/#glossary)\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping [?][act-rules-requirements-mapping]\n\n* [ActivityPub requirement d2db8da3-25d4-4dd9-9c9c-b2793fd899cf](https://socialweb.coop/activitypub/behaviors/d2db8da3-25d4-4dd9-9c9c-b2793fd899cf/) - The liked collection MUST be either an OrderedCollection or a Collection\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when every test target has outcome \`passed\`, the requirement is satisfied by the test subject\n        * when any test target has outcome \`failed\`, the requirement is not satisfied by the test subject\n        * when any test target has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Issues [?][test-issues-list]\n\n## Change Log\n\n* 2023-12-06T07:07:25.913Z - init\n* 2023-12-18T04:43:02.981Z - add test cases based on automating this test\n\n[act-rules-requirements-mapping]: https://www.w3.org/TR/act-rules-format/#accessibility-requirements-mapping\n[activitypub]: https://www.w3.org/TR/activitypub/\n[test-applicability]: https://www.w3.org/TR/act-rules-format/#applicability\n[test-assumptions]: https://www.w3.org/TR/act-rules-format/#assumptions\n[test-background]: https://www.w3.org/TR/act-rules-format/#background\n[test-expectations]: https://www.w3.org/TR/act-rules-format/#expectations\n[test-input]: https://www.w3.org/TR/act-rules-format/#input\n[test-issues-list]: https://www.w3.org/TR/act-rules-format/#issues-list\n[test-test-cases]: https://www.w3.org/TR/act-rules-format/#test-cases\n",
	  "name": "An ActivityPub Object \`liked\` Collection Must be a Collection",
	  "description": "tests whether an ActivityPub Object has a liked collection with an appropriate Collection type",
	  "slug": "liked-collection-must-be-a-collection",
	  "inapplicableCases": [
	    {
	      "name": "inapplicable example 1",
	      "input": {
	        "object": "1"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    },
	    {
	      "name": "inapplicble example 2 - object has no liked property",
	      "input": {
	        "object": "\n      { \"foo\": \"bar\" }\n      "
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "passedCases": [
	    {
	      "name": "passed example 1",
	      "input": {
	        "object": "\n        {\n          \"liked\": {\n            \"type\": \"Collection\"\n          }\n        }\n      "
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    },
	    {
	      "name": "passed example 2",
	      "input": {
	        "object": "\n      {\n        \"liked\": {\n          \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n        }\n      }\n      "
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "failedCases": [
	    {
	      "name": "failed example 1",
	      "input": {
	        "object": "\n        {\n          \"liked\": 1\n        }\n      "
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "failed example 2",
	      "input": {
	        "object": "\n        {\n          \"liked\": {}\n        }\n      "
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    },
	    {
	      "name": "failed example 3",
	      "input": {
	        "object": "\n        {\n          \"liked\": {\n            \"type\": [\"Link\"]\n          }\n        }\n      "
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "uuid": "018c3df2-d6d8-7f62-805b-b71a96cc6170",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:d2db8da3-25d4-4dd9-9c9c-b2793fd899cf",
	      "url": "https://socialweb.coop/activitypub/behaviors/d2db8da3-25d4-4dd9-9c9c-b2793fd899cf/"
	    }
	  ]
	}
	```
- [An ActivityPub Actor Object's \`followers\` Collection Must be a Collection](https://activitypub-testing.socialweb.coop/test-cases/followers-collection-must-be-a-collection)
	```
	{
	  "input": {
	    "object": {
	      "help": "object with a \`followers\` property",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    }
	  },
	  "markdown": "---\n\ntype:\n- TestCase\ntags:\n- tests-activitypub-actor\nuuid:\n- 018c3e08-611f-7e56-9f45-2fe5e4877d4e\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# An ActivityPub Object \`followers\` Collection Must be a Collection\n\n## Background [?][test-background]\n\n[ActivityPub][activitypub] [§ 5.3 Followers Collection](https://www.w3.org/TR/activitypub/#followers):\n\n> Every actor SHOULD have a followers collection.\n> This is a list of everyone who has sent a Follow activity for the actor,\n> added as a side effect.\n> This is where one would find a list of all the actors that are following the actor.\n> The followers collection MUST be either an OrderedCollection or a Collection\n\n## About This Test\n\nThis is a Test Case describing a rule to determine\nwhether an ActivityPub Object is in partial conformance with\nthe following behaviors required by [ActivityPub][activitypub].\n\n* [requirement abef3a0a-d3c4-4dee-a320-b28837d0bcd8][requirement-1] -\nThe followers collection MUST be either an OrderedCollection or a Collection\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:018c3e08-611f-7e56-9f45-2fe5e4877d4e\`.\n\n## Test Subject\n\nThe subject of this test is an ActivityPub Actor Object.\n\n## Input [?][test-input]\n\nThis test requires the following [inputs](act-rules-input)\nindicating parts of the test subject:\n\n1. \`object\` - the object whose \`followers\` property will be tested\n    * type: binary\n    * constraints\n        * should be JSON\n\n## Applicability [?][test-applicability]\n\nThis test applies to each of the followers collections derived\nfrom the values of the property on \`object\` named \`followers\`.\n\n### Prerequisites\n\n* \`object\` is a JSON object\n* \`object\` JSON object has a property named \`followers\`\n\n### How to Derive Test Targets from Input\n\n* let \`targets\` be a set\n* let \`followersValues\` be the result of\n    * if \`object.followers\` is an Array, return it\n    * else return an Array whose only item is the value of \`object.followers\`\n* for each item in \`followersValues\`\n    * if item is a string\n        * let itemFetched be the result of interpreting the string as\n          an ActivityPub Object Identifier and fetching the corresponding\n          ActivityPub Object.\n        * add itemFetched to \`targets\`\n    * else add item to \`targets\`\n* return \`targets\`\n\n## Expectations [?][test-expectations]\n\nFor every target \`target\`\n\n* \`target\` is a JSON object\n* \`target\` has a property named \`type\`\n* the values of the \`target\`'s \`type\` property must be one of\n    * an array containing the string \"Collection\"\n    * an array containing the string \"OrderedCollection\"\n    * the string \"Collection\"\n    * the string \"OrderedCollection\"\n\n## Assumptions [?][test-assumptions]\n\n## Test Cases [?][test-test-cases]\n\nWhat follows are some specific cases of applything this test.\n\n### Passed Example 1 - followers has type Collection\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"followers\": {\n      \"type\": \"Collection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"Collection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 2 - followers has type OrderedCollection\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"followers\": {\n      \"type\": \"OrderedCollection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"OrderedCollection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 3 - followers type includes OrderedCollection\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"followers\": {\n      \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n        * rationale\n            * \`\"FancyCollection\"\` is not well-defined here,\nbut this object still passes the test because at least one of the \`type\`\nproperty values is \`OrderedCollection\` and thus satisfies the requirement\nas interpreted.\n\n### Failed Example 1 - followers is a number\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"followers\": 1\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  1\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 2 - followers is an empty object\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"followers\": {}\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {}\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 3 - followers object type is array including only \`\"Link\"\`\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"followers\": {\n      \"type\": [\"Link\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"Link\"]\n  }\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Inapplicable Example 1\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  1\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### Inapplicable Example 2 - object has no followers property\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  { \"foo\": \"bar\" }\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n## Glossary [?](https://www.w3.org/TR/act-rules-format/#glossary)\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping [?][act-rules-requirements-mapping]\n\n* [ActivityPub requirement abef3a0a-d3c4-4dee-a320-b28837d0bcd8][requirement-1] - The followers collection MUST be either an OrderedCollection or a Collection\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when every test target has outcome \`passed\`, the requirement is satisfied by the test subject\n        * when any test target has outcome \`failed\`, the requirement is not satisfied by the test subject\n        * when any test target has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Issues [?][test-issues-list]\n\n## Change Log\n\n* 2023-12-06T07:43:27.890Z - init\n* 2023-12-18T05:11:09.722Z - add test cases based on implementing\n\n[requirement-1]: https://socialweb.coop/activitypub/behaviors/abef3a0a-d3c4-4dee-a320-b28837d0bcd8/\n[act-rules-requirements-mapping]: https://www.w3.org/TR/act-rules-format/#accessibility-requirements-mapping\n[activitypub]: https://www.w3.org/TR/activitypub/\n[test-applicability]: https://www.w3.org/TR/act-rules-format/#applicability\n[test-assumptions]: https://www.w3.org/TR/act-rules-format/#assumptions\n[test-background]: https://www.w3.org/TR/act-rules-format/#background\n[test-expectations]: https://www.w3.org/TR/act-rules-format/#expectations\n[test-input]: https://www.w3.org/TR/act-rules-format/#input\n[test-issues-list]: https://www.w3.org/TR/act-rules-format/#issues-list\n[test-test-cases]: https://www.w3.org/TR/act-rules-format/#test-cases\n",
	  "name": "An ActivityPub Actor Object's \`followers\` Collection Must be a Collection",
	  "description": "tests whether an ActivityPub Object has a \`followers\`\` collection with an appropriate Collection type",
	  "slug": "followers-collection-must-be-a-collection",
	  "inapplicableCases": [
	    {
	      "name": "Inapplicable Example 1 - object is a number",
	      "result": {
	        "outcome": "inapplicable"
	      },
	      "input": {
	        "object": "42"
	      }
	    },
	    {
	      "name": "Inapplicable Example 2 - object has no followers property",
	      "result": {
	        "outcome": "inapplicable"
	      },
	      "input": {
	        "object": "{ \"foo\": \"bar\" }"
	      }
	    },
	    {
	      "name": "inapplicable example 3 - html object",
	      "input": {
	        "object": "hi"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "passedCases": [
	    {
	      "name": "Passed Example 1",
	      "result": {
	        "outcome": "passed"
	      },
	      "input": {
	        "object": "\n        {\n          \"followers\": {\n            \"type\": \"Collection\"\n          }\n        }\n      "
	      }
	    },
	    {
	      "name": "Passed Example 2",
	      "result": {
	        "outcome": "passed"
	      },
	      "input": {
	        "object": "\n        {\n          \"followers\": {\n            \"type\": \"OrderedCollection\"\n          }\n        }\n      "
	      }
	    }
	  ],
	  "failedCases": [
	    {
	      "name": "Failed Example 1 - followers is a number",
	      "result": {
	        "outcome": "failed"
	      },
	      "input": {
	        "object": "\n        {\n          \"followers\": 42\n        }\n      "
	      }
	    },
	    {
	      "name": "Failed Example 2 - followers is an empty object",
	      "result": {
	        "outcome": "failed"
	      },
	      "input": {
	        "object": "\n        {\n          \"followers\": {}\n        }\n      "
	      }
	    },
	    {
	      "name": "Failed Example 3 - followers object type is array including only \`\"Link\"\`",
	      "result": {
	        "outcome": "failed"
	      },
	      "input": {
	        "object": "\n        {\n          \"followers\": {\n            \"type\": [\"Link\"]\n          }\n        }\n      "
	      }
	    }
	  ],
	  "uuid": "018c3e08-611f-7e56-9f45-2fe5e4877d4e",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:abef3a0a-d3c4-4dee-a320-b28837d0bcd8",
	      "url": "https://socialweb.coop/activitypub/behaviors/abef3a0a-d3c4-4dee-a320-b28837d0bcd8"
	    }
	  ]
	}
	```
- [An ActivityPub Actor Object's \`following\` Collection Must be a Collection](https://activitypub-testing.socialweb.coop/test-cases/following-collection-must-be-a-collection)
	```
	{
	  "input": {
	    "object": {
	      "help": "object with a \`following\` property",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#Actor"
	      ]
	    }
	  },
	  "markdown": "---\n\ntype:\n- TestCase\ntags:\n- tests-activitypub-actor\nuuid:\n- 018c3e17-a1bd-7040-8007-4cd3b9063288\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# An ActivityPub Object \`following\` Collection Must be a Collection\n\n## Background [?][test-background]\n\n[ActivityPub][activitypub] [§ 5.4 Following Collection](https://www.w3.org/TR/activitypub/#following):\n\n> Every actor SHOULD have a following collection. This is a list of everybody that the actor has followed, added as a side effect. The following collection MUST be either an OrderedCollection or a Collection\n\n## About This Test\n\nThis is a Test Case describing a rule to determine whether an ActivityPub Object is in partial conformance with the following behaviors required by [ActivityPub][activitypub].\n\n* [requirement a4876ff4-7751-4bc6-91e0-9275382d4a85](https://socialweb.coop/activitypub/behaviors/a4876ff4-7751-4bc6-91e0-9275382d4a85/) - The following collection MUST be either an OrderedCollection or a Collection\n\n### Identifier\n\nThe identifier of this test is \`urn:uuid:018c3e17-a1bd-7040-8007-4cd3b9063288\`.\n\n## Test Subject [?][test-subject]\n\nThe subject of this test is an ActivityPub Actor Object.\n\n## Input [?][test-input]\n\nThis test requires the following [inputs](act-rules-input) indicating parts of the test subject:\n\n1. \`object\` - the object whose \`following\` property will be tested\n    * type: binary\n    * constraints\n        * should be JSON\n\n## Applicability [?][test-applicability]\n\nThis test applies to each of the following collections derived from the values of the property on \`object\` named \`following\`.\n\n### Prerequisites\n\n* \`object\` is a JSON object\n* \`object\` JSON object has a property named \`following\`\n\n### How to Derive Test Targets from Input\n\n* let \`targets\` be a set\n* let \`followingValues\` be the result of\n    * if \`object.following\` is an Array, return it\n    * else return an Array whose only item is the value of \`object.following\`\n* for each item in \`followingValues\`\n    * if item is a string\n        * let itemFetched be the result of interpreting the string as an ActivityPub Object Identifier and fetching the corresponding ActivityPub Object.\n        * add itemFetched to \`targets\`\n    * else add item to \`targets\`\n* return \`targets\`\n\n## Expectations [?][test-expectations]\n\nFor every target \`target\`\n\n* \`target\` is a JSON object\n* \`target\` has a property named \`type\`\n* the values of the \`target\`'s \`type\` property must be one of\n    * an array containing the string \"Collection\"\n    * an array containing the string \"OrderedCollection\"\n    * the string \"Collection\"\n    * the string \"OrderedCollection\"\n\n## Assumptions [?][test-assumptions]\n\n## Test Cases [?][test-test-cases]\n\nWhat follows are some specific cases of applything this test.\n\n### Passed Example 1 - following has type Collection\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"following\": {\n      \"type\": \"Collection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"Collection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 2 - following has type OrderedCollection\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"following\": {\n      \"type\": \"OrderedCollection\"\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": \"OrderedCollection\"\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n\n### Passed Example 3 - following type includes OrderedCollection\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"following\": {\n      \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"FancyCollection\", \"OrderedCollection\"]\n  }\n  \`\`\`\n\n    * outcome: \`passed\`\n        * rationale\n            * \`\"FancyCollection\"\` is not well-defined here,\nbut this object still passes the test because at least one of the \`type\`\nproperty values is \`OrderedCollection\` and thus satisfies the requirement\nas interpreted.\n\n### Failed Example 1 - following is a number\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"following\": 1\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  1\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 2 - following is an empty object\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"following\": {}\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {}\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Failed Example 3 - following object type is array including only \`\"Link\"\`\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  {\n    \"following\": {\n      \"type\": [\"Link\"]\n    }\n  }\n  \`\`\`\n\ntest targets\n\n* \`\`\`json\n  {\n    \"type\": [\"Link\"]\n  }\n  \`\`\`\n\n    * outcome: \`failed\`\n\n### Inapplicable Example 1\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  1\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n### Inapplicable Example 2 - object has no following property\n\ninputs\n\n* \`object\`:\n\n  \`\`\`json\n  { \"foo\": \"bar\" }\n  \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n\n## Glossary [?](https://www.w3.org/TR/act-rules-format/#glossary)\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping [?][act-rules-requirements-mapping]\n\n* [ActivityPub requirement a4876ff4-7751-4bc6-91e0-9275382d4a85](https://socialweb.coop/activitypub/behaviors/a4876ff4-7751-4bc6-91e0-9275382d4a85/) - The following collection MUST be either an OrderedCollection or a Collection\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when every test target has outcome \`passed\`, the requirement is satisfied by the test subject\n        * when any test target has outcome \`failed\`, the requirement is not satisfied by the test subject\n        * when any test target has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Issues [?][test-issues-list]\n\n## Change Log\n\n* 2023-12-06T07:43:27.890Z - init\n\n[act-rules-requirements-mapping]: https://www.w3.org/TR/act-rules-format/#accessibility-requirements-mapping\n[activitypub]: https://www.w3.org/TR/activitypub/\n[test-subject]: https://www.w3.org/TR/act-rules-format/#test-subject\n[test-applicability]: https://www.w3.org/TR/act-rules-format/#applicability\n[test-assumptions]: https://www.w3.org/TR/act-rules-format/#assumptions\n[test-background]: https://www.w3.org/TR/act-rules-format/#background\n[test-expectations]: https://www.w3.org/TR/act-rules-format/#expectations\n[test-input]: https://www.w3.org/TR/act-rules-format/#input\n[test-issues-list]: https://www.w3.org/TR/act-rules-format/#issues-list\n[test-test-cases]: https://www.w3.org/TR/act-rules-format/#test-cases\n",
	  "name": "An ActivityPub Actor Object's \`following\` Collection Must be a Collection",
	  "description": "tests whether an ActivityPub Object has a \`following\`\` collection with an appropriate Collection type",
	  "slug": "following-collection-must-be-a-collection",
	  "inapplicableCases": [
	    {
	      "name": "Inapplicable Example 1 - object is a number",
	      "result": {
	        "outcome": "inapplicable"
	      },
	      "input": {
	        "object": "42"
	      }
	    },
	    {
	      "name": "Inapplicable Example 2 - object has no following property",
	      "result": {
	        "outcome": "inapplicable"
	      },
	      "input": {
	        "object": "{ \"foo\": \"bar\" }"
	      }
	    },
	    {
	      "name": "inapplicable example 3 - html object",
	      "input": {
	        "object": "hi"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "passedCases": [
	    {
	      "name": "Passed Example 1",
	      "result": {
	        "outcome": "passed"
	      },
	      "input": {
	        "object": "\n        {\n          \"following\": {\n            \"type\": \"Collection\"\n          }\n        }\n      "
	      }
	    },
	    {
	      "name": "Passed Example 2",
	      "result": {
	        "outcome": "passed"
	      },
	      "input": {
	        "object": "\n        {\n          \"following\": {\n            \"type\": \"OrderedCollection\"\n          }\n        }\n      "
	      }
	    }
	  ],
	  "failedCases": [
	    {
	      "name": "Failed Example 1 - following is a number",
	      "result": {
	        "outcome": "failed"
	      },
	      "input": {
	        "object": "\n        {\n          \"following\": 42\n        }\n      "
	      }
	    },
	    {
	      "name": "Failed Example 2 - following is an empty object",
	      "result": {
	        "outcome": "failed"
	      },
	      "input": {
	        "object": "\n        {\n          \"following\": {}\n        }\n      "
	      }
	    },
	    {
	      "name": "Failed Example 3 - following object type is array including only \`\"Link\"\`",
	      "result": {
	        "outcome": "failed"
	      },
	      "input": {
	        "object": "\n        {\n          \"following\": {\n            \"type\": [\"Link\"]\n          }\n        }\n      "
	      }
	    }
	  ],
	  "uuid": "018c3e17-a1bd-7040-8007-4cd3b9063288",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:a4876ff4-7751-4bc6-91e0-9275382d4a85",
	      "url": "https://socialweb.coop/activitypub/behaviors/a4876ff4-7751-4bc6-91e0-9275382d4a85/"
	    }
	  ]
	}
	```
- [Outbox Servers handling activity submissions MUST return a 201 created HTTP status code](https://activitypub-testing.socialweb.coop/test-cases/outbox-post-servers-must-return-a-201-created-http-code)
	```
	{
	  "description": "This test checks that an ActivityPub Outbox responds with a 201 status code when sent a POST request with an Activity submission.",
	  "failedCases": [
	    {
	      "name": "with authorization, response status 403 Forbidden",
	      "input": {
	        "outbox": "https://socialweb.coop/activitypub/testing/utilities/response?status=403",
	        "submission": "{\"type\":\"Create\"}",
	        "authorization": "Bearer foo"
	      },
	      "result": {
	        "outcome": "failed"
	      }
	    }
	  ],
	  "inapplicableCases": [
	    {
	      "name": "non-URI input \`id\`",
	      "input": {
	        "outbox": "bafybeib5mvfjatmpswc3jnh7ydz4zxe25cm63xp6aafpg3j2awakf63qma",
	        "submission": "{\"type\":\"Create\"}"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "input": {
	    "outbox": {
	      "help": "the url to the Outbox handling an Activity POST request",
	      "required": true,
	      "type": "xsd:anyUri",
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#outbox"
	      ]
	    },
	    "authorization": {
	      "help": "HTTP Authorization header value to include in outbox POST request",
	      "required": false,
	      "type": [
	        "xsd:string",
	        "https://activitypub-testing.socialweb.coop/ns/HiddenInTestResults"
	      ],
	      "rangeIncludes": [
	        "https://www.rfc-editor.org/rfc/rfc9110#field.authorization.value"
	      ]
	    },
	    "time": {
	      "help": "amount of time allowed to run test, as IETF RFC3339 dur-time time duration. This is meant to configure the limit for how long this test will wait for network requests.",
	      "required": true,
	      "default": "T5S",
	      "type": [
	        "rfc3339:dur-time",
	        "TimeLimit"
	      ],
	      "constraints": [
	        {
	          "content": " MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)",
	          "mediaType": "test/markdown"
	        }
	      ]
	    }
	  },
	  "markdown": "---\n\nuuid: 723afcbb-118d-433e-8ab4-560ffca93582\n\ntype:\n- TestCase\n\nname: |\n  Outbox Servers handling activity submissions MUST return a 201 created HTTP status code\n\nslug: |\n  outbox-post-servers-must-return-a-201-created-http-code\n\ndescription: |\n  This test checks that an ActivityPub Outbox responds with a 201 status code when sent a POST request with an Activity submission.\n\ntestsRequirement:\n- id: urn:uuid:3b925cdf-89fe-4f51-b41f-26df23f58e0c\n  url: https://socialweb.coop/activitypub/behaviors/3b925cdf-89fe-4f51-b41f-26df23f58e0c\n  name: Servers MUST return a 201 Created HTTP code\n\n# https://www.w3.org/QA/WG/2005/01/test-faq#review\n# *submitted, accepted, reviewed*, *returned for revision*, or *rejected*\ntestCaseState: submitted\n\nrespec:\n  config:\n    editors:\n    - name: bengo\n      url: \"https://bengo.is\"\n      w3cid: 49026\n---\n\n# Outbox Servers handling activity submissions MUST return a 201 created HTTP status code\n\n## Background\n\nIn the context of [client-to-server interactions](https://www.w3.org/TR/activitypub/#client-to-server-interactions) via Activity submission, [ActivityPub][activitypub] says\n> Servers MUST return a 201 Created HTTP code\n\n[activitypub]: https://www.w3.org/TR/activitypub/\n\n## About this Test\n\nThis is a Test describing a rule to determine whether an ActivityPub Server is in conformance with the following behaviors required by [ActivityPub][activitypub]:\n\n* Servers MUST return a 201 Created HTTP code aka [requirement 3b925cdf-89fe-4f51-b41f-26df23f58e0c](https://socialweb.coop/activitypub/behaviors/3b925cdf-89fe-4f51-b41f-26df23f58e0c)\n\n### Identifier\n\nThe identifier of this test is \`723afcbb-118d-433e-8ab4-560ffca93582\`.\n\n## Test Subject\n\nThe subject of this test is an ActivityPub Server serving activity submission requests for an ActivityPub Outbox.\n\nThe Test Subject can be identified by a URI for an ActivityPub Outbox. The ActivityPub Outbox has an \`id\` property and the ActivityPub server is responsible for responding to requests sent to it.\n\n## Inputs\n\nThis test requires the following [inputs](https://www.w3.org/TR/act-rules-format/#input):\n\n1. \`outbox\` - identifier of an ActivityPub Outbox\n    * required: yes\n    * type: binary\n      * constraints\n        * MUST be a URI, i.e. an [ActivityPub Object Identifier](https://www.w3.org/TR/activitypub/#obj-id) that is not \`null\`\n\n2. \`authorization\` - proof of authorization to submit an activity to the outbox identified by input \`outbox\`\n    * required: no\n      * if this input is omitted, no \`Authorization\` header will be provided in the HTTP request send by this test\n    * type: binary\n      * constraints\n        * If present, this should be valid as the value of an HTTP \`Authorization\` header\n\n3. \`submission\` - ActivityPub message that will be submitted to the Outbox.\n    * required: no\n      * if this input is omitted, the test will use a simple valid submission\n    * type: binary\n      * constraints\n        * should be JSON\n      * note\n        * this will be sent as the HTTP request body of an ActivityPub [client-to-server](https://www.w3.org/TR/activitypub/#client-to-server-interactions) request with header \`Content-Type: application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"\`.\n\n## Applicability\n\nThis test applies to the server hosting the ActivityPub Outbox identified by input \`outbox\` and that support requests using HTTP method \`POST\`.\n\nIf input \`outbox\` is not a URI, outcome is \`inapplicable\`.\n\nIf input \`outbox\` URI scheme is not \`https\` or \`http\`, outcome is \`inapplicable\`. (This test may be revised later to handle other URI schemes).\n\nIf the server indicates it does not support \`POST\` requests, the test outcome MUST be \`inapplicable\`.\n\nIf the server indicates that the provided input includes insufficient proof of authorization to write to the outbox, the test outcome MUST be a [\`CannotTell\`](https://www.w3.org/TR/EARL10-Schema/#CannotTell).\n\n### Test Targets\n\n* \`response\` - the HTTP response that is the result of submitting the input \`submission\` to the ActivityPub Outbox identified by input \`outbox\`.\n    * how to derive \`response\` from inputs\n      1. start a timer with duration from input \`time\`. If the timer reaches zero before this derivation is complete, the whole test outcome is \`inapplicable\` because we weren't able to determine the \`response\` test target within the required time.\n      2. let \`request\` be a new HTTP Request whose URI is input \`outbox\`\n      3. add an http request header to \`request\` whose name is \`Content-Type\` and whose value is \`application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"\`\n      4. if input \`authorization\` was provided, add an http request header to \`request\` whose name is \`Authorization\` and whose value is input \`authorization\`\n      5. let \`submission\` be the input \`submission\`, if provided, otherwise use the json value\n\n          \`\`\`json\n          {\n            \"@context\": \"https://www.w3.org/ns/activitystreams\",\n            \"type\": \"Note\",\n            \"content\": \"Say, did you finish reading that book I lent you?\"\n          }\n          \`\`\`\n\n      6. let the http request body of \`request\` be the value of \`submission\`\n      7. send the HTTP request and await a response\n      8. assign the HTTP response to the \`response\` test target\n      9. If the status code of \`response\` is 401, the test outcome MUST be a [\`CannotTell\`](https://www.w3.org/TR/EARL10-Schema/#CannotTell)\n      10. If the status code of \`response\` is 403,\n          * if input \`authorization\` was provided, the test outcome MAY be [\`Fail\`](https://www.w3.org/TR/EARL10-Schema/#Fail)\n          * else (input \`authorization\` was not provided) the test outcome MUST be a [\`CannotTell\`](https://www.w3.org/TR/EARL10-Schema/#CannotTell)\n      11. If the status code of \`response\` is 405 (e.g. 'Method Not Allowed'), the test outcome MUST be \`inapplicable\`\n          * rationale: The server is explicitly indicating it does not support requests with method \`POST\`, and this test is only applicable to servers that do.\n\n## Expectations\n\n* \`response\` http status code is \`201\`\n\n## Assumptions\n\n### Default Outbox Submission\n\nIf an input \`submission\` is not provided, the test will use an activity based on Example 2 in [ActivityPub](https://www.w3.org/TR/activitypub/). If this causes problems, provide an input \`submission\` that will work to produce a 201 response status code and satisfy the requirement being tested.\n\n### 403 Forbidden Semantics Varies on Authorization\n\nWhen interpreting a HTTP 403 response resulting sending a POST request to the input \`outbox\`, this test varies its outcome depending on whether an input \`authorization\` was provided to the test.\n\nA rationale is that HTTP semantics in general defines 403 to mean different things depending on whether authentication credentials were provided in the request:\n\n> The 403 (Forbidden) status code indicates that the server understood the request but refuses to fulfill it. A server that wishes to make public why the request has been forbidden can describe that reason in the response content (if any).\n>\n> If authentication credentials were provided in the request, the server considers them insufficient to grant access. The client SHOULD NOT automatically repeat the request with the same credentials. The client MAY repeat the request with new or different credentials. However, a request might be forbidden for reasons unrelated to the credentials.\n\nRFC9110 HTTP Semantics\n\nWhen authentication credentials are provided, and the server returns 403, the test outcome is \`failed\`. This is based on \"If authentication credentials were provided in the request, the server considers them insufficient to grant access\" from RFC9110 above. \`failed\` seems appropriate *for the provided inputs* because status 403 communicates that the server received the provided credentials, determined they cannot authorize the request, and that the client SHOULD NOT retrying the request with the same credentials. \`failed\` should draw attention to either flawed authorization logic or, more likely, an inappropriate \`authorization\` input passed to the test.\n\nIf no input \`authorization\` is provided, the test outcome is \`CannotTell\`. This is because there isn't enough evidence for another outcome, and it's best for a human to take a look at the rest of the result and decide what to do next.\n\nServer implementers are encouraged to review [RFC7235 for HTTP Authentication](https://datatracker.ietf.org/doc/html/rfc7235), which describes a way of responding to requests that lack proof of authorization by using a \`401\` status code + hints about what authorization is required.\n\n## Test Cases\n\nThese are test cases for this test itself, i.e. each test case is a set of test inputs and the corresponding test results.\n\n### simple passed case\n\ninputs\n\n* \`outbox\`\n\n    \`\`\`url\n    https://socialweb.coop/activitypub/testing/utilities/response?status=201\`\n    \`\`\`\n\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`response\`\n\n    \`\`\`http\n    HTTP/2 201 \n    content-type: application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"\n\n    {}\n    \`\`\`\n\n    * outcome: \`passed\`\n\n### nginx 404 response body\n\ninputs\n\n* \`outbox\`: \`https://socialweb.coop/activitypub/testing/utilities/response?status=404\`\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`response\`:\n\n    \`\`\`http\n    HTTP/2 404 \n    content-type: text/html; charset=UTF-8\n    content-length: 153\n\n    \n    404 Not Found\n    \n    404 Not Found\n    nginx/1.25.2\n    \n    \n    \`\`\`\n\n    * outcome: \`cantTell\`\n\n### non-URI input \`outbox\`\n\ninputs\n\n* \`outbox\`: \`bafybeib5mvfjatmpswc3jnh7ydz4zxe25cm63xp6aafpg3j2awakf63qma\`\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\nresult\n\n* outcome: \`inapplicable\`\n    * rationale: input \`outbox\` is not a URI\n\n### without authorization, response status 401\n\ninputs\n\n* \`outbox\`: \`https://socialweb.coop/activitypub/testing/utilities/response?status=401\`\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`response\`:\n\n    \`\`\`http\n    HTTP/1.1 401 Forbidden\n    \n    401\n    \`\`\`\n\nresult\n\n* outcome: [\`cantTell\`](https://www.w3.org/TR/EARL10-Schema/#cantTell)\n\n### response status 405 Method Not Allowed\n\ninputs\n\n* \`outbox\`: \`https://socialweb.coop/activitypub/testing/utilities/response?status=405\`\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`response\`:\n\n    \`\`\`http\n    HTTP/1.1 405 Not Allowed\n    \n    405\n    \`\`\`\n\n* outcome: \`inapplicable\`\n    * rationale: input \`response\` status 405 indicates that requests with method \`POST\` are not supported, so this test does not apply (see 'Applicability')\n\n### without authorization, response status 403 Forbidden\n\ninputs\n\n* \`outbox\`: \`https://socialweb.coop/activitypub/testing/utilities/response?status=403\`\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`response\`:\n\n    \`\`\`http\n    HTTP/1.1 403 Forbidden\n    \n    403\n    \`\`\`\n\nresult\n\n* outcome: [\`cantTell\`](https://www.w3.org/TR/EARL10-Schema/#cantTell)\n\n### with authorization, response status 403 Forbidden\n\ninputs\n\n* \`outbox\`: \`https://socialweb.coop/activitypub/testing/utilities/response?status=403\`\n* \`authorization\`: \`Bearer foo\`\n* \`submission\`\n\n    \`\`\`json\n    {\n      \"type\": \"Create\"\n    }\n    \`\`\`\n\ntest targets\n\n* \`response\`:\n\n    \`\`\`http\n    HTTP/1.1 403 Forbidden\n    \n    403\n    \`\`\`\n\nresult\n\n* outcome: [\`failed\`](https://www.w3.org/TR/EARL10-Schema/#failed)\n\n## Glossary\n\n### \`outcome\`\n\nAn outcome is a conclusion that comes from evaluating a test on a test subject. An outcome can be one of the three following types:\n\n* \`inapplicable\`: No part of the test subject matches the applicability\n* \`passed\`: A test target meets all expectations\n* \`failed\`: A test target does not meet all expectations\n\n## Requirements Mapping\n\n* [ActivityPub requirement 3b925cdf-89fe-4f51-b41f-26df23f58e0c](https://socialweb.coop/activitypub/behaviors/3b925cdf-89fe-4f51-b41f-26df23f58e0c) - Servers MUST return a 201 Created HTTP code\n    * Required for Conformance to [ActivityPub][activitypub]\n    * Outcome Mapping\n        * when test target \`response\` has outcome \`passed\`, further testing is needed to determine requirement satisfaction\n        * when test target \`response\` has outcome \`failed\`, requirement is not satisfied\n        * when test target \`response\` has outcome \`inapplicable\`, further testing is needed to determine requirement satisfaction\n\n## Issues\n\n* [x] host an example outbox that can be used as the \`passed\` test case for this\n    * it should always respond with http response 201\n    * 2023-12-22T18:20:55.076Z: done: \n\n## Change Log\n\n* 2024-01-04T00:25:23.095Z - add support for read-only outboxes - i.e. a response with status 405 MUST result in an \`inapplicable\` test outcome.\n* 2024-01-07T21:39:50.838Z - add support for http responses with status 401, 403, 404\n",
	  "name": "Outbox Servers handling activity submissions MUST return a 201 created HTTP status code",
	  "passedCases": [
	    {
	      "name": "1. simple passed case",
	      "input": {
	        "outbox": "https://socialweb.coop/activitypub/testing/utilities/response?status=201",
	        "submission": "{\"type\":\"Create\"}"
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    }
	  ],
	  "slug": "outbox-post-servers-must-return-a-201-created-http-code",
	  "uuid": "723afcbb-118d-433e-8ab4-560ffca93582",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:3b925cdf-89fe-4f51-b41f-26df23f58e0c",
	      "url": "https://socialweb.coop/activitypub/behaviors/3b925cdf-89fe-4f51-b41f-26df23f58e0c/"
	    }
	  ]
	}
	```
- [Outbox Servers handling submissions MUST accept a valid object that isn't a subtype of Activity](https://activitypub-testing.socialweb.coop/test-cases/outbox-post-must-accept-non-activity-object)
	```
	{
	  "description": "This test checks that an ActivityPub Outbox accepts submission of an ActivityPub Object that is not an Activity, e.g. a Note, which it should then wrap in a Create activity.",
	  "failedCases": [],
	  "inapplicableCases": [],
	  "input": {
	    "outbox": {
	      "help": "the url to the Outbox handling an Activity POST request",
	      "required": true,
	      "type": "xsd:anyUri",
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#outbox"
	      ]
	    },
	    "authorization": {
	      "help": "proof of authorization. This will be included in the HTTP Authorization header for the POST outbox request",
	      "required": false,
	      "type": [
	        "xsd:string",
	        "https://activitypub-testing.socialweb.coop/ns/HiddenInTestResults"
	      ],
	      "rangeIncludes": [
	        "https://www.rfc-editor.org/rfc/rfc9110#field.authorization.value"
	      ]
	    },
	    "submission": {
	      "help": "the object to send to the outbox.",
	      "required": false,
	      "default": "{ \"type\": \"Note\", \"@context\": [\"https://www.w3.org/ns/activitystreams\"] }"
	    },
	    "time": {
	      "help": "amount of time allowed to run test, as IETF RFC3339 dur-time time duration. This is meant to configure the limit for how long this test will wait for network requests.",
	      "required": true,
	      "default": "T5S",
	      "type": [
	        "rfc3339:dur-time",
	        "TimeLimit"
	      ],
	      "constraints": [
	        {
	          "content": " MUST be an [RFC3339 \`dur-time\`](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A)",
	          "mediaType": "test/markdown"
	        }
	      ]
	    }
	  },
	  "name": "Outbox Servers handling submissions MUST accept a valid object that isn't a subtype of Activity",
	  "passedCases": [],
	  "slug": "outbox-post-must-accept-non-activity-object",
	  "uuid": "77748b50-f58c-49e7-8986-98e520b0e890",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:b7b352f2-906b-492d-b64d-20bab5c2ea73",
	      "url": "https://socialweb.coop/activitypub/behaviors/b7b352f2-906b-492d-b64d-20bab5c2ea73"
	    }
	  ]
	}
	```
- [Outbox Wraps Object With Create Activity](https://activitypub-testing.socialweb.coop/test-cases/outbox-wraps-object-with-create-checked-using-get-location)
	```
	{
	  "name": "Outbox Wraps Object With Create Activity",
	  "description": "a test rule that submits an object to an outbox and checks for conformance with requirements for how the outbox server must wrap the object in a Create Activity.",
	  "slug": "outbox-wraps-object-with-create-checked-using-get-location",
	  "input": {
	    "outbox": {
	      "help": "URL of ActivityPub outbox that an object will be sent to",
	      "required": true,
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#outbox"
	      ]
	    },
	    "authorization": {
	      "help": "HTTP Authorization header value that will be sent with ActivityPub requests",
	      "required": false,
	      "type": [
	        "xsd:string",
	        "https://activitypub-testing.socialweb.coop/ns/HiddenInTestResults"
	      ],
	      "rangeIncludes": [
	        "https://www.rfc-editor.org/rfc/rfc9110#field.authorization.value"
	      ]
	    }
	  },
	  "applicability": "\nThis test applies to an ActivityPub Server handling POST requests to an ActivityPub Outbox.\n\nTest Targets\n* outbox: same value as input.outbox\n",
	  "inapplicableCases": [],
	  "passedCases": [],
	  "failedCases": [],
	  "uuid": "963a2313-788e-4bb7-b6ea-0d8bf7d255ef",
	  "isPartOf": [
	    "https://socialweb.coop/activitypub/test-cases/"
	  ],
	  "requirementReference": [
	    {
	      "id": "urn:uuid:e6d00349-6d07-4512-9a99-f698d3bc1dba",
	      "url": "https://activitypub-testing.socialweb.coop/e6d00349-6d07-4512-9a99-f698d3bc1dba"
	    },
	    {
	      "id": "urn:uuid:104e2cde-f072-43af-badd-bf9bd4129151",
	      "url": "https://activitypub-testing.socialweb.coop/104e2cde-f072-43af-badd-bf9bd4129151"
	    },
	    {
	      "id": "urn:uuid:f3725db1-1e6b-4d20-9cea-a49ef4291e9f",
	      "url": "https://activitypub-testing.socialweb.coop/f3725db1-1e6b-4d20-9cea-a49ef4291e9f"
	    }
	  ],
	  "testCases": [
	    {
	      "name": "outbox=https://socialweb.coop/outbox",
	      "id": "urn:uuid:d7c8b377-2850-481b-992f-92ac437a9f3c",
	      "input": {
	        "outbox": "https://socialweb.coop/outbox"
	      },
	      "result": {
	        "outcome": "passed"
	      }
	    },
	    {
	      "name": "outbox=https://example.com",
	      "id": "urn:uuid:dde952d7-b9b0-488f-8b06-61a10ba134d4",
	      "input": {
	        "outbox": "https://example.com/"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "expectations": "\n* target \`outboxPostLocationResponse\` http request body must be a JSON string that parses to a JSON Object called \`outboxPostResult\`\n* \`outboxPostResult\` must have a \`type\` property whose value is either the string \"Create\" or an Array containing the string \"Create\"\n* \`outboxPostResult\` must have a \`object\` property whose value includes the object from test target \`submission\` (i.e. the object that was sent to the outbox, and should have been wrapped in a Create).\n* \`outboxPostResult\` must have a \`id\` property whose value is a URI\n* \`outboxPostResult.object\` must have a \`id\` property whose value is a URI\n* every value linked from  \`submission\` using the to, bto, cc, bcc, and audience properties must be included in the values for the same property in \`outboxPostResult\`\n* every value linked from  \`submission\` using the to, bto, cc, bcc, and audience properties must be included in the values for the same property in \`outboxPostResult.object\`\n"
	}
	```
- [post outbox server must overwrite id property](https://activitypub-testing.socialweb.coop/test-cases/post-outbox-server-overwrites-id-property)
	```
	{
	  "name": "post outbox server must overwrite id property",
	  "description": "A Test Rule for an ActivityPub Requirement",
	  "applicability": "\nHow to derive test targets from input:\n* let postOutboxResponse be the http response from using an activitypub client to post to input.outbox\n* if postOutboxResponse does not contain a 'location' header, result outcome is inapplicable.\n* let outboxResultResponse be the response from using an activitypub client to fetch an activitypub object for the URL indicated by the value of the postOutboxResponse http response header named 'location'\n* let target.result be the result of parsing outboxResultResponse http response body as JSON. If the response body is not a JSON object, result outcome is inapplicable.\n",
	  "expectations": "\n* target.result must be a JSON object\n* target.result.id MUST not be the same as input.submission.id\n    * rationale: the requirement is that the submission.id MUST be overwrittedn/ignored\n* target.result.id MUST be a string\n    * rationale: the requirement says the server MUST generate a new id\n",
	  "slug": "post-outbox-server-overwrites-id-property",
	  "uuid": "30018b5d-699a-45a9-a623-1f09a36cf0a6",
	  "requirementReference": [
	    {
	      "id": "urn:uuid:2bdc4682-308f-42ae-87cf-847f62f64e36",
	      "url": "https://activitypub-testing-website.socialweb.coop/2bdc4682-308f-42ae-87cf-847f62f64e36"
	    }
	  ],
	  "input": {
	    "outbox": {
	      "help": "the url to the Outbox handling an Activity POST request",
	      "required": true,
	      "type": "xsd:anyUri",
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#outbox"
	      ]
	    },
	    "authorization": {
	      "help": "HTTP Authorization header value to include in outbox POST request",
	      "required": false,
	      "type": [
	        "xsd:string",
	        "https://activitypub-testing.socialweb.coop/ns/HiddenInTestResults"
	      ],
	      "rangeIncludes": [
	        "https://www.rfc-editor.org/rfc/rfc9110#field.authorization.value"
	      ]
	    }
	  },
	  "passedCases": [],
	  "inapplicableCases": [
	    {
	      "name": "404 response outbox",
	      "input": {
	        "outbox": "https://socialweb.coop/activitypub/testing/utilities/response?status=404"
	      },
	      "result": {
	        "outcome": "inapplicable"
	      }
	    }
	  ],
	  "attributedTo": [
	    {
	      "name": "bengo",
	      "url": "https://bengo.is/"
	    },
	    {
	      "name": "codenamedmitri"
	    }
	  ]
	}
	```
- [Check that outbox post server added to outbox collection by getting the outbox collection and looking in the items](https://activitypub-testing.socialweb.coop/test-cases/outbox-post-server-adds-to-outbox-collection-checked-by-outbox-get)
	```
	{
	  "name": "Check that outbox post server added to outbox collection by getting the outbox collection and looking in the items",
	  "input": {
	    "outbox": {
	      "help": "the url to the Outbox handling an Activity POST request",
	      "required": true,
	      "type": "xsd:anyUri",
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#outbox"
	      ]
	    },
	    "authorization": {
	      "help": "HTTP Authorization header value to include in outbox POST request",
	      "required": false,
	      "type": [
	        "xsd:string",
	        "https://activitypub-testing.socialweb.coop/ns/HiddenInTestResults"
	      ],
	      "rangeIncludes": [
	        "https://www.rfc-editor.org/rfc/rfc9110#field.authorization.value"
	      ]
	    }
	  },
	  "description": "a test rule that sends a submission to an outbox then gets the outbox and expects to find the submitted activity",
	  "applicability": "\nHow to derive test targets from input:\n* let outboxPostResponse be the http response from using an activitypub client to post to input.outbox\n* if outboxPostResponse does not contain a 'location' header, result outcome is inapplicable.\n* let resultLocation be the result of [Reference Resolution (rfc3986)](https://www.rfc-editor.org/rfc/rfc3986#section-5) with Base URI set to input.outbox and reference set to the value of the 'location' header in outboxPostResponse.\n  * If the value of the location header is already an absolute url, resultLocation will be set to that value. If it's a relative url, it will be resolved relative to the outbox url.\n* let target.newActivityId equal resultLocation\n* let outboxGetResponse be the http response from using an activitypub client to fetch the ActivityPub object at input.outbox. If input.authorization is provided, it MUST be passed as the value of the http header named authorization.\n* if outboxGetResponse http status is not in range [200, 299], return early. The outcome is 'inapplicable'. This test only applies when the test client can get a successful response to the get request.\n* let target.outbox be the result of parsing outboxGetResponse body as JSON\n",
	  "assumptions": "\n* we assume that the outbox post response location header includes the id of the newly submitted activity.\n  * another requirement is outbox post servers [\"MUST include the new id in the Location header\"](https://activitypub-testing-website.socialweb.coop/00330762-59a2-4072-8d93-87ee4c30411c), so it seems like this is a reasonable assumption for servers that satisfy that requirement\n",
	  "expectations": "\n* let types be the result of\n  * if target.outbox.type is an Array, return it\n  * return an array containing only target.outbox.type\n* let items be the result of\n  * if types includes \"OrderedCollection\", return target.outbox.orderedItems\n  * else return target.outbox.items\n* at least one entry in items must have an id property equal to target.newActivityId\n",
	  "slug": "outbox-post-server-adds-to-outbox-collection-checked-by-outbox-get",
	  "uuid": "43d3465d-6f5a-47c2-99ad-44bd883472b3",
	  "requirementReference": [
	    {
	      "id": "urn:uuid:58b55b12-550f-415d-9ce4-a5160c08676f",
	      "url": "https://activitypub-testing-website.socialweb.coop/58b55b12-550f-415d-9ce4-a5160c08676f"
	    }
	  ]
	}
	```
- [Create then Update modifies an Object as checked by getting the Object after the Update](https://activitypub-testing.socialweb.coop/test-cases/create-then-update-modifies-object-checked-by-get)
	```
	{
	  "name": "Create then Update modifies an Object as checked by getting the Object after the Update",
	  "description": "A test rule that sends to an ActivityPub Outbox a Create Activity creating an Object, then sends an Update Activity for that object, then sends an http get to the object URI and expects the object to be modified by the Update.",
	  "slug": "create-then-update-modifies-object-checked-by-get",
	  "uuid": "08efdc1e-195e-4e36-a2b3-e33205bb737b",
	  "input": {
	    "outbox": {
	      "help": "the url to the Outbox handling an Activity POST request",
	      "required": true,
	      "type": "xsd:anyUri",
	      "rangeIncludes": [
	        "https://www.w3.org/ns/activitystreams#outbox"
	      ]
	    },
	    "authorization": {
	      "help": "HTTP Authorization header value to include in outbox POST request",
	      "required": false,
	      "type": [
	        "xsd:string",
	        "https://activitypub-testing.socialweb.coop/ns/HiddenInTestResults"
	      ],
	      "rangeIncludes": [
	        "https://www.rfc-editor.org/rfc/rfc9110#field.authorization.value"
	      ]
	    }
	  },
	  "applicability": "This test applies only when it is possible to\nsend a Create activity submission to the outbox,\nfollow the response Location header to the result of submission,\ninspect the resulting activity to see the id provisioned for its object,\nsend an Update activity to update that object,\nfetch the object,\nand determine whether the update occurred.\n\nTo derive test targets, we'll need to do the above and make serveral requests:\n* POST outbox with a Create to create an object\n* fetch the result of that to determine the object id\n* POST outbox with an Update to update the object with that id\n* fetch the object by id\n\nHow to derive test targets from input:\n* input.outbox MUST be a URI\n* let create be \`{\"type\": \"Create\": \"object\": {\"type\":\"Note\",\"content\":\"v0\"}}\`\n* let createObjectResponse be the http response from using an ActivityPub Client to send create to input.outbox including, if available, input.authorization as the Authorization header\n* let createObjectLocation be the value of createObjectResponse's http response header named 'location'. If it is a relative URI, resolve it to an absolute uri using a base uri of input.outbox.\n* let fetchedCreate be the result of using an activitypub client to fetch the ActivityPub object at createObjectLocatioh. If available, send input.authorization as the Authorization header.\n* let createdObjectId be fetchedCreate.object.id. This should be a URI assigned by the outbox server.\n* let update be \`{\"type\": \"Update\", \"object\": { \"id\": createdObjectId, \"content\": \"v1\" }}\`\n* use an ActivityPub Client to send update to input.outbox\n* the test runner may wait some time to allow the outbox server to process the update\n* let objectV1Response be the http response from using an ActivityPub Client to fetch the ActivityPub Object at createdObjectId\n* let target.objectV1 be the response body of objectV1Response",
	  "expectations": "* target.objectV1 MUST be a JSON object\n* target.objectV1.content MUST be \`\"v1\"\`",
	  "requirementReference": [
	    {
	      "id": "urn:uuid:c1cd98fe-ae9c-48a7-9b43-cdd8eb008bc8",
	      "url": "https://activitypub-testing-website.socialweb.coop/c1cd98fe-ae9c-48a7-9b43-cdd8eb008bc8"
	    }
	  ]
	}
	```
