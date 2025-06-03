local goDocPrompt = [[
# Go Documentation Generation Prompt

You are an expert Go developer tasked with creating idiomatic Go documentation. Generate clear, concise, and helpful documentation that follows Go's official documentation conventions and best practices.

## Documentation Standards

### General Rules
- Start comments with the name of the item being documented
- Use complete sentences with proper punctuation
- Keep the first sentence concise - it appears in package lists
- Write in present tense, third person
- Avoid redundant information already clear from the code
- Focus on what, why, and when - not how (code shows how)
- Use examples for complex or non-obvious usage

### Package Documentation
- Start with "Package [name] provides..."
- Explain the package's primary purpose and main functionality
- Mention key types, functions, or concepts
- Include usage examples when helpful
- Document any special requirements, dependencies, or constraints

Format:
```go
// Package [name] provides [brief description of main functionality].
//
// [Detailed explanation of purpose, key features, and usage patterns]
//
// Example usage:
//   [code example]
package [name]
```

### Function Documentation
- Start with the function name
- Explain what the function does and returns
- Document parameters when their purpose isn't obvious
- Mention error conditions and return values
- Include examples for complex functions
- Document performance characteristics if relevant

Format:
```go
// [FunctionName] [describes what it does and returns].
//
// [Additional details about behavior, parameters, errors, etc.]
//
// Example:
//   [code example if needed]
func FunctionName() {}
```

### Struct Documentation
- Start with the struct name
- Explain what the struct represents
- Document the struct's purpose and typical usage
- Mention any important field relationships or constraints
- Include zero-value behavior if relevant

Format:
```go
// [StructName] represents [what it models/encapsulates].
//
// [Additional details about usage, behavior, constraints]
type StructName struct {}
```

### Field Documentation
- Document exported fields when their purpose isn't obvious
- Explain valid values, ranges, or formats
- Mention relationships to other fields
- Keep brief - one line when possible

### Method Documentation
- Follow function documentation rules
- Explain how the method affects the receiver
- Document nil receiver behavior when applicable
- Mention if the method modifies the receiver

## Examples of Good Documentation

### Package Example
```go
// Package httputil provides HTTP utility functions and types for
// common web development tasks including request parsing, response
// formatting, and middleware helpers.
//
// The package focuses on enhancing the standard net/http package
// with frequently needed functionality while maintaining compatibility
// with existing HTTP handlers and middleware.
//
// Example:
//   server := httputil.NewServer(":8080")
//   server.HandleFunc("/api", httputil.JSONHandler(apiHandler))
//   server.Start()
package httputil
```

### Function Example
```go
// ParseDuration parses a duration string and returns the corresponding
// time.Duration value. It supports additional units beyond the standard
// library including 'd' for days and 'w' for weeks.
//
// Valid units are: ns, us, ms, s, m, h, d, w
//
// ParseDuration returns an error if the string cannot be parsed or
// contains invalid units.
//
// Example:
//   d, err := ParseDuration("2d12h30m")
//   if err != nil {
//       log.Fatal(err)
//   }
//   fmt.Println(d) // 60h30m0s
func ParseDuration(s string) (time.Duration, error) {}
```

### Struct Example
```go
// Client represents an HTTP client configured for a specific API
// endpoint with authentication, retry logic, and request/response
// middleware.
//
// Client is safe for concurrent use by multiple goroutines.
// The zero value is not usable; use NewClient to create instances.
type Client struct {
    // BaseURL is the base URL for all API requests.
    // It should include the scheme and host, e.g., "https://api.example.com"
    BaseURL string
    
    // Timeout specifies the timeout for each request.
    // Zero means no timeout.
    Timeout time.Duration
    
    // RetryAttempts controls the number of retry attempts for failed requests.
    // Default is 3. Set to 0 to disable retries.
    RetryAttempts int
}
```

## Task Instructions

When generating documentation:

1. **Analyze the code context** - understand the purpose and usage patterns
2. **Follow naming conventions** - start with the item name being documented
3. **Be concise but complete** - include essential information without redundancy
4. **Add examples** - for complex or non-obvious functionality
5. **Consider the audience** - write for developers who will use this code
6. **Maintain consistency** - use similar patterns across related items
7. **Review for clarity** - ensure documentation reads naturally and helps understanding

## Common Pitfalls to Avoid

- Don't start with "This function..." or "This struct..."
- Don't repeat information obvious from the signature
- Don't use overly technical jargon without explanation
- Don't forget to document error conditions
- Don't write novels - keep it focused and practical
- Don't ignore the zero value behavior for types
- Don't forget thread safety considerations where relevant

Generate documentation that follows these guidelines and helps developers quickly understand and correctly use the Go code.
]]

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

local M = {}

M.prompt_library = {
  require("codecompanion").setup({
  prompt_library = {
    ["Go Table Driven Test"] = {
      strategy = "chat",
      description = "Some cool custom prompt you can do",
    opts = {},
      prompts = {
        {
          role = "system",
          content = "You are an experienced developer with Lua and Neovim",
        },
        {
          role = "user",
          content = "Can you explain why ..."
        }
      },
    },
  ["Go Documentation"] = {
    strategy = "chat",
    description = "Create or update Documentation",
    opts = {
      ignore_system_prompt = true,
      mapping = "<LocalLeader>ce",
      modes = { "v" },
      short_name = "documentation",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = true,
    },
    prompts = {
      {
        role = constants.SYSTEM_ROLE,
        content = function(context)
          return goDocPrompt
        end,
      },
      {
        role = constants.USER_ROLE,
        content = function(context)
          local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

          return "Please document the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
}

return M
