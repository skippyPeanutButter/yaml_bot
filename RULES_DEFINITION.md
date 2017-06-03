```yaml
defaults:
  <default values for rules>
rules:
  - key: 'yaml address'
    required_key: true|false
    and_requires: ['list of yaml addresses']
    or_requires: ['list of yaml addresses']
    value_whitelist: ['list of values']
    value_blacklist: ['list of values']
    types: ['list of types']
```

* `key` - Required part of a rules file. A rules file must be made up of a
          list of keys that need to be validated.
* `required_key` - Required part of a rules file only if it is not defined in
                   the `defaults` section.
* `and_requires` - Optional key, determines additional keys that *must* be part
                   of a yaml file, if a particular key is defined.
* `or_requires` - Optional key, if a particular key is a required_key and is
                  missing, then a yaml file may still be valid if any of the
                  keys in the `or_requires` list exists and is properly defined.
* `value_whitelist` - Optional key, defines a list of possible values that a key
                      may take on. If this list is defined and a key does not
                      have a value specified within this list then that
                      key will fail validation.
* `value_blacklist` - Optional key, defines a list of values that a key may
                      *not* take on. If this list is defined and a key has a
                      value defined in this list, then that key will fail
                      validation.
* `types` - Optional key, defines a list of the possible data types that a key's
            value may have.
            Possible types include 'list', 'object', 'string', 'boolean',
            'number'. 
            Example:
            ```
            - key: age
              required_key: true
              types: [number]
            ```
