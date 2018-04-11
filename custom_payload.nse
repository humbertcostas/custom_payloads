local nmap = require "nmap"
local table = require "table"
local luasocket = require "socket"

description = [[
  SEND custom payload adding "_IP_PORT/TCP" info.
]]

--- nmap <options> --script mypayload.nse --script-args "custom.payload='TEST_PAYLOAD_'"

author = "Humbert Costas <@humbertcostas>"

license = "Same as Nmap" --See https://nmap.org/book/man-legal.html

portrule = function(host, port)
  local identd = nmap.get_port_state(host, port)
  return identd ~= nil
          and identd.state == "open"
          and identd.protocol == "tcp"
end

action = function(host, port)
  local my_payload = "TEST_PAYLOAD_" .. host.ip .. "_" .. port.number .."/TCP_madafaka"
  local myclient = nmap.new_socket()

  myclient:connect(host.ip, port.number)
  myclient:send(my_payload)
  myclient:close()

  return my_payload
end
