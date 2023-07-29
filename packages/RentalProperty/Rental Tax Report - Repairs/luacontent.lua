    local total=0
function handle_record(record)
            total = total+tonumber(record:get("Amount"));
end
function complete(result)
   result:set("TOTAL", total);
end