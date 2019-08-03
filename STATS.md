# Git Log

```
commit 5acf5cebc323fcfd9c02f24cc4e62b945a7a503d
Author: Kyle Cheung <kcheung@squareup.com>
Date:   Sat Aug 3 01:12:52 2019 -0700

    add tests cases to describe fam::familiy and fam
```

# CLOC


cloc|github.com/AlDanial/cloc v 1.82  T=0.06 s (685.8 files/s, 35662.1 lines/s)
--- | ---

Language|files|blank|comment|code
:-------|-------:|-------:|-------:|-------:
Ruby|28|280|180|1230
Markdown|7|68|0|125
Bourne Again Shell|1|6|0|35
JSON|1|0|0|21
YAML|1|6|10|15
--------|--------|--------|--------|--------
SUM:|38|360|190|1426

# Spec Results
## Fam

```

Fam
  .add_person
    add new person
      adds Mr. Burns to family
    adds same person
      does not add existing person
  .add_parents
    add parents for child who does not exist
      fails to find child
    add non-existent parent for child
      fails to find parent
    adds parent to child with 2 parents
      fails to add 3rd parent
    adds parent to child with 1 parents
      adds 2nd parent
    adds parents to child with no parents
      adds both parents
    add child as parent of self
      adds self as parent
  .get_person
    get existing person
      gets Mr. Burns to family
    get non-existent person
      does not get existing person
  .get_parents
    get parents of 2 parent child
      gets both parents
    get parents of single parent child
      gets 1 parent
    get parents of no parent child
      gets no parents
    get parents of non-existent person
      does not get existing child
  .get_grandparents
    get grandparents of 2 parent child
      gets both parents
    get grandparents of single parent child
      gets 1 parent
    get grandparents of no parent child
      gets no parents
    get grandparents of non-existent child
      does not get existing person
    get grandparents using greatness of -1
      gets 1 parent
    get grandparents using greatness of 1
      gets 3rd generation parent

Fam::Family
  .add_parents
    no inputs
      errors with NoSuchPerson
    add child with too many parents
      errors with TooManyParents
    add child with 2 parents
      adds child with 2 parents
    add child with 1 parents
      adds child with 1 parent
    add child with no parents
      does not add parent
    add child with 1 parent and then add 2nd parent
      adds child with 2 parents
  .get_parents
    no inputs
      errors with NoSuchPerson
    get parents of child with 2 parents
      gets 2 parents
    get parents of child with 1 parents
      gets 1 parent
    get parents of child with no parents
      gets no parent
    get 2st generation parents of child with 2 parents
      gets 2nd generation of parents
  .add_person
    no inputs
      adds nil
    add existing person
      errors with DuplicatePerson
    add new person
      adds Luanne
  .get_person
    no inputs
      errors with NoSuchPerson
    get existing person
      returns Bobby
    get person no in family
      errors with NoSuchPerson
  .to_hash
    displays family as hash

Finished in 0.02886 seconds (files took 0.7543 seconds to load)
38 examples, 0 failures

```

## Boilerplate

```

Fam::CLI::Add::Parents
  when the child and parent names are given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when all names are missing
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::CLI::Add::Person
  when a name is given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when no name is provided
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::CLI::Get::Parents
  when a child name is given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when the child name is missing
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::CLI::Get::Person
  when a name is given
    behaves like a successful command
      exits with a zero status code
      matches the expected output
  when the name is missing
    behaves like a failed command
      exits with a non-zero status code
      matches the expected error

Fam::File::Reader::JSONReader
  #read
    when the file does not exist
      raises an error
    when the file exists
      should be a kind of Hash

Fam::File::Writer::JSONWriter
  #write
    should be a kind of String
    modifies the specified file

Finished in 15.22 seconds (files took 0.48867 seconds to load)
20 examples, 0 failures

```

