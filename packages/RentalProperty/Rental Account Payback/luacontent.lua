    local total=0
    local paybacktotal=0
    local amt = 0;

function handle_record(record)
        if tonumber(record:get("ToAccountID")) ~= 17 then
            amt = tonumber(record:get("Amount"))
            total = total-amt;
            --added 1/3/16
            record:set("Amount",-amt);    
            -- end add
        else
            total = total+tonumber(record:get("Amount"));
        end

    transtime = os.time{year=tonumber(record:get("Year")), month=tonumber(record:get("Month")), day=tonumber(record:get("Day"))}
   if transtime > os.time() and (record:get("Status") == "V" or record:get("Status") == "F") and tonumber(record:get("ToAccountID")) ~= 17 then

          paybacktotal = paybacktotal + tonumber(record:get("Amount"));

  end
end
function complete(result)
local value = string.format("%.2f", total);
local paybackvalue = string.format("%.2f", paybacktotal);
   result:set("TOTAL", value);
   result:set("PAYBACKTOTAL", paybackvalue);
result:set("TODAY", os.date("%m/%d/%Y"));
end