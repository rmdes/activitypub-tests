---
source: "https://socialweb.coop/activitypub-testing/"
word_count: 620
code repo : /home/rick/code/activitypub-testing
---

`activitypub-testing` is a software [package](https://codeberg.org/socialweb.coop/activitypub-testing) distributed through [npm](https://www.npmjs.com/package/activitypub-testing) containing tools for testing implementations of [ActivityPub](https://www.w3.org/TR/activitypub/), a decentralized social networking protocol.

- [Announcing activitypub-testing: a test runner for ActivityPub Actors](https://socialweb.coop/activitypub-testing/announcement/) @ 2024-10-31

## Overview

At its core, the testing tool consists of a testing engine which runs tests against a given test target in two ways, and three dependencies it draws from:

### cli

The Command-Line Interface runs an individual test and its inputs against a given test target, then returns assertions about the results, whether to `stdout` (the standard interface between processes in a shell) or to `ldjson` (line-delimited JSON) for composing with other tools.

- note: configuration parameters can come from environment variables and/or local file system sources, in addition to per-test inputs
- see [below](https://socialweb.coop/activitypub-testing/#getting-started) for instructions and examples
- see the [code on codeberg.org](https://codeberg.org/socialweb.coop/activitypub-testing/src/branch/main/src/)

### test-actor

The `test-actor` is a javascript runner that takes the URI of an actor and runs all actor-targetable tests it finds in its configuration paths against the targeted actor, whether running in a browser or in another environment

- see [below](https://socialweb.coop/activitypub-testing/#test-runner-cli) for instructions and examples
- [code on codeberg.org](https://codeberg.org/socialweb.coop/activitypub-testing/src/branch/main/src/test-actor.js)

This dataset of behaviors specified by the activitypub protocol, in machine-readable form. The testing of these behaviors is what allows one to make assertions about the conformance of software participating in that protocol. They are hosted [here on this site](https://socialweb.coop/activitypub/behaviors/) in human-readable and navigable form, and the underlying yaml files for each live in [a distinct package](https://codeberg.org/socialweb.coop/activitypub-behaviors).

This subset of the testable behaviors includes only those marked as [RFC2119 MUST](https://datatracker.ietf.org/doc/html/rfc2119) s in the specification. It is also available as a [package](https://codeberg.org/socialweb.coop/activitypub-requirements) and hosted here in [navigable, human-readable form](https://socialweb.coop/activitypub/requirements/).

These match one-to-one the requirements collected above, although some of them require call and depend on others in the set. They are also available sitting alongside the test code each documents in the [activitypub-testing package](https://codeberg.org/socialweb.coop/activitypub-testing/src/branch/main/src/activitypub-tests) and hosted here in [navigable, human-readable form](https://socialweb.coop/activitypub/test-cases/).

## Getting Started

In a [shell](https://en.wikipedia.org/wiki/Shell_\(computing\)#Command-line_shells) with [node.js installed](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs):

### Actor-Tester CLI

```shell
# use env var ACTIVITYPUB_ACTOR but default to https://socialweb.coop
ACTIVITYPUB_ACTOR="${ACTIVITYPUB_ACTOR:-https://socialweb.coop}"

# test the actor
npx activitypub-testing test actor "$ACTIVITYPUB_ACTOR"

# to install \`activitypub-testing\` for use without \`npx\`
npm install -g activitypub-testing

# then this works
activitypub-testing test actor "$ACTIVITYPUB_ACTOR"
```

The above command will dump a lot of JSON objects to [stdout](https://en.wikipedia.org/wiki/Standard_streams#Standard_output_\(stdout\)). See the repository [README](https://codeberg.org/socialweb.coop/activitypub-testing#processing-results-with-jq) for tips on how to wrangle the output e.g. using `jq`

### Actor-Tester JavaScript

Using the actor-testing logic from within a broader JavaScript project can be done by importing and calling the [`ActorUrlTestRun`](https://codeberg.org/socialweb.coop/activitypub-testing/src/branch/main/src/test-actor.js#L15) function.

An example project that does this from inside of a web-browser is hosted [here on this site](https://socialweb.coop/activitypub/actor/tester/); open "view source" in your browser for example syntax.

### Test-Runner CLI

The same `activitypub-testing` npm package also includes the `activitypub-testing` command line tool. The syntax for using it is as follows:

```shell
# browse all the tests
  activitypub-testing get tests [--output=<mediaType>]

  # inspect a single test
  activitypub-testing get test (--uuid=<uuid>|--slug=<slug>) [--output=<mediaType>]

  # run a test
  activitypub-testing run test (--uuid=<uuid>|--slug=<slug>) --input.anyInputName=<input.anyInputName>

  # run tests on a specific ActivityPub Actor
  activitypub-testing test actor <actor-uri> [--output=<mediaType>]

  # print this help
  activitypub-testing [--help|-h] [help]

  ##### options:
  -h --help        Show this help text.
  -o --output      Choose output media type (default \`text\`, also allows \`json\`, \`yaml\`)
  --slug           slug (aka URL-path-friendly human-readable name) of selection
  --uuid           UUID (rfc4122) identifier of selection

  ##### Examples:
  # runs test inbox-must-be-an-orderedcollection[1] against a valid actor fetched via https
  activitypub-testing \
    test \
    --uuid '5e94d155-ed4a-4d71-b797-d7c387736ecf' \
    --input.object="$(curl -s 'https://socialweb.coop/activitypub/actors/with-empty-inbox.json')"

  # run tests on a specific ActivityPub Actor (pipe to \`jq\` to pretty print JSON)
  activitypub-testing \
    test actor \
    https://socialweb.coop
```

Check out the [repository README](https://codeberg.org/socialweb.coop/activitypub-testing#activitypub-testing) for more detailed instructions and examples.

## Implementation Guide

[/activitypub-testing/implementation-guide](https://socialweb.coop/activitypub-testing/implementation-guide)

## Change Log

## Roadmap

- develop at least one test for every [ActivityPub Requirement](https://socialweb.coop/activitypub/requirements/)
	- currently ~11/49
		- ✅ [https://bengo.is/blogging/easy-to-test-activitypub-requirements/](https://bengo.is/blogging/easy-to-test-activitypub-requirements/)

## Issue Tracker

[https://codeberg.org/socialweb.coop/activitypub-testing/src/branch/main/issues](https://codeberg.org/socialweb.coop/activitypub-testing/src/branch/main/issues)
