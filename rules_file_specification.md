# Rules File Specification

This document outlines the proper format for specifying
a proper `.yamlbot.yml` rules file.

```yaml
root_keys:
  required:
    key1:
      subkeys:
        required:
          subkey1:
            accepted_types:
              - String
              - List
          subkey2:
            accepted_types:
              - Integer
        optional:
          subkey3:
            accepted_types:
              - Integer
    key2:
      accepted_types:
        - String
    key3:
      accepted_types:
        - Boolean

  optional:
    key4:
      accepted_types:
        - Integer
```

1. `root_keys` - the yaml keys that are specified as being at the top-most
    level of the yaml file. This key is required in a rules file.
  i. `required` - keys nested directly below a required key are marked as
      necessary for a properly formatted yaml file. The `required` key may be
      listed below the `root_keys` key and the `subkeys` key.
      This key is required in a rules file.
  ii. `optional` - keys nested directly below an optional key may be missing
       from a properly formatted yaml file. The purpose of listing optional keys
       are to validate they contain the values the keys are given if they are
       included. The `optional` key may be listed below the `root_keys` key and
       the `subkeys` key.
       This key is optional in a rules file.
  iii. `subkeys` - keys below the `subkeys` key mark keys that are allowed to
        be below a particular key. `subkeys` take a map of `required` and
        `optional` keys.
        This key is optional in a rules file.
  iv. `accepted_types` - key that is nested below a user defined key. It
       determines the types of data accepted for a particular key. The types are
       defined [types](#Types). To see what ruby objects yaml types are converted to see [yaml for ruby](http://yaml.org/YAML_for_ruby.html).

### Types

```
Array
Hash
String
Integer
Boolean
```
