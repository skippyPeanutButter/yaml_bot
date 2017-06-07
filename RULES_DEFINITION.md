# YAMLBOT RULES DEFINITION

This document details YamlBot rules specification. Using the details discussed
below, users can craft their own `.yamlbot.yml` rules for validating yaml-based
files according to a specification. Examples of yaml-based tools that can be
validated include [travis-ci](https://travis-ci.org/),
[rubocop](https://github.com/bbatsov/rubocop), and
[jervis](https://github.com/samrocketman/jervis).

The general layout of a `.yamlbot.yml` file is as follows:

```yaml
defaults:
  'default values for rules'
rules:
  - key: 'yaml.address'
    required_key: true|false
    and_requires: ['list of yaml addresses']
    or_requires: ['list of yaml addresses']
    value_whitelist: ['list of values']
    value_blacklist: ['list of values']
    types: ['list of types']
```

### Key definitions

- `defaults` - This section of the rules file is where default values can be
  specified for the keys `required_key`, `and_requires`,
  `or_requires`, `value_whitelist`, `value_blacklist`, and 'types'.
  This key is optional if a user does not wish to specify defaults.

  Note: Specific values defined under individual keys will override
  any default values.

- `rules` - This section is where the rules for yaml file validation are
  specified. This key is required for `YamlBot` to successfully parse
  the rules file.

- `key` - This key is *required*. A rules file must be made up of a
  list of keys that need to be validated. `key` requires a string value,
  which denotes the name of the key being validated. If a user desires
  to validate a nested key, then `.` delimiter must be used to denote
  the parent-child relationship of nested keys.

  Example:
  Sample .yamlbot.yml

  ```yaml
    rules:
      - key: person.age
        required_key: true
        types: [number]
  ```

  Sample yaml file being validated

  ```yaml
    person:
      age: 43
  ```

  Nested keys can be specified up to `nth` level of nesting using the
  `.` delimiter.

- `required_key` - This key is *required* only if it is not defined in
  the `defaults` section. Every key in the list of key being
  validated must be specified as required or not.

- `and_requires` - This key is optional. It determines additional keys that
  *must* be part of the yaml file being validated if a
  particular key is defined.

  Example:
  ```yaml
  rules:
   - key: keya
     required_key: false
     and_requires: [keyb]
  ```
  The above rules specifies that if `keya` is defined in the
  yaml file being validated, then `keyb` must also be defined
  for the yaml file to be successfully validated.

- `or_requires` - This key is optional, if a particular key is a required_key
  and is missing, then a yaml file may still be valid if any of
  the keys in the `or_requires` list exists and is properly
  defined.

  Example:
  ```yaml
  rules:
    - key: keya
      required_key: true
      and_requires: [keyb]
  ```
  The above rules specifies that if `keya` is required in the
  yaml file being validated and is missing, then the yaml file
  will still be marked as valid if `keyb` exists in the yaml
  file with a valid value.

- `value_whitelist` - This key is optional. It defines a list of possible values
  that a key may take on. If this list is defined and a key
  does not have a value specified within this list then that
  key will fail validation.

- `value_blacklist` - This key is optional. It defines a list of values that a
  key may *not* take on. If this list is defined and a key
  has a value defined in this list, then that key will fail
  validation.

- `types` - This key is optional. It defines a list of the possible data types
  that a key's value may be.
  Possible types include 'list', 'object', 'string', 'boolean',
  'number'.

  Example:
  ```yaml
  - key: age
    required_key: true
    types: [number]
  - key: ethnicity
    required_key: false
    types: [string, list]
  ```

  Types are denoted in yaml as follows.

  *List*
  key `groceries` takes an array of items as its value

  ```yaml
    groceries:
      - apples
      - bananas
      - carrots
    or

    groceries: [apples, bananas, carrots]
  ```

  *Object*
  key `car` takes a map/hash of keys with their own values

  ```yaml
    car:
      wheels: 4
      transmission: automatic
      color: blue
  ```

  *String*
  key 'name' takes a string literal as its value

  ```yaml
    name: Louis
  ```

  *Boolean*
  key `can_fly` takes a boolean as its value

  ```yaml
    can_fly: false
  ```

  *Number*
  key `age` takes an integer number as its value
  key `price` takes a floating point number as its value

  ```yaml
    age: 2
    price: 3.99
  ```
### Examples

The examples that follow specify several sample yaml files and their accompanying
`.yamlbot.yml` files used to validate them.

```yaml
defaults:
  required_key: true
rules:
  - key: person
    types: [object]
  - key: person.name
    types: [string]
  - key: person.age
    types: [number]
  - key: person.haircolor
    required_key: false
    types: [string]
  - key: person.race
    types: [string]
    value_whitelist: [dwarf, highelf, human, orc, hobbit]
```

```yaml
person:
  name: Frodo
  age: 20
  race: hobbit
```

The above yaml file would pass validation due to defining all of the required
keys with valid values.

---

```yaml
defaults:
  required_key: false
  types: [string, list]
rules:
  - key: language
    types: [string]
    value_whitelist: [c, go, java, objective-c, python, ruby, swift]
  - key: before_install
  - key: install
  - key: before_script
  - key: script
```

```yaml
language: java
install:
  - export JAVA_HOME='/usr/bin/java1.8/'
  - mvn install
script: mvn test
```

The above yaml file would pass validation due to defining all of the keys with
valid values. Although, an empty yaml file would've passed validation due to
no keys being marked as *required* in the `defaults` section.

---

```yaml
rules:
  - key: bookshelf_items
    required_key: true
    types: [string, list]
  - key: toybox_items
    required_key: false
    types: [string, list]
    value_blacklist: [legos, barbies, hotwheels]
```

```yaml
toybox:
  - 'barbies'
  - 'batman'
  - 'beanie baby'
bookshelf_items:
  - 'Brittanica Encyclopedia'
  - 'How to adult for dummies'
  - 'YAML for beginners'
```

The above yaml file would fail validation due to defining the `toybox_items`
key with a blacked listed value.
