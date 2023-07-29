    local total=0
function handle_record(record)
        if record:get("TransactionType") == "Transfer"  and tonumber(record:get("ToAccountID")) ~= 17 then
            total = total-tonumber(record:get("Amount"));
        else
            total = total+tonumber(record:get("Amount"));
        end
end
function complete(result)
   result:set("TOTAL", total);
end