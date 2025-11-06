#!/bin/bash

# Example curl requests for BVBRC MCP Server
# Replace YOUR_TOKEN_HERE with your actual authentication token

TOKEN="un=clark.cucinell@patricbrc.org|tokenid=fda4dd89-1892-4a0e-bef4-1675463c21f3|expiry=1775409707|client_id=clark.cucinell@patricbrc.org|token_type=Bearer|scope=user|roles=admin|SigningSubject=https://user.patricbrc.org/public_key|sig=468fed796b71a69a391d79c074cb7a2fdf5c912aa9be2d28b2ee7194f386b06c89264adfaa51205037ed46b4fd9323bbb28a7fed8643a472638ebfb70dfaff9f15186d9cd9658953a7d9c916ec10b7108ebb292396468c0dc02fea15809bb735a5d05a876d2f0e7b4c87803f1fdd78d62b32dfd08ac41d7c54cee601d02c7c52"

ip_addr="140.221.78.67"

# Example 1: List all available collections
curl -X POST http://${ip_addr}:12007/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "solr_collections",
      "arguments": {}
    }
  }'

# Example 2: Query a collection with filters
curl -X POST http://localhost:12007/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/call",
    "params": {
      "name": "query_collection",
      "arguments": {
        "collection": "genome",
        "filter_str": "genome_id:123.45",
        "countOnly": false
      }
    }
  }'

# Example 3: Query with filters, select fields, and sorting
curl -X POST http://localhost:12007/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 3,
    "method": "tools/call",
    "params": {
      "name": "query_collection",
      "arguments": {
        "collection": "genome",
        "filter_str": "species:\"Escherichia coli\"",
        "select": "genome_id,genome_name,species",
        "sort": "genome_id",
        "countOnly": false
      }
    }
  }'

# Example 4: Get query instructions
curl -X POST http://localhost:12007/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 4,
    "method": "tools/call",
    "params": {
      "name": "solr_query_instructions",
      "arguments": {}
    }
  }'

# Example 5: Count only query (faster for getting totals)
curl -X POST http://localhost:12007/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 5,
    "method": "tools/call",
    "params": {
      "name": "query_collection",
      "arguments": {
        "collection": "genome",
        "filter_str": "species:\"Escherichia coli\"",
        "countOnly": true
      }
    }
  }'

# Example 6: Using the configured host/IP from config.json
curl -X POST http://140.221.78.67:12007/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 6,
    "method": "tools/call",
    "params": {
      "name": "solr_collections",
      "arguments": {}
    }
  }'

