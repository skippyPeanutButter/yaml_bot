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
