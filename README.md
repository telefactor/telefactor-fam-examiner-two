# New repo, who dis?

Wattup, fam?! Welcome to `fam`, fam. Fam is:

> The **only** CLI for building family trees.™
>
> Created by the child of Real-Life Parents™: `jonbwhite`
>
> Certified "Not Broken"™ by: `kcheung`



## What do I do?

So you're thinking:

> I've got this code.
>
> I've run through the setup.
>
> Now, [what am I gonna do?](https://youtu.be/tpD00Q4N6Jk)

Well, you're either a _examiner_ or an _sourcerer_.

### Examiner

If you're an examiner, the `lib/fam/family` module should have a bunch of code in it.
The `spec/family` directory, on the other hand, should be just about empty.

It's up to you to write tests inside of `spec/family`
(and maybe little in `spec/spec_helpers`)
to validate the behavior of the family tree logic.

Depending how confident you are with the implementation and your understanding
of how the app is "supposed" to work, you might add code which...

* Tests some behavior, and passes because the implementation works with it.
* Tests some behavior, but fails because the implementation doesn't work how you think it should.
* Doesn't test some behavior because it's just so obvious it works.
* Doesn't test some behavior it's impossible!

That's all the hints you get. So helpful, huh?

### Sourcerer

If you're a sourcerer, the `lib/fam/family` module should be a just about empty.
The `spec/family` directory should have a bunch of failing tests which verify
that emptiness!

It's up to you to write source code inside of `lib/fam/family` and `lib/fam.rb`
to make those tests pass.

Depending how confident you are with the tests and your understanding
of how the app is "supposed" to work, you might add code which...

* Implements some behavior, and passes the tests because they work together.
* Implements some behavior, but fails the tests because the tests don't work how you think they should.
* Doesn't implement some behavior because the tests don't call for it.
* Doesn't implement some behavior because it's impossible!

That's all the hints you get. The clock is ticking.

## Setup

### 1. Ensure you have Ruby 2.6 and Bundler 2.

You're probably going to want to use RVM or rbenv to manage this.

### 2. Install

```sh
bundle install
```

Note: this and all commands listed here are run from the project root directory,
that is, the one which contains `fam.gemspec`.

### 3. Run

```sh
bundle exec fam
```

Or

```sh
./exe/fam
```

Both should work.

The default output will be a help with a summary of the commands that we'll implement.

Get the help for a particular command:

```sh
bundle exec fam add parents --help
./exe/fam g gpt --help
```

### 4. Test

Run the tests which examiners are supposed to write:

```sh
bundle exec rspec spec/fam
```

Run the slow CLI & I/O tests which don't change between rounds:

```sh
bundle exec rspec spec/boilerplate
```

Run all the tests:

```sh
bundle exec rspec
```

### 5. Lint

Don't burn time conforming to the style rules in this project, but use them
as guidelines.

```sh
bundle exec rubocop
```

Want to automatically conform to the project style? Run this:

```sh
bundle exec rubocop --auto-correct
```

## Golden rule

Don't forget:

> Have fun, be courteous of others.

All other rules can be bent in service of this rule.
