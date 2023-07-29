local amt = 0; 
local subcateg;
local total=0;
function handle_record(record)
        amt = record:get("Total");
        subcateg = record:get("Subcategory");

        if (subcateg == "Mortgage")  then
            amt = -amt;
            record:set("Total",amt);
        end
        total = total+amt;
end
function complete(result)
   result:set("GRANDTOTAL", total);
end