local running_balance = 0
local outflow_since_salary = nil

function handle_record(record)
    local raw_amount = tonumber(record:get("amount")) or 0
    local transcode = record:get("TRANSCODE")
    local toacct = tonumber(record:get("TOACCOUNTID"))
    local catid = tonumber(record:get("CATEGID")) or 0

    local signed_amount = 0

    if transcode == "Deposit" then
        signed_amount = raw_amount

    elseif transcode == "Withdrawal" then
        signed_amount = -raw_amount

    elseif transcode == "Transfer" then
        if toacct == 44 then
            signed_amount = raw_amount
        else
            signed_amount = -raw_amount
        end
    end

    running_balance = running_balance + signed_amount

    record:set("signed_amount", string.format("%.2f", signed_amount))
    record:set("running_balance", string.format("%.2f", running_balance))

    -- Salary row (category 69)
    if catid == 69 then
        -- Output prior cycle's depletion
        if outflow_since_salary ~= nil then
            record:set(
                "drawdown_since_last_salary",
                string.format("%.2f", outflow_since_salary)
            )
        else
            record:set("drawdown_since_last_salary", "")
        end

        -- Reset for new cycle
        outflow_since_salary = 0

    else
        -- Accumulate only negative cash flows
        if outflow_since_salary ~= nil and signed_amount < 0 then
            outflow_since_salary = outflow_since_salary + (signed_amount)
        end

        record:set("drawdown_since_last_salary", "")
    end
end
