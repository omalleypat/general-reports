-- Lua: Replace zeros with blanks in all numeric fields
function handle_record(r)
  -- loop over known columns
  local cols = {"Y1","Y2","Y3","Y4","Y5","TOTAL"}

  for _,col in ipairs(cols) do
    local val = r:get(col)
    -- convert to number and check
    if tonumber(val) == 0 then
      r:set(col, "")
    else
      -- optional: format non-zero numbers with 2 decimals
      r:set(col, string.format("%.2f", tonumber(val)))
    end
  end
end
