require("module").Module._initPaths();
require("dotenv").config({ path: "/home/ubuntu/.env" });

module.exports = {
  apps: [
    {
      name: "n8n",
      script: "n8n",
      env: {
        NODE_ENV: "production",
        ...require("dotenv").config({ path: "/home/ubuntu/.env" }).parsed,
      },
    },
  ],
};
