TOKEN="un=clark.cucinell@patricbrc.org|tokenid=fda4dd89-1892-4a0e-bef4-1675463c21f3|expiry=1775409707|client_id=clark.cucinell@patricbrc.org|token_type=Bearer|scope=user|roles=admin|SigningSubject=https://user.patricbrc.org/public_key|sig=468fed796b71a69a391d79c074cb7a2fdf5c912aa9be2d28b2ee7194f386b06c89264adfaa51205037ed46b4fd9323bbb28a7fed8643a472638ebfb70dfaff9f15186d9cd9658953a7d9c916ec10b7108ebb292396468c0dc02fea15809bb735a5d05a876d2f0e7b4c87803f1fdd78d62b32dfd08ac41d7c54cee601d02c7c52"

# Example 1: List all available collections
curl -X POST https://dev-7.bv-brc.org/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "solr_collections",
      "arguments": {}
    }
  }'
