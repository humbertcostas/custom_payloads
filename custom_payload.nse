local nmap = require "nmap"
local table = require "table"
local luasocket = require "socket"
local stdnse = require "stdnse"

description = [[
  SEND custom payload adding "_IP_PORT/TCP" info.
]]

--- nmap <options> --script mypayload.nse --script-args "custom.payload='TEST_PAYLOAD_', verbose='true'"

author = "Humbert Costas <@humbertcostas>"

license = "Same as Nmap" --See https://nmap.org/book/man-legal.html

portrule = function(host, port)
  local identd = nmap.get_port_state(host, port)
  return identd ~= nil
          and identd.state == "open"
          and identd.protocol == "tcp"
end

action = function(host, port)
  local my_payload = stdnse.get_script_args("custom-payload")
  local target_info = stdnse.get_script_args("verbose")

  if target_info then
    my_payload = my_payload .. host.ip .. "_" .. port.number .. "/" .. port.protocol
  end

  local myclient = nmap.new_socket()

  myclient:connect(host.ip, port.number)
  myclient:send(my_payload)
  myclient:close()

  return my_payload
end
