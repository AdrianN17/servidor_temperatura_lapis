local lapis = require("lapis")
local http = require("lapis.nginx.http")
local util = require("lapis.util")
local app = lapis.Application()
app:enable("etlua")
local json_params = require("lapis.application").json_params

app:get("/", function()
  return "Welcome to Lapis " .. require("lapis.version")
end)

app:get("temperatura","/temperatura", function(self)

  self.title = "temperatura"

  local body, status_code, headers = http.simple({
    url = "http://192.168.0.25",
    method = "POST",
    headers = {
      ["content-type"] = "application/json"
    }
  })

  self.time = 0
  self.temVal = {}

  

  if status_code == 200 then

    self.temVal = util.from_json(body)


    local date_table = os.date("*t")
    local ms = string.match(tostring(os.clock()), "%d%.(%d+)")
    local hour, minute, second = date_table.hour, date_table.min, date_table.sec
    local year, month, day = date_table.year, date_table.month, date_table.wday
    local result = string.format("%d-%d-%d %d:%d", year, month, day, hour, minute)

    self.time  = result
  end

  return { render = true}

end)


--[[app:get("/hola", function(self)
  return {json={saludo = "holamundo"}}
end)

app:match("/page/:page", function(self)
  print(self.params.page)
end)]]

--[[app:post("/prueba", function (self)
  print(tostring(self.res))
  print(tostring(self.req))
end)]]

--[[app:match("/prueba", json_params(function(self)
  return {json = {resultado = self.params.value}}
end))]]

return app
