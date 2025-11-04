module.exports = {
  apps: [
    {
      name: "bvbrc-mcp-server",
      script: "http_server.py",
      interpreter: "/home/ac.cucinell/bvbrc-dev/Copilot/BVBRC-MCP-Servers/bvbrc_mcp_env/bin/python3",
      cwd: "/home/ac.cucinell/bvbrc-dev/Copilot/BVBRC-MCP-Servers/bvbrc-mcp-server",
      autorestart: true
    }
  ]
};

