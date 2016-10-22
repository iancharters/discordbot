defmodule Rec do
  require Record
  Record.defrecord :bot,
                    [
                      heartbeat_interval: 0,
                      session_id: 0,
                      user_id: 0,
                      sequence: 0,
                      email: "",
                      gateway: ""
                    ]
end
