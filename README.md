# BVBRC Consolidated MCP Server

A unified Model Context Protocol (MCP) server that consolidates three BVBRC services into a single server:
- **Data Tools**: Query BVBRC Solr collections for genome, feature, and other biological data
- **Service Tools**: Submit and manage BVBRC analysis jobs (assembly, annotation, BLAST, etc.)
- **Workspace Tools**: Manage BVBRC workspace files, folders, and groups

## Features

### Data Tools (MVP)
- `query_collection`: Query any BVBRC Solr collection with flexible filtering
- `solr_collection_parameters`: Get schema information for collections
- `solr_query_instructions`: Get help on query syntax
- `solr_collections`: List all available collections

### Service Tools
- `list_service_apps`: List all available BVBRC analysis services
- `get_job_details`: Query the status of submitted jobs
- Submit jobs for various analyses:
  - Genome Assembly
  - Genome Annotation
  - Comprehensive Genome Analysis
  - BLAST
  - Primer Design
  - Variation Analysis
  - TnSeq
  - Phylogenetic Trees (Bacterial Genome Tree, Gene Tree)
  - SNP Analysis (Whole Genome, MSA)
  - Metagenomics (Taxonomic Classification, Binning, Read Mapping)
  - RNA-Seq
  - Viral Services (SARS-CoV-2 Analysis, Sequence Submission)
  - And many more...

### Workspace Tools
- `workspace_ls_tool`: List workspace contents
- `workspace_search_tool`: Search workspace for files
- `workspace_get_file_metadata_tool`: Get file metadata
- `workspace_download_file_tool`: Download workspace files
- `workspace_upload`: Upload files to workspace
- `create_genome_group`: Create genome groups
- `create_feature_group`: Create feature groups
- `get_genome_group_ids`: Get genome IDs from a group
- `get_feature_group_ids`: Get feature IDs from a group

## Installation

1. Create a Python virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Configure the server:
Edit `config.json` to set:
- API URLs (workspace, service, data)
- Server host and port
- Authentication URL
- Optional: Default authentication token

## Configuration

The `config.json` file contains:

```json
{
    "base_url": "https://www.bv-brc.org/api-bulk",
    "workspace_url": "https://p3.theseed.org/services/Workspace",
    "service_api_url": "https://p3.theseed.org/services/app_service",
    "similar_genome_finder_api_url": "https://p3.theseed.org/services/minhash_service",
    "authentication_url": "https://user.patricbrc.org/authenticate",
    "mcp_url": "127.0.0.1",
    "port": 12010,
    "token": ""
}
```

## Usage

### Choosing a Mode

The consolidated server supports two modes:

| Feature | HTTP Mode | STDIO Mode |
|---------|-----------|------------|
| **Use Case** | Web clients, ChatGPT, programmatic access | Claude Desktop, local MCP clients |
| **Authentication** | OAuth2, config token, or header | Environment variable (`KB_AUTH_TOKEN`) |
| **Port** | Requires open port (default: 12010) | No port needed |
| **Security** | OAuth2 flow with user login | Environment variable only |
| **Best For** | Multi-user, web-based access | Single-user, desktop applications |

### Running the Server

#### HTTP Mode (for web clients, ChatGPT, etc.)

Start the HTTP server:
```bash
python http_server.py
```

Or use the module form:
```bash
python -m bvbrc-mcp
```

The server will start on the configured host and port (default: `127.0.0.1:12010`).

**Note:** The module form (`python -m bvbrc-mcp`) defaults to HTTP mode. Use `python -m bvbrc-mcp --stdio` to run in STDIO mode.

#### STDIO Mode (for Claude Desktop, etc.)

Start the STDIO server:
```bash
python stdio_server.py
```

Or set it up in your MCP client configuration (e.g., Claude Desktop):
```json
{
  "mcpServers": {
    "bvbrc": {
      "command": "python",
      "args": ["/path/to/bvbrc-mcp/stdio_server.py"],
      "env": {
        "KB_AUTH_TOKEN": "your_token_here"
      }
    }
  }
}
```

### Authentication

The server supports multiple authentication methods depending on the mode:

#### HTTP Mode Authentication

1. **OAuth2 Flow** (recommended for interactive use):
   - The server provides OAuth2 endpoints for client registration and user authentication
   - Users authenticate through the BV-BRC authentication service
   - Access tokens are automatically managed

2. **Token in Config** (for testing):
   - Set the `token` field in `config.json`
   - Token will be used as the default for all requests

3. **Token in Request** (for API calls):
   - Pass the token as a parameter to each tool call
   - Overrides the config token if provided

4. **Authorization Header** (for programmatic access):
   - Include `Authorization: Bearer <token>` header in HTTP requests
   - Highest priority, overrides all other methods

#### STDIO Mode Authentication

1. **Environment Variable** (primary method):
   - Set `KB_AUTH_TOKEN` environment variable
   - Example: `export KB_AUTH_TOKEN="un=youruser|tokenid=..."`

2. **Token Parameter** (fallback):
   - Pass the token as a parameter to each tool call
   - Useful if environment variable is not set

### Example Tool Calls

#### Query Data
```json
{
  "tool": "query_collection",
  "arguments": {
    "collection": "genome",
    "filter_str": "species:\"Escherichia coli\"",
    "select": "genome_id,genome_name,species,strain",
    "sort": "genome_name"
  }
}
```

#### Submit a Job
```json
{
  "tool": "submit_genome_annotation_app",
  "arguments": {
    "contigs": "/username/home/my_contigs.fasta",
    "scientific_name": "Escherichia coli",
    "output_path": "/username/home",
    "output_file": "my_annotation"
  }
}
```

#### Manage Workspace
```json
{
  "tool": "workspace_ls_tool",
  "arguments": {
    "paths": ["home"]
  }
}
```

## Architecture

### Directory Structure

```
bvbrc-mcp/
├── __init__.py                 # Package initialization
├── __main__.py                 # Entry point for module execution
├── http_server.py              # HTTP server (for web clients, ChatGPT)
├── stdio_server.py             # STDIO server (for Claude Desktop, etc.)
├── config.json                 # Configuration file
├── requirements.txt            # Python dependencies
├── README.md                   # This file
├── token_provider.py           # Unified authentication token handling
├── json_rpc.py                 # JSON-RPC client for API calls
├── auth.py                     # OAuth2 authentication endpoints (HTTP only)
├── tools/                      # Tool registration modules
│   ├── __init__.py
│   ├── data_tools.py           # Data query tools registration
│   ├── service_tools.py        # Service job tools registration
│   └── workspace_tools.py      # Workspace management tools registration
├── functions/                  # Function implementation modules
│   ├── __init__.py
│   ├── data_functions.py       # Data query implementations
│   ├── service_functions.py    # Service job implementations
│   └── workspace_functions.py  # Workspace implementations
└── prompts/                    # Collection schema documentation
    ├── genome.txt
    ├── genome_feature.txt
    └── ...
```

### Design Principles

1. **Unified Authentication**: Single `TokenProvider` class handles all authentication
2. **Modular Tools**: Each service type has its own tools and functions modules
3. **Minimal Code Rewrite**: Direct integration of existing code with path updates
4. **Standard Format**: Follows the structure of individual MCP servers

## Development

### Adding New Tools

1. Add the function implementation to the appropriate `functions/*.py` file
2. Register the tool in the corresponding `tools/*.py` file
3. Update this README with the new tool documentation

### Testing

Each service can be tested independently using the corresponding test scripts from the original servers:
- Data tools: Use the data MCP server tests
- Service tools: Use the service MCP server tests in `../service_mcp_testing/`
- Workspace tools: Use the workspace MCP server tests

## OAuth2 Endpoints

The server provides the following OAuth2 endpoints for integration with clients like ChatGPT:

- `/.well-known/openid-configuration`: OIDC discovery document
- `/oauth2/register`: Client registration endpoint
- `/oauth2/authorize`: User authorization endpoint
- `/oauth2/login`: Login form handler
- `/oauth2/token`: Token exchange endpoint

## License

See the individual service READMEs for license information:
- [bvbrc-data-mcp-server](../bvbrc-data-mcp-server/README.md)
- [bvbrc-service-mcp](../bvbrc-service-mcp/README.md)
- [bvbrc-workspace-mcp](../bvbrc-workspace-mcp/README.md)

## Support

For issues and questions:
- BVBRC website: https://www.bv-brc.org
- BVBRC help: help@bv-brc.org

## Testing

You can test the server in either mode:

### HTTP Mode Testing

```bash
# Start the server
python http_server.py

# In another terminal, test with curl
curl -X POST http://127.0.0.1:12010/tools/list \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your_token_here"
```

### STDIO Mode Testing

```bash
# Set your token
export KB_AUTH_TOKEN="your_token_here"

# Run the server (it will wait for MCP protocol input)
python stdio_server.py
```

## Changelog

### Version 1.0.0 (Initial Release)
- Consolidated data, service, and workspace MCP servers
- Unified authentication with `TokenProvider`
- HTTP server with OAuth2 support for interactive authentication
- STDIO server for desktop MCP clients
- Organized tools and functions into separate modules
- Support for all data, service, and workspace operations

