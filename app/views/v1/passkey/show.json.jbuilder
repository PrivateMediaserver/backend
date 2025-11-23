if @passkey
  json.partial! "passkey", passkey: @passkey
else
  json.nil!
end
