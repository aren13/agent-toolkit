# [Topic] Reference

> **Last Updated:** YYYY-MM-DD

Brief description of what this reference contains (1-2 sentences).

---

## Table of Contents

- [Overview](#overview)
- [Category 1](#category-1)
- [Category 2](#category-2)
- [Examples](#examples)
- [See Also](#see-also)

---

## Overview

High-level explanation of what this reference covers:

- What it is
- When to use it
- What's included in this reference

---

## [Category 1]

Description of this category.

| Property | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `property_name` | string | `"value"` | Yes | What this property does |
| `another_property` | integer | `10` | No | What this property does |
| `flag` | boolean | `false` | No | What this flag controls |

**Notes:**
- Important note about this category
- Another important note

---

## [Category 2]

### [Subcategory]

Description of subcategory.

**Available Options:**

#### `option_name`

**Type:** string
**Default:** `"default_value"`
**Required:** No

Description of what this option does and when to use it.

**Example:**
```yaml
option_name: "example_value"
```

#### `another_option`

**Type:** integer
**Default:** `100`
**Required:** No

Description...

---

## [Category 3]

For categories with many items, use table format:

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `timeout` | integer | `30` | Request timeout in seconds |
| `retries` | integer | `3` | Number of retry attempts |
| `host` | string | `"localhost"` | API host address |
| `port` | integer | `3000` | API port number |
| `ssl` | boolean | `true` | Enable SSL/TLS |

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_KEY` | Yes | - | API authentication key |
| `API_SECRET` | Yes | - | API secret for signing |
| `LOG_LEVEL` | No | `"info"` | Logging verbosity (debug, info, warn, error) |

---

## Examples

### Example 1: [Common Use Case]

Description of what this example shows.

```ruby
# Complete working example
Config.new(
  timeout: 60,
  retries: 5,
  host: "api.example.com"
)
```

**Result:**
```
Expected output or behavior
```

### Example 2: [Another Use Case]

Description...

```yaml
# Configuration file example
api:
  host: "api.example.com"
  port: 443
  ssl: true
  timeout: 60
```

### Example 3: [Advanced Use Case]

```ruby
# More complex example
# with comments explaining each part
result = Client.new do |config|
  config.timeout = 120  # Extended timeout for large requests
  config.retries = 10   # More retries for critical operations
end
```

---

## Common Patterns

### Pattern 1: [Pattern Name]

When to use this pattern and why.

```ruby
# Pattern implementation
example_code
```

### Pattern 2: [Pattern Name]

Description...

---

## Validation Rules

*If applicable:*

| Field | Rules | Example |
|-------|-------|---------|
| `email` | Valid email format | `user@example.com` |
| `age` | Integer between 0-120 | `25` |
| `status` | One of: active, inactive, pending | `"active"` |

---

## API Endpoints

*If this is API reference:*

### GET `/api/v1/resource`

**Description:** Brief description of what this endpoint does.

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Resource identifier |
| `format` | string | No | Response format (json, xml). Default: json |

**Response:**

```json
{
  "id": "123",
  "name": "Example",
  "status": "active"
}
```

**Status Codes:**

| Code | Description |
|------|-------------|
| 200 | Success |
| 404 | Resource not found |
| 400 | Invalid parameters |

**Example Request:**

```bash
curl -X GET https://api.example.com/api/v1/resource/123 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Error Codes

*If applicable:*

| Code | Name | Description | Resolution |
|------|------|-------------|------------|
| `E001` | InvalidInput | Input validation failed | Check input format |
| `E002` | NotFound | Resource not found | Verify resource ID |
| `E003` | Unauthorized | Authentication failed | Check credentials |

---

## See Also

- [Related Reference](./related-reference.md) - Brief description
- [Guide Using This Reference](./related-guide.md) - Brief description
- [Feature Documentation](./related-feature.md) - Brief description
- [External Documentation](https://example.com) - Brief description

---

## Changelog

*Optional section for versioned references:*

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | YYYY-MM-DD | Added new options X, Y, Z |
| 1.0 | YYYY-MM-DD | Initial release |
