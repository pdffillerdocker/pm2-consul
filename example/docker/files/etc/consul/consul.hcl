template {
  source = "/etc/consul/templates/env.ctmpl"
  destination = "/app/.env"
  
  command = "pm2 reload app"
}
