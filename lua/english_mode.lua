local EN_MODE_OPTION="english_mode"
local ASCII_PUNCT_OPTION="ascii_punct"

local Processor={}

function Processor.init(env)
  env.ecdict_switch_keyrepr= __ecdict_switch_keyrepr and __ecdict_switch_keyrepr or "Shift+Shift_R"
end

function Processor.func(key,env)
  local Rejected,Accepted,Noop=0,1,2
  local keyrepr = key:repr()
  local context=env.engine.context
  local has_menu = context:has_menu()
  local is_composing = context:is_composing()
  if not context:get_option("ascii_mode") then
    if keyrepr == env.ecdict_switch_keyrepr then
      if context:get_option(EN_MODE_OPTION) then
        context:set_option(EN_MODE_OPTION, false)
        context:set_option(ASCII_PUNCT_OPTION, false)
      else
        context:set_option(EN_MODE_OPTION, true)
        context:set_option(ASCII_PUNCT_OPTION, true)
      end
      context:refresh_non_confirmed_composition()
      return Accepted
    end
    if not is_composing or not context:get_option(EN_MODE_OPTION) then return Noop end
    local key_char=  key.modifier <=1  and key.keycode <128 and string.char(key.keycode) or ""
    if has_menu then
      if key_char == " " then
        context:commit()
        env.engine:commit_text(key_char)
        return Accepted
      end
    end
  end
  return Noop
end

local Filter={}

function Filter.func(input, env)
  local context = env.engine.context
  for cand in input:iter() do
    if cand.text:match("^[%a%d '%-]+$") then -- cand.text contains only letters/numbers/ /'/-
      yield(cand)
    elseif not context:get_option(EN_MODE_OPTION) then
      yield(cand)
    end
  end
end

return { P = Processor, F = Filter }
