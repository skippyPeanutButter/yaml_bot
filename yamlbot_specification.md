# Rules File Specification

This document outlines the proper format when specifying rules within a
`.yamlbot.yml` file.

```yaml
root_keys:
  required:
    - key1:
        subkeys:
          required:
            - subkey1:
                accepted_types:
                  - String
                  - List
            - subkey2:
                accepted_types:
                  - Integer
          optional:
            - subkey3:
                accepted_types:
                  - Integer
    - key2:
        accepted_types:
          - String
    - key3:
        accepted_types:
          - Boolean

  optional:
    - key4:
        accepted_types:
          - Integer
    - key5:
        subkeys:
          required:
            key6:
              accepted_types:
                - Integer

```

i.  `root_keys` - the yaml keys that are specified as being at the top-most
     level of the yaml file.
     This key is required in a rules file.

ii. `required` - keys nested directly below a required key are marked as
      necessary for a properly formatted yaml file. The `required` key may be
      listed below the `root_keys` key and the `subkeys` key.
      Any required keys that are defined in a .yamlbot.yml file that are not
      found within the yaml file being validated will generate a violation.

      `required` subkeys may be listed under `optional` keys, in this instance it
      would mean that if an optional key is defined in a yaml file then the
      required subkeys must also be defined.

      This key is required in a rules file if `optional` keys are not specified.

iii. `optional` - keys nested directly below an optional key may be missing
     from a properly formatted yaml file. The purpose of listing optional keys
     are to validate they contain the values the keys are given if they are
     included. The `optional` key may be listed below the `root_keys` key and
     the `subkeys` key. An `optional` key denotes that it may be missing from
     a yaml file and the yamlbot validator will not generate a violation.

     This key is required in a rules file if `required` keys are not specified.

iv. `subkeys` - keys below the `subkeys` key mark keys that are allowed to
      be below a particular key. `subkeys` take a map of `required` and
      `optional` keys.

      This key is optional in a rules file.

v. `accepted_types` - key that is nested below a user defined key. It
     determines the types of data accepted for a particular key. The types are
     defined [types](#Types). To see what ruby objects yaml types are
     converted to see [yaml for ruby](http://yaml.org/YAML_for_ruby.html).

     This key is required, if the parent key does not have a `subkeys` key.

```

### Types

```
Array
Hash
String
Float
Fixnum
TrueClass
FalseClass
```
